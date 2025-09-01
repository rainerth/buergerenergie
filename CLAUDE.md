# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hugo static site for "Bürgerenergie Bösingen e.V." - a German energy cooperative initiative focused on sustainable energy solutions for the Bösingen community. The site includes news, events, documents, and member areas with search functionality.

## Architecture

- **Site Root**: `/beg/` directory contains the Hugo site
- **Theme**: Uses `hugo-theme-cleanwhite` as a Git submodule in `/themes/`
- **Content Structure**:
  - `/content/neuigkeiten/`: News articles about energy topics and partnerships
  - `/content/termine/`: Events and meetings
  - `/content/dokumente/`: Documents (statutes, membership forms)
  - `/content/intern/`: Protected member area with CSV data lists
  - `/assets/`: Processed images and data files
  - `/static/`: Static assets including custom CSS
- **Build System**: Custom build script with PageFind search integration
- **Configuration**: `hugo.toml` with German locale and environment-based config

## Key Commands

All commands should be run from the `/beg/` directory:

```bash
# Development server
hugo server

# Development server with future posts
npm run serve

# Production build with search
./build.sh

# Alternative production build
npm run build

# Network accessible development
hugo server --bind 0.0.0.0 --port 1314 --buildDrafts

# Create new content
hugo new content neuigkeiten/YYYYMMDD_title.md
hugo new content termine/YYYYMMDD_event.md
```

## Build Process

The `build.sh` script handles the complete build process:
1. Sources environment configuration from `config.env`
2. Creates symlinks for CSV data files
3. Configures Apache authentication (.htaccess)
4. Builds Hugo site
5. Runs PageFind for search indexing
6. Updates Git submodules

## Content Management

- **News Articles**: Use format `YYYYMMDD_title.md` in `/content/neuigkeiten/`
- **Events**: Use format `YYYYMMDD_event.md` in `/content/termine/`
- **Images**: Store in `/assets/img/artikel/` for automatic WebP conversion
- **Protected Data**: CSV files in `/content/intern/` require authentication
- **Search**: Automatically indexes all public content (excludes `/intern/`)

## Special Features

- **Image Optimization**: Use `{{< optimized-image >}}` shortcode for automatic WebP conversion
- **Forms**: Tally forms integrated via shortcode
- **Search**: PageFind provides fast client-side search in German
- **Authentication**: Apache .htaccess protects `/intern/` directory
- **Deployment**: Automated via `deploy-server.sh` (runs every 15 minutes via cron)

## Site Configuration

- **Base URL**: https://www.buergerenergie-boesingen.de
- **Language**: German (de)
- **Theme**: Clean White with custom energy/nature CSS (`/static/css/buergerenergie.css`)
- **Search**: PageFind with German language support
- **Navigation**: Neuigkeiten, Termine, Dokumente, Impressum

## Development Notes

- Hugo v0.131.0+extended is required
- Node.js needed for PageFind search functionality
- CSV data files are symlinked from locations specified in `config.env`
- The site focuses on community energy initiatives and sustainable development
- All content should be in German following the cooperative's communication style