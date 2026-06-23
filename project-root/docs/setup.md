# Setup - Sprint 3

## Start

```bash
cd Fachliches/project-root
docker compose down -v
docker compose up --build
```

## Frontend öffnen

```text
http://localhost:8080
```

## Hinweis zu PostgreSQL-Volumes

Wenn `database/init.sql` geändert wurde, muss das Volume mit `docker compose down -v` gelöscht werden. Sonst verwendet PostgreSQL weiterhin die alten Daten.

## Manuelle Prüfung

```bash
curl http://localhost:5001/health
curl http://localhost:5002/health
curl http://localhost:5003/health
curl http://localhost:5002/emails
curl http://localhost:5003/leaderboard
```
