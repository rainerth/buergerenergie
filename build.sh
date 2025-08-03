#!/bin/bash

# Build script for Hugo site with environment-specific configuration
echo "🏗️  Building Hugo site..."

# Load configuration
if [ -f "config.env" ]; then
    echo "📋 Loading configuration from config.env..."
    source config.env
else
    echo "❌ config.env not found! Please create configuration file."
    exit 1
fi

# Validate CSV source path
if [ ! -f "$CSV_SOURCE_PATH" ]; then
    echo "❌ CSV source file not found: $CSV_SOURCE_PATH"
    echo "💡 Please check config.env and ensure CSV_SOURCE_PATH points to existing file"
    exit 1
fi

# Create symlinks for CSV data
echo "🔗 Creating CSV symlinks..."

# Remove existing symlinks/files
[ -L "$ASSETS_CSV_PATH" ] && rm "$ASSETS_CSV_PATH"
[ -f "$ASSETS_CSV_PATH" ] && rm "$ASSETS_CSV_PATH"
[ -L "$STATIC_CSV_PATH" ] && rm "$STATIC_CSV_PATH"
[ -f "$STATIC_CSV_PATH" ] && rm "$STATIC_CSV_PATH"

# Create directory if needed
mkdir -p "$(dirname "$ASSETS_CSV_PATH")"
mkdir -p "$(dirname "$STATIC_CSV_PATH")"

# Create symlinks
ln -s "$(realpath "$CSV_SOURCE_PATH")" "$ASSETS_CSV_PATH"
ln -s "$(realpath "$CSV_SOURCE_PATH")" "$STATIC_CSV_PATH"

echo "✅ CSV symlinks created:"
echo "   📊 Assets: $ASSETS_CSV_PATH -> $CSV_SOURCE_PATH"
echo "   � Download: $STATIC_CSV_PATH -> $CSV_SOURCE_PATH"

# Configure .htaccess with correct path
echo "🔐 Configuring Apache authentication..."
if [ -f "static/intern/.htaccess" ]; then
    # Create backup and update .htaccess
    cp static/intern/.htaccess static/intern/.htaccess.template
    sed "s|__HTPASSWD_PATH__|$HTPASSWD_SERVER_PATH|g" static/intern/.htaccess.template > static/intern/.htaccess
    echo "✅ .htaccess configured with: $HTPASSWD_SERVER_PATH"
fi

# Build the Hugo site
hugo --cleanDestinationDir --buildFuture

if [ $? -eq 0 ]; then
    echo "✅ Hugo build successful!"

    # Run PageFind with exclusion of internal/protected areas
    # Documentation: See PAGEFIND.md for detailed configuration explanation
    echo "🔍 Generating search index with PageFind (excluding internal areas)..."
    npx pagefind --site public --output-subdir pagefind --exclude-selectors "[data-pagefind-ignore], .intern-content, #intern"

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
