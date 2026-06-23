import os
import psycopg2
from flask import Flask, jsonify
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
    return jsonify({"status": "ok", "service": "phishing-service"})

@app.route("/db-check")
def db_check():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT COUNT(*) FROM phishing_emails;")
        count = cursor.fetchone()[0]
        cursor.close()
        connection.close()
        return jsonify({"status": "ok", "service": "phishing-service", "database": "connected", "email_count": count})
    except Exception as error:
        return jsonify({"status": "error", "message": str(error)}), 500

@app.route("/emails")
def emails():
    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("""
            SELECT id, type, title, headline, intro, sender_name, sender_email, recipient,
                   subject, content, link_or_attachment
            FROM phishing_emails
            ORDER BY random()
            LIMIT 10;
        """)
        rows = cursor.fetchall()
        cursor.close()
        connection.close()

        result = []
        for row in rows:
            result.append({
                "id": row[0],
                "type": row[1],
                "title": row[2],
                "headline": row[3],
                "intro": row[4],
                "sender_name": row[5],
                "sender_email": row[6],
                "recipient": row[7],
                "subject": row[8],
                "content": row[9],
                "link_or_attachment": row[10]
            })

        return jsonify({"status": "ok", "emails": result})
    except Exception as error:
        return jsonify({"status": "error", "message": str(error)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
