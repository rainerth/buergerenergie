# Umgebungskonfiguration für Bürgerenergie Hugo Site

## Überblick

Diese Hugo-Site verwendet eine umgebungsbasierte Konfiguration für den Umgang mit sensiblen CSV-Daten und Apache-Authentifizierung.

## Konfigurationsdatei: `config.env`

Die Datei `config.env` enthält umgebungsspezifische Einstellungen:

```bash
# CSV-Datei Speicherort
CSV_SOURCE_PATH=/pfad/zur/interessenten.csv

# Build-Verzeichnisse (normalerweise nicht ändern)  
ASSETS_CSV_PATH=assets/data/interessenten.csv
STATIC_CSV_PATH=static/intern/interessenten.csv

# Apache .htpasswd Pfad für Server
HTPASSWD_SERVER_PATH=/var/www/html/intern/.htpasswd
```

## Umgebungen

### Lokale Entwicklung
```bash
CSV_SOURCE_PATH=./test-data/interessenten.csv
HTPASSWD_SERVER_PATH=./static/intern/.htpasswd
```

### Server-Umgebung
```bash
CSV_SOURCE_PATH=/home/pacs/wme00/users/buergerenergie/interessenten.csv
HTPASSWD_SERVER_PATH=/var/www/html/intern/.htpasswd
```

## Build-Prozess

Das `build.sh` Script:
1. Lädt Konfiguration aus `config.env`
2. Erstellt Symlinks für CSV-Dateien
3. Konfiguriert `.htaccess` mit korrekten Pfaden
4. Führt Hugo-Build aus

## Verzeichnisstruktur

```
assets/data/
├── interessenten.csv -> [symlink zur CSV-Quelle]

static/intern/
├── .htaccess           # Apache-Konfiguration
├── .htpasswd          # Passwort-Datei
└── interessenten.csv  -> [symlink zur CSV-Quelle]

test-data/
└── interessenten.csv  # Test-Daten für lokale Entwicklung
```

## Sicherheit

- CSV-Dateien werden nie in Git gespeichert (nur Symlinks)
- `.htaccess` schützt den `/intern` Bereich
- HTTP Basic Authentication für Downloads
- Sicherheitsheader sind aktiviert

## Build-Befehle

```bash
# Standard-Build
./build.sh

# Für lokale Entwicklung:
# 1. config.env anpassen (CSV_SOURCE_PATH auf test-data zeigen lassen)
# 2. ./build.sh
```
