# Testdokumentation - Sprint 3

Diese Datei beschreibt die wichtigsten technischen Tests für den Abschluss-Sprint von SecuQuest. Die Tests können im Browser, mit curl oder mit Postman durchgeführt werden.

## Test 1 - Docker Compose Start

### Ziel

Prüfen, ob alle Container korrekt starten.

### Befehl

```bash
cd Fachliches/project-root
docker compose down -v
docker compose up --build
```

### Erwartetes Ergebnis

Alle Services starten ohne Fehler:

- Frontend
- User Service
- Phishing Service
- Scoring Service
- PostgreSQL

Das Frontend ist unter `http://localhost:8080` erreichbar.

## Test 2 - Healthchecks

### Ziel

Prüfen, ob die Backend-Services erreichbar sind.

### Befehle

```bash
curl http://localhost:5001/health
curl http://localhost:5002/health
curl http://localhost:5003/health
```

### Erwartetes Ergebnis

Jeder Service gibt eine JSON-Antwort mit `status: ok` zurück.

## Test 3 - Registrierung

### Ziel

Prüfen, ob ein neuer Benutzer erstellt wird und das Passwort nicht im Klartext verarbeitet wird.

### Befehl

```bash
curl -X POST http://localhost:5001/register \
  -H "Content-Type: application/json" \
  -d '{"username": "tom", "password": "test1234"}'
```

### Erwartetes Ergebnis

Der User Service gibt eine erfolgreiche Registrierung zurück. Der Benutzer wird in PostgreSQL gespeichert.

## Test 4 - Login

### Ziel

Prüfen, ob ein registrierter Benutzer sich anmelden kann.

### Befehl

```bash
curl -X POST http://localhost:5001/login \
  -H "Content-Type: application/json" \
  -d '{"username": "tom", "password": "test1234"}'
```

### Erwartetes Ergebnis

Der User Service gibt `Login erfolgreich` und ein Benutzerobjekt zurück.

## Test 5 - Login-Pflicht im Browser

### Ziel

Prüfen, ob Dashboard, Game und Leaderboard ohne Login gesperrt sind.

### Vorgehen

1. `http://localhost:8080` öffnen.
2. Prüfen, ob direkt das Loginformular angezeigt wird.
3. Prüfen, ob Dashboard, Game und Leaderboard in der Navigation deaktiviert sind.
4. Registrieren oder einloggen.
5. Prüfen, ob Dashboard, Game, Leaderboard und Logout aktiviert werden.

### Erwartetes Ergebnis

Ohne Login kann kein Spiel gestartet werden. Nach Login sind die Funktionen verfügbar.

## Test 6 - Phishing-Szenarien abrufen

### Ziel

Prüfen, ob der Phishing Service zehn zufällige Szenarien liefert, ohne die korrekte Lösung an das Frontend auszugeben.

### Befehl

```bash
curl http://localhost:5002/emails
```

### Erwartetes Ergebnis

Die Antwort enthält zehn Szenarien. Die Felder `is_phishing`, `explanation` und `learning_tip` sind in dieser Antwort nicht enthalten.

## Test 7 - Spielablauf im Browser

### Ziel

Prüfen, ob das Phishing Game vollständig spielbar ist.

### Vorgehen

1. Im Browser einloggen.
2. Spiel über das Dashboard starten.
3. Zehn Szenarien bewerten.
4. Nach der letzten Antwort die Resultatseite prüfen.

### Erwartetes Ergebnis

Nach jeder Antwort wird die nächste Aufgabe angezeigt. Nach zehn Antworten erscheint die Resultatseite.

## Test 8 - Scoreberechnung

### Ziel

Prüfen, ob Antworten serverseitig ausgewertet und gespeichert werden.

### Erwartetes Ergebnis

Der Scoring Service gibt Punkte, maximale Punktzahl und eine Liste mit richtigen und falschen Antworten zurück.

## Test 9 - Leaderboard API

### Ziel

Prüfen, ob gespeicherte Scores im Leaderboard angezeigt werden.

### Befehl

```bash
curl http://localhost:5003/leaderboard
```

### Erwartetes Ergebnis

Das Leaderboard zeigt Benutzername, Score, maximale Punktzahl und Anzahl Versuche. Die Einträge sind nach bestem Score absteigend sortiert.

## Test 10 - Leaderboard im Frontend

### Ziel

Prüfen, ob das Leaderboard über die Oberfläche erreichbar ist.

### Vorgehen

1. Im Browser einloggen.
2. Mindestens ein Spiel abschliessen.
3. Auf `Leaderboard` klicken.

### Erwartetes Ergebnis

Das Leaderboard wird im Frontend angezeigt und enthält den gespeicherten Score.


## Test 11 - Leaderboard-Eintrag anklicken

### Ziel

Prüfen, ob ein Benutzer über das Leaderboard auf die gespeicherte Resultatseite eines Scores wechseln kann.

### Vorgehen

1. Im Browser einloggen.
2. Mindestens ein Spiel abschliessen.
3. Das Leaderboard öffnen.
4. Auf einen Leaderboard-Eintrag klicken.

### Erwartetes Ergebnis

Nach dem Klick wird die Resultatseite des ausgewählten Scores angezeigt. Es werden Punkte, richtige und falsche Antworten, Begründungen und Lerntipps angezeigt.

### API-Test

```bash
curl http://localhost:5003/result/1
```

Der Test ist erfolgreich, wenn ein gespeichertes Resultat als JSON zurückgegeben wird.
