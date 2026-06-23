# Architektur - Sprint 3

SecuQuest besteht weiterhin aus fünf Containern:

- Frontend Service mit Nginx
- User Service mit Flask
- Phishing Service mit Flask
- Scoring Service mit Flask
- PostgreSQL Datenbank

## Ablauf

```text
Benutzer
  |
  v
Frontend
  |
  | Registrierung / Login
  v
User Service
  |
  v
PostgreSQL

Frontend
  |
  | GET /emails
  v
Phishing Service
  |
  v
PostgreSQL

Frontend
  |
  | POST /submit
  v
Scoring Service
  |
  v
PostgreSQL

Frontend
  |
  | GET /leaderboard
  v
Scoring Service
  |
  v
PostgreSQL
```

## Wichtige Design-Entscheidung

Der Phishing Service liefert keine korrekten Lösungen an das Frontend. Die Auswertung erfolgt ausschliesslich im Scoring Service. Dadurch sind die korrekten Antworten nicht direkt im Browser sichtbar.

## Leaderboard

Das Leaderboard wird aus den Tabellen `scores` und `users` gebildet. Der Scoring Service gibt pro Benutzer den besten Score zurück und sortiert die Einträge absteigend nach Punkten.
