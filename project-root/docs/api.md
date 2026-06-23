# API Dokumentation - Sprint 3

## User Service

### GET /health

```bash
curl http://localhost:5001/health
```

### POST /register

Registriert einen neuen Benutzer. Das Passwort wird im Service gehasht und nicht im Klartext gespeichert.

```bash
curl -X POST http://localhost:5001/register \
  -H "Content-Type: application/json" \
  -d '{"username": "tom", "password": "test1234"}'
```

### POST /login

```bash
curl -X POST http://localhost:5001/login \
  -H "Content-Type: application/json" \
  -d '{"username": "tom", "password": "test1234"}'
```

## Phishing Service

### GET /emails

Liefert zufällig 10 von 15 Szenarien. Die korrekte Lösung wird nicht ausgeliefert.

```bash
curl http://localhost:5002/emails
```

## Scoring Service

### POST /submit

Nimmt die Antworten eines Benutzers entgegen, prüft diese gegen die internen Lösungen in PostgreSQL, speichert die Antworten und legt einen Score ab.

### GET /leaderboard

Liefert die Top 10 Benutzer sortiert nach bestem Score. Pro Benutzer wird der beste gespeicherte Score angezeigt.

```bash
curl http://localhost:5003/leaderboard
```


### GET /result/<score_id>

Lädt ein gespeichertes Resultat anhand der Score-ID. Dieser Endpunkt wird verwendet, wenn ein Benutzer im Leaderboard auf einen Eintrag klickt.

```bash
curl http://localhost:5003/result/1
```

Die Antwort enthält Score, Benutzername und die gespeicherten Einzelantworten inklusive Begründungen und Lerntipps.
