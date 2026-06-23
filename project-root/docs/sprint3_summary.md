# Sprint 3 - Technische Zusammenfassung

In Sprint 3 wurde SecuQuest abgabefertig erweitert. Der Fokus lag auf Leaderboard, UI-Verbesserungen, Testing und Stabilisierung.

## Umgesetzte technische Punkte

- Leaderboard-Endpunkt im Scoring Service erweitert
- Leaderboard nach bestem Score sortiert
- Leaderboard-Seite im Frontend ergänzt
- Navigation um Leaderboard erweitert
- Dashboard, Game, Resultatseite und Leaderboard visuell vereinheitlicht
- Resultatseite mit KPIs ergänzt
- Anzeige von richtigen und falschen Antworten verbessert
- Testdokumentation unter `docs/testing.md` erstellt
- API-Dokumentation aktualisiert
- Setup-Dokumentation aktualisiert

## Abschlussstand

SecuQuest kann lokal mit Docker Compose gestartet werden. Benutzer können sich registrieren, einloggen, das Phishing Game spielen, eine Auswertung erhalten und den eigenen Score im Leaderboard sehen.

Damit liegt ein stabiler und präsentationsbereiter MVP vor.


## Ergänzung: Klickbares Leaderboard

Das Leaderboard wurde erweitert. Jeder Eintrag ist nun klickbar. Beim Klick wird über den neuen Endpunkt `/result/<score_id>` das gespeicherte Resultat geladen und auf der Resultatseite angezeigt.

Damit kann man im Leaderboard nicht nur Scores vergleichen, sondern auch nachvollziehen, welche Antworten zu einem Score geführt haben.
