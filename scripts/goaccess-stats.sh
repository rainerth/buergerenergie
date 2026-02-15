#!/bin/bash

# GoAccess Statistics Generator for Bürgerenergie Bösingen
# Basiert auf: https://wiki.hostsharing.net/index.php?title=Goaccess
#
# Hostsharing: GoAccess ist vorinstalliert (v1.7 auf Debian Bookworm)
#
# Voraussetzung: In /home/pacs/wme00/etc/config.ini muss stehen:
#   [dom:www.buergerenergie-boesingen.de]
#   http_log_directory = domain
#
# Dann liegen die Logs im Domain-Verzeichnis und der Domain-User kann sie lesen:
#   ~/doms/<domain>/var/web-<domain>-*.log.gz
#
# Usage: ./scripts/goaccess-stats.sh

DOMAIN="${DOMAIN:-www.buergerenergie-boesingen.de}"
STATS_DIR="${STATS_DIR:-$HOME/doms/$DOMAIN/htdocs-ssl/statistik}"
LOG_PATTERN="$HOME/doms/$DOMAIN/var/web-${DOMAIN}-*.log.gz"

# Prüfe ob Log-Dateien vorhanden
if ! ls $LOG_PATTERN &>/dev/null; then
    echo "Keine Log-Dateien gefunden: $LOG_PATTERN"
    echo ""
    echo "Prüfe ob http_log_directory=domain in config.ini gesetzt ist."
    echo "Siehe: https://wiki.hostsharing.net/index.php?title=Logging"
    exit 1
fi

LOG_COUNT=$(ls $LOG_PATTERN 2>/dev/null | wc -l)

mkdir -p "$STATS_DIR"

echo "[$(date '+%Y-%m-%d %H:%M:%S')] GoAccess: $LOG_COUNT Log-Dateien -> $STATS_DIR/index.html"

zcat $LOG_PATTERN | goaccess \
    -o "$STATS_DIR/index.html" \
    --log-format=COMBINED \
    --anonymize-ip \
    --ignore-crawler \
    --unknowns-as-crawlers \
    --real-os \
    --html-report-title="Bürgerenergie Bösingen - Zugriffstatistik" \
    -

# .htaccess-Schutz (gleiche Zugangsdaten wie /intern/)
HTPASSWD_FILE="$HOME/doms/$DOMAIN/htdocs-ssl/intern/.htpasswd"
if [ -f "$HTPASSWD_FILE" ]; then
    cat > "$STATS_DIR/.htaccess" << HTACCESS
AuthType Basic
AuthName "Statistik-Bereich"
AuthUserFile $(realpath "$HTPASSWD_FILE")
Require valid-user
HTACCESS
fi
