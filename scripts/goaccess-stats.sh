#!/bin/bash

# GoAccess Statistics Generator for Bürgerenergie Bösingen
# Generates HTML statistics from Apache access logs
#
# Usage: ./goaccess-stats.sh [--daily|--monthly]
#
# Prerequisites:
#   - GoAccess installed: sudo apt install goaccess
#   - Apache access logs available

# === CONFIGURATION ===
# Adjust these paths to match your server setup

# Apache log file(s) - common locations:
#   - Shared hosting: ~/logs/access.log or ~/logs/www.buergerenergie-boesingen.de-access.log
#   - VPS/Dedicated: /var/log/apache2/access.log or /var/log/httpd/access_log
ACCESS_LOG="${ACCESS_LOG:-$HOME/logs/access.log}"

# Output directory for statistics
STATS_DIR="${STATS_DIR:-$HOME/prj/beg/public/statistik}"

# GoAccess configuration
GOACCESS_CONF="${GOACCESS_CONF:-}"

# === END CONFIGURATION ===

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() {
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
}

error() {
    echo -e "${RED}❌ $1${NC}" >&2
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

warn() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Check if GoAccess is installed
if ! command -v goaccess &> /dev/null; then
    error "GoAccess ist nicht installiert!"
    echo ""
    echo "Installation:"
    echo "  Ubuntu/Debian: sudo apt install goaccess"
    echo "  CentOS/RHEL:   sudo yum install goaccess"
    echo "  macOS:         brew install goaccess"
    exit 1
fi

# Check if log file exists
if [ ! -f "$ACCESS_LOG" ]; then
    error "Apache Log-Datei nicht gefunden: $ACCESS_LOG"
    echo ""
    echo "Mögliche Pfade:"
    echo "  - ~/logs/access.log (Shared Hosting)"
    echo "  - /var/log/apache2/access.log (Ubuntu/Debian)"
    echo "  - /var/log/httpd/access_log (CentOS/RHEL)"
    echo ""
    echo "Setze ACCESS_LOG Variable:"
    echo "  ACCESS_LOG=/pfad/zu/access.log ./goaccess-stats.sh"
    exit 1
fi

# Create output directory
mkdir -p "$STATS_DIR"

# Generate timestamp
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
DATE_READABLE=$(date '+%d.%m.%Y %H:%M')

log "📊 Generiere Zugriffstatistik..."
log "   Log-Datei: $ACCESS_LOG"
log "   Ausgabe:   $STATS_DIR"

# Build GoAccess command
GOACCESS_CMD="goaccess \"$ACCESS_LOG\" \
    --log-format=COMBINED \
    --output=\"$STATS_DIR/index.html\" \
    --html-report-title=\"Bürgerenergie Bösingen - Zugriffstatistik\" \
    --no-global-config"

# Add custom config if specified
if [ -n "$GOACCESS_CONF" ] && [ -f "$GOACCESS_CONF" ]; then
    GOACCESS_CMD="$GOACCESS_CMD --config-file=\"$GOACCESS_CONF\""
fi

# Common GoAccess options for German locale
GOACCESS_CMD="$GOACCESS_CMD \
    --date-format=%d/%b/%Y \
    --time-format=%H:%M:%S \
    --ignore-crawlers \
    --real-os \
    --agent-list \
    --http-protocol=yes \
    --http-method=yes"

# Execute GoAccess
log "🔄 Starte GoAccess..."
if eval "$GOACCESS_CMD"; then
    success "Statistik erfolgreich generiert!"
    echo ""
    echo "📈 Report verfügbar unter:"
    echo "   Lokal:  $STATS_DIR/index.html"
    echo "   Web:    https://www.buergerenergie-boesingen.de/statistik/"
    echo ""

    # Show quick stats
    if [ -f "$ACCESS_LOG" ]; then
        TOTAL_REQUESTS=$(wc -l < "$ACCESS_LOG")
        log "📊 Schnellübersicht:"
        echo "   Gesamte Anfragen im Log: $TOTAL_REQUESTS"
    fi
else
    error "GoAccess-Fehler beim Generieren der Statistik"
    exit 1
fi

# Optional: Create .htaccess to protect stats (uncomment if needed)
# cat > "$STATS_DIR/.htaccess" << 'HTACCESS'
# AuthType Basic
# AuthName "Statistik-Bereich"
# AuthUserFile /path/to/.htpasswd
# Require valid-user
# HTACCESS
