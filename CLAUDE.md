# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Hugo static site for "Bürgerenergie Bösingen e.V." 

## Architecture

- **Site Root**: `/beg/` directory contains the Hugo site
- **Theme**: Uses `hugo-theme-cleanwhite` as a Git submodule in `/themes/`
- **Content Structure**:
  - `/content/_index.md`: Homepage with association information
  - `/content/impressum/`: Legal notice page
  - `/content/dokumente/`: Documents page for future downloads
  - `/static/css/buergerenergie.css`: Custom nature-themed styling
  - `/static/documents/`: Directory for future PDF documents
- **Configuration**: `hugo.toml` with German locale and nature association settings

## Key Commands

All commands should be run from the `/beg/` directory:

```bash
# Development server
hugo server

# Development server accessible from network
hugo server --bind 0.0.0.0 --port 1314 --buildDrafts

# Build site for production
hugo

# Create new content (if needed)
hugo new content [section]/[filename].md
```

## Content Management

- **Language**: German (de)
- **Theme**: Nature/environmental focus with green color scheme
- **Status**: Association is "in Gründung" (in formation)
- **Future Documents**: Satzung (statutes) and Beitrittserklärung (membership form) will be added to `/static/documents/`

## Site Configuration

- **Base URL**: https://www.buergerenergie-boesingen.de
- **Theme**: Clean White with custom nature-themed CSS
- **Navigation**: Home, Dokumente, Impressum
- **Contact**: info@buergerenergie-boesingen.de

## Development Notes

- Site successfully builds with 19 pages
- Custom CSS uses nature-inspired color palette (greens, browns)
- Ready for content expansion after official association founding
- Document download functionality prepared but waiting for actual files