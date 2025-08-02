#!/bin/bash

# Script zum Erstellen und Verwalten von .htpasswd
# Verwendung: ./create-htpasswd.sh [username]

HTPASSWD_FILE="static/intern/.htpasswd"

if [ -z "$1" ]; then
    echo "Verwendung: $0 <username>"
    echo "Beispiel: $0 mitglieder"
    echo ""
    echo "Aktuelle Benutzer in $HTPASSWD_FILE:"
    if [ -f "$HTPASSWD_FILE" ]; then
        cut -d: -f1 "$HTPASSWD_FILE" | grep -v "^#"
    else
        echo "Keine .htpasswd Datei gefunden"
    fi
    exit 1
fi

USERNAME="$1"

# Prüfen ob htpasswd verfügbar ist
if ! command -v htpasswd &> /dev/null; then
    echo "❌ htpasswd ist nicht installiert!"
    echo "Installation unter Ubuntu/Debian: sudo apt install apache2-utils"
    echo "Installation unter CentOS/RHEL: sudo yum install httpd-tools"
    echo "Installation unter macOS: brew install httpd"
    exit 1
fi

echo "🔐 Erstelle Passwort für Benutzer: $USERNAME"

# Erstelle oder aktualisiere .htpasswd
if [ -f "$HTPASSWD_FILE" ]; then
    # Datei existiert - Benutzer hinzufügen/aktualisieren
    htpasswd -B "$HTPASSWD_FILE" "$USERNAME"
else
    # Neue Datei erstellen
    mkdir -p "$(dirname "$HTPASSWD_FILE")"
    htpasswd -c -B "$HTPASSWD_FILE" "$USERNAME"
fi

echo "✅ Passwort für $USERNAME wurde erstellt/aktualisiert"
echo "📁 Datei: $HTPASSWD_FILE"

# Berechtigungen setzen
chmod 644 "$HTPASSWD_FILE"

echo ""
echo "🔧 Nächste Schritte:"
echo "1. Laden Sie die .htpasswd auf Ihren Server hoch"
echo "2. Passen Sie den AuthUserFile Pfad in .htaccess an"
echo "3. Stellen Sie sicher, dass mod_auth_basic aktiviert ist"
