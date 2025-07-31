#!/bin/bash

# Build script for Hugo site with PageFind search
echo "🏗️  Building Hugo site..."

# Build the Hugo site
hugo --cleanDestinationDir

if [ $? -eq 0 ]; then
    echo "✅ Hugo build successful!"
    
    # Run PageFind to generate search index
    echo "🔍 Generating search index with PageFind..."
    npx pagefind --site public --output-subdir pagefind
    
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
