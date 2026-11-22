#!/bin/bash
# Hugo-Build für buergerenergie-bhz.de
# Baut den geschützten /intern/-Bereich mit basic-auth und zieht die
# Mitgliederkarte-GeoJSON aus einem lokalen Daten-Ordner in die Site.

set -e

echo "🏗️  Building Hugo site..."

# Config laden (für HTPASSWD_SERVER_PATH und GEOJSON_SOURCE_PATH)
if [ -f "config.env" ]; then
    echo "📋 Loading configuration from config.env..."
    source config.env
else
    echo "❌ config.env not found! Please create configuration file."
    exit 1
fi

# -----------------------------------------------------------------------------
# Mitgliederkarte: GeoJSON-Symlink
# -----------------------------------------------------------------------------
mkdir -p static/data
GEOJSON_TARGET="static/data/mitgliederkarte.geojson"
# Bestehenden Symlink/Datei wegräumen (idempotent)
[ -L "$GEOJSON_TARGET" ] && rm "$GEOJSON_TARGET"
[ -f "$GEOJSON_TARGET" ] && rm "$GEOJSON_TARGET"

if [ -n "${GEOJSON_SOURCE_PATH:-}" ] && [ -f "$GEOJSON_SOURCE_PATH" ]; then
    ln -s "$(realpath "$GEOJSON_SOURCE_PATH")" "$GEOJSON_TARGET"
    echo "🗺️  Mitgliederkarte-Symlink: $GEOJSON_TARGET -> $GEOJSON_SOURCE_PATH"
else
    echo "⚠️  Keine Mitgliederkarte-GeoJSON gefunden (GEOJSON_SOURCE_PATH=${GEOJSON_SOURCE_PATH:-unset})."
    echo "    Karte wird leer angezeigt, Build läuft trotzdem durch."
fi

# -----------------------------------------------------------------------------
# .htaccess für geschützte Bereiche aus Template rendern
# -----------------------------------------------------------------------------
echo "🔐 Rendere .htaccess-Dateien..."
if [ -f "static/intern/.htaccess.template" ]; then
    sed "s|__HTPASSWD_PATH__|$HTPASSWD_SERVER_PATH|g" \
        static/intern/.htaccess.template > static/intern/.htaccess
    echo "✅ static/intern/.htaccess ($HTPASSWD_SERVER_PATH)"
else
    echo "❌ static/intern/.htaccess.template not found!"
    exit 1
fi

if [ -f "static/data/.htaccess.template" ]; then
    sed "s|__HTPASSWD_PATH__|$HTPASSWD_SERVER_PATH|g" \
        static/data/.htaccess.template > static/data/.htaccess
    echo "✅ static/data/.htaccess ($HTPASSWD_SERVER_PATH)"
fi

# -----------------------------------------------------------------------------
# Hugo-Build + PageFind
# -----------------------------------------------------------------------------
hugo --cleanDestinationDir --buildFuture

if [ $? -eq 0 ]; then
    echo "✅ Hugo build successful!"
    echo "🔍 Generating search index with PageFind (excluding internal areas)..."
    npx pagefind --site public --output-subdir pagefind \
        --exclude-selectors "[data-pagefind-ignore], .intern-content, #intern"

    if [ $? -eq 0 ]; then
        echo "✅ PageFind index generated successfully!"
        echo "🚀 Site is ready to deploy!"
    else
        echo "❌ PageFind failed!"
        exit 1
    fi
else
    echo "❌ Hugo build failed!"
    exit 1
fi
