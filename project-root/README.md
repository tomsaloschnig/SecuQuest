# SecuQuest praktisches Setup - Sprint 3

Dieses Verzeichnis enthält die abgabefertige technische Umsetzung für Sprint 3.

## Enthaltene Funktionen

- Registrierung und Login
- Passwort-Hashing im User Service
- Login-Pflicht für Dashboard, Game und Leaderboard
- Phishing Game mit 10 zufälligen Aufgaben aus 15 Szenarien
- Keine Lösungsausgabe im Phishing Service
- Serverseitige Auswertung im Scoring Service
- Speicherung von Antworten und Scores in PostgreSQL
- Verbesserte Resultatseite mit KPIs, Begründungen und Lerntipps
- Leaderboard im Frontend
- Leaderboard-Endpunkt im Scoring Service
- Sortierung nach bestem Score
- Testdokumentation in `docs/testing.md`

## Start

Bei Änderungen an `database/init.sql` oder wenn alte Seed-Daten sichtbar sind, die Datenbank zurücksetzen:

```bash
cd Fachliches/project-root
docker compose down -v
docker compose up --build
```

Frontend:

```text
http://localhost:8080
```

## Wichtig

Nach einem Datenbank-Reset müssen Benutzer neu registriert werden, weil das PostgreSQL-Volume gelöscht wurde.

## Healthchecks

```bash
curl http://localhost:5001/health
curl http://localhost:5002/health
curl http://localhost:5003/health
```

## Leaderboard testen

```bash
curl http://localhost:5003/leaderboard
```


## Ergänzung: Klickbares Leaderboard

Im Leaderboard kann auf einen Benutzer geklickt werden. Danach wird das gespeicherte Resultat dieses Scores angezeigt.

Wichtig: Durch die neue Verknüpfung zwischen `answers` und `scores` muss die Datenbank einmal neu aufgebaut werden:

```bash
docker compose down -v
docker compose up --build
```
