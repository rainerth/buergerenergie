# Server-Scripts

## GoAccess Zugriffstatistik

Basiert auf: https://wiki.hostsharing.net/index.php?title=Goaccess

### Voraussetzungen

1. GoAccess ist auf Hostsharing Managed Servern **vorinstalliert** (v1.7 auf Debian Bookworm)
2. Logs müssen im Domain-Verzeichnis liegen (`http_log_directory = domain` in config.ini)

**Einmalige Einrichtung** (als Admin-User `wme00`):

```ini
# /home/pacs/wme00/etc/config.ini
[dom:www.buergerenergie-boesingen.de]
http_log_directory = domain
http_log_generate = yes
http_log_retention = 90
```

Bestehende Logs verschieben:
```bash
mv /home/pacs/wme00/var/web-www.buergerenergie-boesingen.de-*.log.gz \
   /home/pacs/wme00/doms/www.buergerenergie-boesingen.de/var/
```

Siehe: https://wiki.hostsharing.net/index.php?title=Logging

### Funktionsweise

Das Script liest gzip-komprimierte Apache-Logs aus dem Domain-Verzeichnis:

```
~/doms/www.buergerenergie-boesingen.de/var/web-*.log.gz
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
