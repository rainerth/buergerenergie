# Server Deployment für Bürgerenergie Hugo Site

## Überblick

Das `deploy-server.sh` Script ersetzt das alte `update-gitrepo.sh` und löst die identifizierten Probleme:

## 🔧 Probleme des alten Scripts

1. **Überlappung mit build.sh**: Das alte Script führte Hugo direkt aus und ignorierte die Symlink-Logik
2. **Überschreibt lokale Konfiguration**: `git reset --hard` zerstörte lokale `config.env`, `.htpasswd` etc.

## ✅ Lösungen des neuen Scripts

### 1. Intelligente Backup-Strategie
```bash
# Sichert vor Update:
- config.env (Umgebungskonfiguration)
- static/intern/.htpasswd (Passwörter)
- static/intern/.htaccess (für Merge-Referenz)
```

### 2. Verwendet build.sh
```bash
# Statt direktem Hugo-Aufruf:
./build.sh
```

### 3. Sichere Wiederherstellung
```bash
# Stellt nach Update wieder her:
- Lokale Konfigurationsdateien
- Benutzer-spezifische Einstellungen
```

### 4. Umfassendes Logging
```bash
# Logs nach: $HOME/logs/beg-deploy.log
# Timestamps und detaillierte Statusmeldungen
```

## 📁 Server-Setup

### Installation auf dem Server:

```bash
# 1. Script ist bereits im Repository
cd $HOME/prj/beg
git pull

# 2. Crontab anpassen (ersetze alte Version):
crontab -e

# Alte Zeile ersetzen:
# */15 * * * * $HOME/bin/update-gitrepo.sh

# Neue Zeile:
*/15 * * * * cd $HOME/prj/beg && ./deploy-server.sh
```

### Verzeichnisstruktur:
```
$HOME/
├── prj/beg/                    # Git Repository
│   ├── deploy-server.sh        # Neues Deploy-Script
│   ├── build.sh               # Build-Logic
│   ├── config.env             # Server-Konfiguration (lokal)
│   └── static/intern/
│       ├── .htpasswd          # Server-Passwörter (lokal)
│       └── .htaccess          # Wird vom build.sh konfiguriert
├── backup/beg-config/         # Automatische Backups
└── logs/
    └── beg-deploy.log         # Deployment-Logs
```

## 🔄 Workflow

1. **Fetch**: Prüft GitHub auf Updates
2. **Backup**: Sichert lokale Konfiguration
3. **Update**: Holt neue Version via `git reset --hard`
4. **Restore**: Stellt lokale Dateien wieder her
5. **Build**: Führt `./build.sh` aus (mit Symlinks, .htaccess etc.)
6. **Cleanup**: Räumt alte Backups auf

## 🚨 Sicherheitsfeatures

- **Automatische Backups** mit Zeitstempel
- **Rollback-fähig** durch gesicherte Konfiguration
- **Log-Rotation** (behält letzten 10 Backups)
- **Error-Handling** mit Exit-Codes für Cron

## 📊 Monitoring

```bash
# Letzten Deployment-Status prüfen:
tail -20 $HOME/logs/beg-deploy.log

# Backup-Verzeichnis prüfen:
ls -la $HOME/backup/beg-config/
```

Das neue Script ist **produktionsreif** und **sicher** für automatisierte Deployments.
