# Server-Scripts

## GoAccess Zugriffstatistik

Basiert auf: https://wiki.hostsharing.net/index.php?title=Goaccess

### Voraussetzungen

GoAccess ist auf Hostsharing Managed Servern **vorinstalliert** (v1.7 auf Debian Bookworm).

### Funktionsweise

Das Script `goaccess-stats.sh` liest alle gzip-komprimierten Apache-Logs für die Domain aus `~/var/` und erzeugt einen HTML-Report unter `~/doms/<domain>/htdocs-ssl/statistik/`.

```
~/var/web-www.buergerenergie-boesingen.de-*.log.gz
    → zcat | goaccess →
~/doms/www.buergerenergie-boesingen.de/htdocs-ssl/statistik/index.html
```

Die Statistik wird automatisch mit `.htaccess` geschützt (gleiche Zugangsdaten wie `/intern/`).

### Verwendung

```bash
# Auf dem Server (SSH)
cd ~/prj/beg
./scripts/goaccess-stats.sh
```

### Automatische Aktualisierung

Die Statistik wird bei jedem Deploy automatisch generiert (`deploy-server.sh`).

Zusätzlich kann ein eigener Cron-Job eingerichtet werden:

```bash
# Täglich um 2:10 Uhr
10 2 * * * cd ~/prj/beg && ./scripts/goaccess-stats.sh >> ~/logs/goaccess.log 2>&1
```
