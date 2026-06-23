DROP TABLE IF EXISTS answers;
DROP TABLE IF EXISTS scores;
DROP TABLE IF EXISTS phishing_emails;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE phishing_emails (
    id SERIAL PRIMARY KEY,
    type VARCHAR(30) NOT NULL,
    title VARCHAR(255) NOT NULL,
    headline VARCHAR(255) NOT NULL,
    intro TEXT NOT NULL,
    sender_name VARCHAR(255) NOT NULL,
    sender_email VARCHAR(255) NOT NULL,
    recipient VARCHAR(255),
    subject VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    link_or_attachment TEXT,
    is_phishing BOOLEAN NOT NULL,
    explanation TEXT NOT NULL,
    learning_tip TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE scores (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    points INTEGER NOT NULL DEFAULT 0,
    max_points INTEGER NOT NULL DEFAULT 10,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE answers (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE CASCADE,
    score_id INTEGER REFERENCES scores(id) ON DELETE CASCADE,
    email_id INTEGER REFERENCES phishing_emails(id) ON DELETE CASCADE,
    user_answer BOOLEAN NOT NULL,
    is_correct BOOLEAN NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO phishing_emails
(type, title, headline, intro, sender_name, sender_email, recipient, subject, content, link_or_attachment, is_phishing, explanation, learning_tip)
VALUES
(
    'email',
    'PayPal Rechnung',
    'Hier ist Ihre Rechnung',
    'Eine Rechnung wirkt auf den ersten Blick professionell. Prüfen Sie Absender, Link und Inhalt sehr genau.',
    'PayPal',
    'service@paypal.com',
    'An mich',
    'Ihre Rechnung ist verfügbar',
    'Hallo, Ihre PayPal-Rechnung ist nun verfügbar. Sie können die Details direkt in Ihrem PayPal-Konto prüfen. Falls Sie diese Rechnung nicht kennen, melden Sie sich bitte in Ihrem Konto an und prüfen Sie Ihre Aktivitäten.',
    'https://www.paypal.com/myaccount/activities',
    FALSE,
    'Diese E-Mail ist legitim. Absender und Link verwenden paypal.com und die Nachricht fordert nicht dazu auf, Daten auf einer fremden Webseite einzugeben.',
    'Bei Zahlungsdiensten sollten Absenderdomain, Linkziel und Kontext zusammenpassen.'
),
(
    'email',
    'PayPal Sicherheitsprüfung',
    'Ihr Konto muss überprüft werden',
    'Diese Nachricht sieht sehr nahe an einer echten PayPal-Mail aus. Die Details entscheiden.',
    'PayPal',
    'service@paypaI.com',
    'An mich',
    'Ungewöhnliche Aktivität erkannt',
    'Wir haben eine ungewöhnliche Aktivität in Ihrem Konto erkannt. Bitte bestätigen Sie Ihre Identität, damit Ihr Konto nicht eingeschränkt wird. Die Überprüfung dauert weniger als zwei Minuten.',
    'https://www.paypaI.com/security/confirm',
    TRUE,
    'Der Absender und Link verwenden paypaI.com mit einem grossen I statt einem kleinen l. Optisch sieht es fast wie paypal.com aus, ist aber eine andere Domain.',
    'Achten Sie bei Domains auf einzelne Zeichen. Grosses I, kleines l und die Zahl 1 können sehr ähnlich aussehen.'
),
(
    'email',
    'Dropbox Speicherplatz',
    'Ihr Speicherplatz ist fast voll',
    'Diese Mail fordert zu einer Kontoaktion auf. Prüfen Sie, ob sie echt ist.',
    'Dropbox',
    'no-reply@dropboxmail.com',
    'An mich',
    'Ihr Dropbox-Speicherplatz ist fast voll',
    'Ihr Dropbox-Speicherplatz ist beinahe voll. Sie können Dateien löschen oder Ihren Speicherplatz erweitern. Melden Sie sich in Ihrem Konto an, um Ihre Optionen zu prüfen.',
    'https://www.dropbox.com/account/plan',
    FALSE,
    'Diese Nachricht ist legitim. Dropbox verwendet dropboxmail.com für Benachrichtigungen und der Link führt auf dropbox.com.',
    'Nicht jede automatische Warnung ist Phishing. Entscheidend sind Absenderdomain, Linkziel und Handlung.'
),
(
    'email',
    'Dropbox Freigabe',
    'Ein Dokument wurde freigegeben',
    'Eine geteilte Datei kann echt sein, aber auch als Köder dienen.',
    'Dropbox',
    'files@dropb0x.com',
    'An mich',
    'Quartalsbericht wurde mit Ihnen geteilt',
    'Ein Dokument mit dem Namen Quartalsbericht_Q3.xlsx wurde mit Ihnen geteilt. Öffnen Sie die Datei und melden Sie sich mit Ihrem Firmenkonto an, um die Berechtigung zu bestätigen.',
    'https://dropb0x.com/s/quarterly-report',
    TRUE,
    'Der Absender nutzt dropb0x.com mit einer Null statt dem Buchstaben o. Das ist eine klassische Typosquatting-Domain.',
    'Bei Dateifreigaben immer prüfen, ob der Link wirklich zur offiziellen Plattform gehört.'
),
(
    'sms',
    'Google Code',
    'Oh, die Codes!',
    'Sie erhalten einen Code, obwohl Sie nichts angefordert haben.',
    'Google',
    '646-555-0110',
    'Telefon',
    'Google-Bestätigungscode',
    'Ihr Google-Bestätigungscode lautet 731904. Wenn Sie diese Anfrage nicht gestartet haben, antworten Sie mit STOP und senden Sie den Code zur Bestätigung zurück.',
    'Kein Link',
    TRUE,
    'Ein Bestätigungscode soll nie zurückgesendet oder weitergegeben werden. Angreifer könnten ihn nutzen, um eine Anmeldung abzuschliessen.',
    'Codes sind wie Passwörter. Niemand Seriöses fragt per SMS danach.'
),
(
    'email',
    'Google Sicherheitswarnung',
    'Neuer Login erkannt',
    'Eine Sicherheitsmeldung kann echt sein. Prüfen Sie die technischen Details.',
    'Google',
    'no-reply@accounts.google.com',
    'An mich',
    'Sicherheitswarnung für Ihr Google-Konto',
    'In Ihrem Google-Konto wurde ein neuer Login auf einem Windows-Gerät erkannt. Wenn Sie das nicht waren, prüfen Sie bitte Ihre Kontoaktivität.',
    'https://myaccount.google.com/security-checkup',
    FALSE,
    'Diese E-Mail ist legitim. Der Absender ist accounts.google.com und der Link führt zu myaccount.google.com.',
    'Bei Sicherheitswarnungen ist es sicherer, den Dienst direkt über den Browser zu öffnen, auch wenn die Mail legitim wirkt.'
),
(
    'email',
    'Google Passwort',
    'Ihr Passwort wurde gefunden',
    'Die Nachricht wirkt technisch und dringend. Prüfen Sie, ob die Domain stimmt.',
    'Google Sicherheit',
    'no-reply@g00gle.com',
    'An mich',
    'Jemand kennt Ihr Passwort',
    'Jemand hat gerade versucht, sich mit Ihrem Passwort anzumelden. Google hat den Anmeldeversuch blockiert. Ändern Sie Ihr Passwort sofort über die Sicherheitsprüfung.',
    'https://accounts.g00gle.com/security/password',
    TRUE,
    'Sowohl Absender als auch Link verwenden g00gle.com mit Nullen statt Buchstaben o. Das ist nicht die offizielle Google-Domain.',
    'Achten Sie auf Zahlen und ähnlich aussehende Zeichen in Domains.'
),
(
    'sms',
    'Netflix Zahlung',
    'Ihr Konto wurde pausiert',
    'Diese SMS wirkt kurz und alltäglich. Prüfen Sie die Domain im Link.',
    'Netflix',
    'Netflix',
    'Telefon',
    'Zahlung fehlgeschlagen',
    'Ihr Netflix-Konto wurde pausiert. Aktualisieren Sie Ihre Zahlungsinformationen: https://billing-netflix.tv/account',
    'https://billing-netflix.tv/account',
    TRUE,
    'Die Domain gehört nicht zu netflix.com. Auch wenn der Markenname enthalten ist, ist billing-netflix.tv keine offizielle Netflix-Domain.',
    'Die Hauptdomain steht direkt vor der Endung. Alles andere kann täuschend wirken.'
),
(
    'email',
    'Microsoft 365 Speicher',
    'Ihr OneDrive ist fast voll',
    'Eine typische Systemmeldung. Entscheiden Sie, ob sie echt ist.',
    'Microsoft 365',
    'microsoft-noreply@microsoft.com',
    'An mich',
    'Ihr OneDrive-Speicherplatz ist fast voll',
    'Ihr OneDrive-Speicherplatz ist beinahe voll. Sie können Dateien löschen oder Ihren Speicher erweitern. Prüfen Sie Ihre Speicheroptionen im Microsoft-Konto.',
    'https://www.microsoft.com/de-ch/microsoft-365/onedrive/compare-onedrive-plans',
    FALSE,
    'Diese E-Mail ist legitim. Absender und Link passen zu Microsoft und führen nicht auf eine fremde Login-Seite.',
    'Legitime Upgrade-Mails gibt es. Entscheidend ist, ob der Link wirklich zur offiziellen Domain führt.'
),
(
    'email',
    'Microsoft Teams',
    'Neue Teams-Nachricht',
    'Diese Mail wirkt wie eine normale Teams-Benachrichtigung.',
    'Microsoft Teams',
    'notifications@micros0ft.com',
    'An mich',
    'Sie wurden in Teams erwähnt',
    'Sie wurden in einer privaten Teams-Nachricht erwähnt. Melden Sie sich an, um die Nachricht zu lesen.',
    'https://login.micros0ft.com/teams/message',
    TRUE,
    'Der Absender und der Link verwenden micros0ft.com mit einer Null statt dem Buchstaben o.',
    'Prüfen Sie nicht nur den Absender. Gerade bei bekannten Marken werden einzelne Zeichen oft ersetzt.'
),
(
    'email',
    'HR Ferienplanung',
    'Ferienplanung Q3',
    'Interne Mails können echt sein, aber auch gefälscht werden.',
    'HR Team',
    'hr@novacorp.ch',
    'An mich',
    'Ferienplanung Q3',
    'Bitte tragen Sie Ihre geplanten Ferien für Q3 bis Freitag im internen HR-Tool ein. Die Eingabe erfolgt wie gewohnt über das Intranet.',
    'https://intranet.novacorp.ch/hr/ferienplanung',
    FALSE,
    'Die Nachricht ist intern, sachlich und verweist auf ein internes Tool. Sie fordert keine Passwörter oder Zahlungsdaten.',
    'Interne Mails sind plausibler, wenn Inhalt, Absender und Link zum gewohnten Kontext passen.'
),
(
    'calendar',
    'Kalendereinladung Gewinn',
    'Kostenloses Smartphone gewonnen',
    'Eine Kalendereinladung enthält ein attraktives Angebot.',
    'Google Kalender',
    'calendar-notification@google.com',
    'An mich',
    'Kostenloses Pixel 8 Pro - Bestätigungsgespräch',
    'Sie wurden für ein kostenloses Pixel 8 Pro ausgewählt. Bitte bestätigen Sie den Termin und öffnen Sie den Teilnahmelink in der Einladung.',
    'https://meet.google.com.reward-session.net/pixel',
    TRUE,
    'Die Einladung nutzt Google-Begriffe, aber der Link führt auf reward-session.net. meet.google.com steht hier nur als Subdomain davor.',
    'Auch Kalendereinladungen können Phishing enthalten. Prüfen Sie Links wie bei E-Mails.'
),
(
    'calendar',
    'Team Workshop',
    'Security Awareness Workshop',
    'Diese Einladung sieht nach einem internen Termin aus.',
    'IT Security Team',
    'security@novacorp.ch',
    'An mich',
    'Security Awareness Workshop',
    'Einladung zum internen Security Awareness Workshop am Donnerstag um 14:00 Uhr im Sitzungszimmer 3. Der Termin wurde durch das IT Security Team erstellt.',
    'Interner Kalendertermin ohne externen Link',
    FALSE,
    'Die Einladung ist intern, plausibel und enthält keinen externen Login- oder Zahlungslink.',
    'Bei legitimen internen Einladungen passen Absender, Inhalt und Erwartungshaltung zusammen.'
),
(
    'email',
    'Paketdienst',
    'Paket konnte nicht zugestellt werden',
    'Eine Paketmeldung kann echt oder gefälscht sein.',
    'Die Post',
    'notifications@post.ch',
    'An mich',
    'Zustellung fehlgeschlagen',
    'Ihr Paket konnte nicht zugestellt werden. Bitte prüfen Sie den Status Ihrer Sendung und wählen Sie eine neue Zustelloption.',
    'https://www.post.ch/de/empfangen/sendung-verfolgen',
    FALSE,
    'Diese Mail ist legitim. Absender und Link zeigen auf post.ch und es wird keine Zahlung über eine fremde Seite verlangt.',
    'Bei Paketmeldungen kann die offizielle Tracking-Seite direkt aufgerufen werden.'
),
(
    'email',
    'Paketgebühr',
    'Zustellung wartet auf Bestätigung',
    'Die Nachricht sieht nach einer Paketbenachrichtigung aus.',
    'Die Post',
    'service@post-ch.info',
    'An mich',
    'Zustellung pausiert',
    'Ihr Paket wartet auf die Bestätigung einer offenen Zustellgebühr von CHF 2.90. Ohne Bestätigung wird die Sendung retourniert.',
    'https://post-ch.info/zustellung/zahlung',
    TRUE,
    'post-ch.info ist nicht post.ch. Kleine Gebühren werden häufig genutzt, um Zahlungsdaten abzugreifen.',
    'Achten Sie bei Domains auf den exakten offiziellen Namen, nicht nur auf bekannte Wörter im Link.'
);
