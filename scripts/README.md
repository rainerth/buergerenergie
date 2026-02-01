# Server-Scripts

## GoAccess Zugriffstatistik

### Installation (auf Server)

```bash
# Ubuntu/Debian
sudo apt install goaccess

# CentOS/RHEL
sudo yum install goaccess
```

### Verwendung

```bash
# Standard (Log in ~/logs/access.log)
./goaccess-stats.sh

# Mit benutzerdefiniertem Log-Pfad
ACCESS_LOG=/var/log/apache2/access.log ./goaccess-stats.sh

# Ausgabe in anderes Verzeichnis
STATS_DIR=~/public_html/stats ./goaccess-stats.sh
```

### Automatische Aktualisierung (Cron)

Täglich um 6:00 Uhr:
```bash
crontab -e
# Folgende Zeile hinzufügen:
0 6 * * * cd ~/prj/beg && ./scripts/goaccess-stats.sh >> ~/logs/goaccess.log 2>&1
```

Stündlich:
```bash
0 * * * * cd ~/prj/beg && ./scripts/goaccess-stats.sh >> ~/logs/goaccess.log 2>&1
```

### Statistik-Seite schützen (optional)

Falls die Statistik nicht öffentlich sein soll, `.htaccess` in `public/statistik/` erstellen:

```apache
AuthType Basic
AuthName "Statistik"
AuthUserFile /pfad/zu/.htpasswd
Require valid-user
```

### Typische Log-Pfade

| Hosting-Typ | Pfad |
|-------------|------|
| Shared Hosting (All-Inkl, etc.) | `~/logs/access.log` |
| Ubuntu/Debian VPS | `/var/log/apache2/access.log` |
| CentOS/RHEL VPS | `/var/log/httpd/access_log` |
| Plesk | `/var/www/vhosts/domain/logs/access_log` |
