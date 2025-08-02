# Apache .htaccess Setup für Interessenten-Bereich

## 🔐 Überblick

Das `/intern/` Verzeichnis ist durch HTTP Basic Authentication geschützt. Nur autorisierte Organisatoren können auf die Interessentenliste zugreifen.

## 📋 Setup-Anleitung

### 1. Dateien auf Server hochladen
```bash
# Struktur nach dem Hugo Build:
public/intern/
├── index.html          # Geschützte Seite
├── .htaccess           # Apache-Konfiguration
└── .htpasswd           # Passwort-Datei
```

### 2. .htaccess Pfad anpassen
Bearbeiten Sie `static/intern/.htaccess` und passen Sie den `AuthUserFile` Pfad an:

```apache
# Beispiel für verschiedene Server-Setups:

# Shared Hosting:
AuthUserFile /home/username/public_html/intern/.htpasswd

# VPS/Dedicated Server:
AuthUserFile /var/www/html/intern/.htpasswd

# cPanel:
AuthUserFile /home/cpanel_user/public_html/intern/.htpasswd
```

### 3. Apache Module aktivieren
Stellen Sie sicher, dass folgende Module aktiviert sind:
```bash
sudo a2enmod auth_basic
sudo a2enmod authz_user
sudo a2enmod headers
sudo systemctl restart apache2
```

### 4. Passwörter verwalten

#### Neuen Benutzer erstellen:
```bash
./create-htpasswd.sh mitglieder
```

#### Manuell mit htpasswd:
```bash
# Neuen Benutzer hinzufügen
htpasswd -B static/mitglieder/.htpasswd neuer_benutzer

# Passwort ändern
htpasswd -B static/mitglieder/.htpasswd bestehender_benutzer

# Benutzer löschen
htpasswd -D static/mitglieder/.htpasswd benutzer_name
```

## 🔧 Fehlerbehandlung

### "Internal Server Error 500"
1. Prüfen Sie den AuthUserFile Pfad in .htaccess
2. Stellen Sie sicher, dass die .htpasswd Datei existiert
3. Überprüfen Sie die Dateiberechtigungen:
   ```bash
   chmod 644 .htpasswd
   chmod 644 .htaccess
   ```

### "Authorization Required" wird nicht angezeigt
1. Prüfen Sie, ob mod_auth_basic aktiviert ist
2. Überprüfen Sie die Apache-Konfiguration:
   ```apache
   # In virtueller Host-Konfiguration:
   <Directory "/var/www/html">
       AllowOverride AuthConfig
   </Directory>
   ```

### Passwort wird nicht akzeptiert
1. Verwenden Sie bcrypt Hashes (-B Option)
2. Prüfen Sie die .htpasswd Syntax
3. Stellen Sie sicher, dass keine Leerzeichen in der Datei sind

## 📊 Standard-Zugangsdaten

**Benutzername:** `intern`
**Passwort:** `boesingen2025`

**Benutzername:** `admin`
**Passwort:** `admin2025`

⚠️ **Wichtig:** Ändern Sie diese Passwörter vor dem Produktiveinsatz!

## 🛡️ Sicherheitsfeatures

- ✅ HTTP Basic Authentication
- ✅ Blockierung direkter CSV-Zugriffe
- ✅ Schutz von .htaccess und .htpasswd
- ✅ Sicherheitsheader (XSS, Clickjacking)
- ✅ Bcrypt-verschlüsselte Passwörter

## 📝 CSV-Daten aktualisieren

1. Bearbeiten Sie `data/interessenten.csv`
2. Führen Sie `./build.sh` aus
3. Laden Sie die neue `public/intern/index.html` hoch

Die .htaccess und .htpasswd Dateien müssen nur einmal eingerichtet werden.
