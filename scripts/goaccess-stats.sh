#!/bin/bash

# GoAccess Statistics Generator for Bürgerenergie Bösingen
# Basiert auf: https://wiki.hostsharing.net/index.php?title=Goaccess
#
# Hostsharing: GoAccess ist vorinstalliert (v1.7 auf Debian Bookworm)
#
# Hostsharing-Struktur:
#   Admin-User (wme00):     /home/pacs/wme00/var/web-<domain>-*.log.gz
#   Domain-User (wme00-*):  /home/pacs/wme00/users/*/doms/<domain>/htdocs-ssl/
#   $HOME des Domain-Users: /home/pacs/wme00/users/buergerenergie/
#
# Usage: ./scripts/goaccess-stats.sh

DOMAIN="${DOMAIN:-www.buergerenergie-boesingen.de}"

# Paket-Root ableiten: /home/pacs/wme00/users/buergerenergie -> /home/pacs/wme00
PACS_HOME="${PACS_HOME:-$(realpath "$HOME/../.." 2>/dev/null || echo "$HOME")}"

STATS_DIR="${STATS_DIR:-$HOME/doms/$DOMAIN/htdocs-ssl/statistik}"
LOG_PATTERN="$PACS_HOME/var/web-${DOMAIN}-*.log.gz"

# Prüfe ob Log-Dateien vorhanden
if ! ls $LOG_PATTERN &>/dev/null; then
    echo "Keine Log-Dateien gefunden: $LOG_PATTERN"
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
