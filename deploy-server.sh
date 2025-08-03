#!/bin/bash

# Server deployment script for Bürgerenergie Hugo Site
# This script safely updates from GitHub while preserving local configuration

# Configuration
REPO_DIR="$HOME/prj/beg"
BACKUP_DIR="$HOME/backup/beg-config"
LOG_FILE="$HOME/logs/beg-deploy.log"

# Ensure directories exist
mkdir -p "$BACKUP_DIR" "$HOME/logs"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "🚀 Starting Bürgerenergie site deployment..."

# Change to repository directory
cd "$REPO_DIR" || {
    log "❌ Failed to change to repository directory: $REPO_DIR"
    exit 1
}

# Fetch latest changes
log "📡 Fetching latest changes from GitHub..."
git fetch

# Check if update is needed
UPSTREAM=@{upstream}
LOCAL=$(git rev-parse @)
REMOTE=$(git rev-parse "$UPSTREAM")
BASE=$(git merge-base @ "$UPSTREAM")

if [ "$LOCAL" = "$REMOTE" ]; then
    log "✅ Repository is up-to-date"
    exit 0
    
elif [ "$LOCAL" = "$BASE" ]; then
    log "📥 Updates available, starting deployment..."
    
    # Backup sensitive files before update
    log "💾 Backing up local configuration files..."
    mkdir -p "$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)"
    CURRENT_BACKUP="$BACKUP_DIR/$(date +%Y%m%d_%H%M%S)"
    
    # Backup files that should not be overwritten
    [ -f "config.env" ] && cp "config.env" "$CURRENT_BACKUP/"
    [ -f "static/intern/.htpasswd" ] && cp "static/intern/.htpasswd" "$CURRENT_BACKUP/"
    [ -f "static/intern/.htaccess" ] && cp "static/intern/.htaccess" "$CURRENT_BACKUP/.htaccess.backup"
    
    log "✅ Configuration files backed up to: $CURRENT_BACKUP"
    
    # Update repository
    log "🔄 Updating repository..."
    git reset --hard "$REMOTE"
    git submodule update --init --recursive
    
    # Restore sensitive files
    log "🔧 Restoring local configuration..."
    [ -f "$CURRENT_BACKUP/config.env" ] && cp "$CURRENT_BACKUP/config.env" "config.env"
    [ -f "$CURRENT_BACKUP/.htpasswd" ] && cp "$CURRENT_BACKUP/.htpasswd" "static/intern/.htpasswd"
    
    # Merge .htaccess carefully (keep auth settings, update other parts)
    if [ -f "$CURRENT_BACKUP/.htaccess.backup" ]; then
        log "🔐 Preserving authentication configuration in .htaccess..."
        # The build script will handle .htaccess configuration
    fi
    
    # Use our build script instead of direct Hugo call
    log "🏗️  Building site with local configuration..."
    if ./build.sh; then
        log "✅ Site build completed successfully"
        log "📊 Site statistics:"
        find public -name "*.html" | wc -l | xargs echo "   HTML files:"
        du -sh public | cut -f1 | xargs echo "   Total size:"
    else
        log "❌ Site build failed"
        exit 1
    fi
    
    # Clean up old backups (keep last 10)
    log "🧹 Cleaning up old backups..."
    cd "$BACKUP_DIR"
    ls -1t | tail -n +11 | xargs -r rm -rf
    
    log "🎉 Deployment completed successfully!"
    
elif [ "$REMOTE" = "$BASE" ]; then
    log "⚠️  Local repository has unpushed changes"
    exit 1
else
    log "❌ Repository has diverged - manual intervention required"
    exit 1
fi
