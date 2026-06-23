import os
import psycopg2
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


def get_db_connection():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "postgres"),
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME", "secuquest"),
        user=os.getenv("DB_USER", "secuquest_user"),
        password=os.getenv("DB_PASSWORD", "secuquest_password"),
    )


@app.route("/health")
def health():
    return jsonify({"status": "ok", "service": "scoring-service"})


@app.route("/db-check")
def db_check():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT 1;")
        cursor.close()
        connection.close()
        return jsonify({"status": "ok", "service": "scoring-service", "database": "connected"})
    except Exception as error:
        return jsonify({"status": "error", "message": str(error)}), 500


@app.route("/submit", methods=["POST"])
def submit():
    data = request.get_json() or {}
    user_id = data.get("user_id")
    answers = data.get("answers", [])

    if not user_id:
        return jsonify({"status": "error", "message": "user_id ist erforderlich."}), 400

    if not isinstance(answers, list) or len(answers) != 10:
        return jsonify({"status": "error", "message": "Es müssen genau 10 Antworten gesendet werden."}), 400

    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("SELECT id, username FROM users WHERE id = %s;", (user_id,))
        user_row = cursor.fetchone()
        if not user_row:
            cursor.close()
            connection.close()
            return jsonify({
                "status": "error",
                "message": "Benutzer wurde in der Datenbank nicht gefunden. Bitte neu einloggen oder neu registrieren.",
                "code": "USER_NOT_FOUND"
            }), 404

        username = user_row[1]
        points = 0
        results = []
        answer_rows = []

        for answer in answers:
            email_id = answer.get("email_id")
            user_answer = bool(answer.get("is_phishing"))

            cursor.execute("""
                SELECT title, subject, sender_name, sender_email, is_phishing, explanation, learning_tip
                FROM phishing_emails
                WHERE id = %s;
            """, (email_id,))
            row = cursor.fetchone()

            if not row:
                continue

            title, subject, sender_name, sender_email, correct_answer, explanation, learning_tip = row
            is_correct = user_answer == bool(correct_answer)

            if is_correct:
                points += 1

            answer_rows.append((user_id, email_id, user_answer, is_correct))

            results.append({
                "email_id": email_id,
                "title": title,
                "subject": subject,
                "sender_name": sender_name,
                "sender_email": sender_email,
                "user_answer": user_answer,
                "correct_answer": bool(correct_answer),
                "is_correct": is_correct,
                "explanation": explanation,
                "learning_tip": learning_tip
            })

        cursor.execute(
            "INSERT INTO scores (user_id, points, max_points) VALUES (%s, %s, %s) RETURNING id;",
            (user_id, points, 10),
        )
        score_id = cursor.fetchone()[0]

        for answer_row in answer_rows:
            cursor.execute(
                """
                INSERT INTO answers (user_id, score_id, email_id, user_answer, is_correct)
                VALUES (%s, %s, %s, %s, %s);
                """,
                (answer_row[0], score_id, answer_row[1], answer_row[2], answer_row[3]),
            )

        connection.commit()
        cursor.close()
        connection.close()

        return jsonify({
            "status": "ok",
            "view_mode": "current",
            "score_id": score_id,
            "username": username,
            "points": points,
            "max_points": 10,
            "results": results
        })
    except Exception as error:
        return jsonify({"status": "error", "message": str(error)}), 500


@app.route("/leaderboard")
def leaderboard():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            WITH ranked_scores AS (
                SELECT
                    scores.id,
                    scores.user_id,
                    scores.points,
                    scores.max_points,
                    scores.created_at,
                    ROW_NUMBER() OVER (
                        PARTITION BY scores.user_id
                        ORDER BY scores.points DESC, scores.created_at ASC
                    ) AS row_number,
                    COUNT(scores.id) OVER (
                        PARTITION BY scores.user_id
                    ) AS attempts
                FROM scores
            )
            SELECT
                users.username,
                ranked_scores.id AS score_id,
                ranked_scores.points,
                ranked_scores.max_points,
                ranked_scores.attempts,
                ranked_scores.created_at
            FROM ranked_scores
            JOIN users ON users.id = ranked_scores.user_id
            WHERE ranked_scores.row_number = 1
            ORDER BY ranked_scores.points DESC, ranked_scores.created_at ASC
            LIMIT 10;
        """)
        rows = cursor.fetchall()
        cursor.close()
        connection.close()

        entries = []
        for index, row in enumerate(rows):
            entries.append({
                "rank": index + 1,
                "username": row[0],
                "score_id": row[1],
                "points": row[2],
                "max_points": row[3],
                "attempts": row[4],
                "created_at": row[5].isoformat()
            })

        return jsonify({"status": "ok", "leaderboard": entries})
    except Exception as error:
        return jsonify({"status": "error", "message": str(error)}), 500


@app.route("/result/<int:score_id>")
def stored_result(score_id):
    try:
        connection = get_db_connection()
        cursor = connection.cursor()

        cursor.execute("""
            SELECT scores.id, users.username, scores.points, scores.max_points, scores.created_at
            FROM scores
            JOIN users ON users.id = scores.user_id
            WHERE scores.id = %s;
        """, (score_id,))
        score_row = cursor.fetchone()

        if not score_row:
            cursor.close()
            connection.close()
            return jsonify({"status": "error", "message": "Resultat wurde nicht gefunden."}), 404

        cursor.execute("""
            SELECT
                phishing_emails.id,
                phishing_emails.title,
                phishing_emails.subject,
                phishing_emails.sender_name,
                phishing_emails.sender_email,
                answers.user_answer,
                phishing_emails.is_phishing,
                answers.is_correct,
                phishing_emails.explanation,
                phishing_emails.learning_tip
            FROM answers
            JOIN phishing_emails ON phishing_emails.id = answers.email_id
            WHERE answers.score_id = %s
            ORDER BY answers.id ASC;
        """, (score_id,))
        rows = cursor.fetchall()

        cursor.close()
        connection.close()

        results = []
        for row in rows:
            results.append({
                "email_id": row[0],
                "title": row[1],
                "subject": row[2],
                "sender_name": row[3],
                "sender_email": row[4],
                "user_answer": bool(row[5]),
                "correct_answer": bool(row[6]),
                "is_correct": bool(row[7]),
                "explanation": row[8],
                "learning_tip": row[9]
            })

        return jsonify({
            "status": "ok",
            "view_mode": "leaderboard",
            "score_id": score_row[0],
            "username": score_row[1],
            "points": score_row[2],
            "max_points": score_row[3],
            "created_at": score_row[4].isoformat(),
            "results": results
        })
    except Exception as error:
        return jsonify({"status": "error", "message": str(error)}), 500


@app.route("/score", methods=["POST"])
def score_alias():
    return submit()


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
