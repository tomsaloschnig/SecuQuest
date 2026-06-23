import os
import psycopg2
from flask import Flask, jsonify, request
from flask_cors import CORS
from werkzeug.security import generate_password_hash, check_password_hash

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

def ensure_schema():
    connection = get_db_connection()
    cursor = connection.cursor()
    cursor.execute("ALTER TABLE users ADD COLUMN IF NOT EXISTS password_hash TEXT;")
    connection.commit()
    cursor.close()
    connection.close()

@app.route("/health")
def health():
    return jsonify({"status": "ok", "service": "user-service"})

@app.route("/db-check")
def db_check():
    try:
        ensure_schema()
        return jsonify({"status": "ok", "service": "user-service", "database": "connected"})
    except Exception as error:
        return jsonify({"status": "error", "message": str(error)}), 500

@app.route("/register", methods=["POST"])
def register():
    ensure_schema()
    data = request.get_json() or {}
    username = str(data.get("username", "")).strip()
    password = str(data.get("password", "")).strip()

    if not username or not password:
        return jsonify({"status": "error", "message": "Benutzername und Passwort sind erforderlich."}), 400
    if len(username) < 3:
        return jsonify({"status": "error", "message": "Der Benutzername muss mindestens 3 Zeichen enthalten."}), 400
    if len(password) < 4:
        return jsonify({"status": "error", "message": "Das Passwort muss mindestens 4 Zeichen enthalten."}), 400

    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute(
            "INSERT INTO users (username, password_hash) VALUES (%s, %s) RETURNING id, username;",
            (username, generate_password_hash(password)),
        )
        row = cursor.fetchone()
        connection.commit()
        cursor.close()
        connection.close()
        return jsonify({"status": "ok", "message": "Registrierung erfolgreich.", "user": {"id": row[0], "username": row[1]}}), 201
    except psycopg2.errors.UniqueViolation:
        return jsonify({"status": "error", "message": "Dieser Benutzername ist bereits vergeben."}), 409
    except Exception as error:
        return jsonify({"status": "error", "message": str(error)}), 500

@app.route("/login", methods=["POST"])
def login():
    ensure_schema()
    data = request.get_json() or {}
    username = str(data.get("username", "")).strip()
    password = str(data.get("password", "")).strip()

    if not username or not password:
        return jsonify({"status": "error", "message": "Benutzername und Passwort sind erforderlich."}), 400

    try:
        connection = get_db_connection()
        cursor = connection.cursor()
        cursor.execute("SELECT id, username, password_hash FROM users WHERE username = %s;", (username,))
        row = cursor.fetchone()
        cursor.close()
        connection.close()

        if not row:
            return jsonify({"status": "error", "message": "Benutzer wurde nicht gefunden."}), 401

        user_id, db_username, password_hash = row
        if not password_hash or not check_password_hash(password_hash, password):
            return jsonify({"status": "error", "message": "Das Passwort ist nicht korrekt."}), 401

        return jsonify({"status": "ok", "message": "Login erfolgreich.", "user": {"id": user_id, "username": db_username}})
    except Exception as error:
        return jsonify({"status": "error", "message": str(error)}), 500

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
