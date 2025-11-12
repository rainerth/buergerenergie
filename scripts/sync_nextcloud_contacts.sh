#!/bin/bash
#
# Nextcloud CardDAV Kontakte-Synchronisation
# Vergleicht Nextcloud-Adressbuch mit interessenten.csv
#

set -e

# Konfiguration
NEXTCLOUD_URL="https://nextcloud.buergerenergie-boesingen.de/remote.php/dav/addressbooks/users/rainerthieringer/BEG%20Interessenten/"
CSV_FILE="assets/data/interessenten.csv"

# Prüfe ob Credentials gesetzt sind
if [ -z "$NEXTCLOUD_USER" ] || [ -z "$NEXTCLOUD_PASSWORD" ]; then
    echo "Fehler: Umgebungsvariablen nicht gesetzt"
    echo ""
    echo "Bitte setzen Sie folgende Variablen:"
    echo "  export NEXTCLOUD_USER='rainerthieringer'"
    echo "  export NEXTCLOUD_PASSWORD='ihr-app-passwort'"
    echo ""
    echo "App-Passwort erstellen:"
    echo "  https://nextcloud.buergerenergie-boesingen.de/settings/user/security"
    exit 1
fi

# Temporäre Dateien
TEMP_DIR=$(mktemp -d)
VCARDS_FILE="$TEMP_DIR/contacts.vcf"
CONTACTS_LIST="$TEMP_DIR/contacts_list.txt"
CSV_LIST="$TEMP_DIR/csv_list.txt"

echo "Lade Kontakte aus Nextcloud..."

# Hole alle vCards aus dem Adressbuch
curl -s -u "$NEXTCLOUD_USER:$NEXTCLOUD_PASSWORD" \
    -X REPORT "$NEXTCLOUD_URL" \
    -H "Depth: 1" \
    -H "Content-Type: application/xml" \
    --data '<?xml version="1.0" encoding="utf-8"?>
<C:addressbook-query xmlns:D="DAV:" xmlns:C="urn:ietf:params:xml:ns:carddav">
  <D:prop>
    <D:getetag/>
    <C:address-data/>
  </D:prop>
</C:addressbook-query>' > "$VCARDS_FILE"

# Extrahiere E-Mail-Adressen aus vCards
echo "Extrahiere E-Mail-Adressen aus Nextcloud..."
# Suche nach EMAIL:-Zeilen in vCards und extrahiere die E-Mail-Adresse
# HTML-Entities dekodieren und bereinigen
grep -oP 'EMAIL[^:]*:\K[^<]+' "$VCARDS_FILE" | \
    sed 's/&#13;//g' | \
    sed 's/\r//g' | \
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | \
    tr '[:upper:]' '[:lower:]' | \
    grep -v '^$' | \
    sort -u > "$CONTACTS_LIST" || true

# Extrahiere E-Mail-Adressen aus CSV (Spalte 2)
echo "Extrahiere E-Mail-Adressen aus CSV..."
tail -n +2 "$CSV_FILE" | cut -d';' -f2 | grep -v '^$' | tr '[:upper:]' '[:lower:]' | sort -u > "$CSV_LIST"

# Vergleiche Listen
echo ""
echo "=== Kontakte nur in Nextcloud (fehlen in CSV) ==="
comm -23 "$CONTACTS_LIST" "$CSV_LIST"

echo ""
echo "=== Kontakte nur in CSV (fehlen in Nextcloud) ==="
comm -13 "$CONTACTS_LIST" "$CSV_LIST"

echo ""
echo "=== Statistik ==="
echo "Kontakte in Nextcloud: $(wc -l < "$CONTACTS_LIST")"
echo "Kontakte in CSV:       $(wc -l < "$CSV_LIST")"
echo "Gemeinsame Kontakte:   $(comm -12 "$CONTACTS_LIST" "$CSV_LIST" | wc -l)"

# Prüfe Kontaktgruppe "Interessent"
echo ""
echo "=== Prüfe Kontaktgruppe 'Interessent' ==="

# Erstelle temporäre Datei mit allen E-Mails die in Gruppe "Interessent" sind
INTERESSENT_LIST="$TEMP_DIR/interessent_list.txt"

# Extrahiere E-Mails von Kontakten in der Gruppe "Interessent"
python3 << PYTHON_EOF | sort -u > "$INTERESSENT_LIST"
import sys, re

with open('$VCARDS_FILE', 'r', encoding='utf-8') as f:
    content = f.read()

# Teile in einzelne vCards auf (BEGIN:VCARD ... END:VCARD)
vcards = re.findall(r'BEGIN:VCARD.*?END:VCARD', content, re.DOTALL | re.IGNORECASE)

for vcard in vcards:
    # Prüfe ob CATEGORIES "Interessent" enthält
    categories_match = re.search(r'CATEGORIES[^:]*:([^\r\n<]+)', vcard, re.IGNORECASE)
    if categories_match:
        categories = categories_match.group(1).replace('&#13;', '').strip()

        # Wenn "Interessent" in Kategorien enthalten
        if 'Interessent' in categories or 'interessent' in categories.lower():
            # Extrahiere E-Mail
            email_match = re.search(r'EMAIL[^:]*:([^\r\n<]+)', vcard, re.IGNORECASE)
            if email_match:
                email = email_match.group(1).replace('&#13;', '').strip().lower()
                if email:
                    print(email)
PYTHON_EOF

echo "Kontakte in Gruppe 'Interessent': $(wc -l < "$INTERESSENT_LIST")"

# Prüfe Kontaktgruppe "Gründungsteam"
echo ""
echo "=== Prüfe Kontaktgruppe 'Gründungsteam' ==="

GRUENDUNGSTEAM_LIST="$TEMP_DIR/gruendungsteam_list.txt"

# Extrahiere E-Mails von Kontakten in der Gruppe "Gründungsteam"
python3 << PYTHON_EOF | sort -u > "$GRUENDUNGSTEAM_LIST"
import sys, re

with open('$VCARDS_FILE', 'r', encoding='utf-8') as f:
    content = f.read()

vcards = re.findall(r'BEGIN:VCARD.*?END:VCARD', content, re.DOTALL | re.IGNORECASE)

for vcard in vcards:
    categories_match = re.search(r'CATEGORIES[^:]*:([^\r\n<]+)', vcard, re.IGNORECASE)
    if categories_match:
        categories = categories_match.group(1).replace('&#13;', '').strip()

        if 'Gründungsteam' in categories or 'gruendungsteam' in categories.lower() or 'Gruendungsteam' in categories:
            email_match = re.search(r'EMAIL[^:]*:([^\r\n<]+)', vcard, re.IGNORECASE)
            if email_match:
                email = email_match.group(1).replace('&#13;', '').strip().lower()
                if email:
                    print(email)
PYTHON_EOF

echo "Kontakte in Gruppe 'Gründungsteam': $(wc -l < "$GRUENDUNGSTEAM_LIST")"

# Erstelle Listen basierend auf Aktivist-Feld
AKTIVISTEN_LIST="$TEMP_DIR/aktivisten_list.txt"
NICHT_AKTIVISTEN_LIST="$TEMP_DIR/nicht_aktivisten_list.txt"

# Extrahiere Aktivisten (Aktivist=Ja) und Nicht-Aktivisten aus CSV
echo ""
echo "=== Analysiere CSV nach Aktivist-Status ==="

# Verwende Python für korrekte CSV-Verarbeitung (ohne Quotes, damit Variable expandiert wird)
python3 <<PYTHON_EOF > "$TEMP_DIR/aktivist_parse.txt"
import csv

with open('$CSV_FILE', 'r', encoding='utf-8') as f:
    reader = csv.DictReader(f, delimiter=';')
    for row in reader:
        email = row.get('Email', '').strip().lower()
        aktivist = row.get('Aktivist', '').strip()

        if email:
            if aktivist == 'Ja':
                print(f"aktivist:{email}")
            else:
                print(f"nicht:{email}")
PYTHON_EOF

# Trenne in zwei Listen
grep "^aktivist:" "$TEMP_DIR/aktivist_parse.txt" 2>/dev/null | cut -d':' -f2 | sort -u > "$AKTIVISTEN_LIST"
grep "^nicht:" "$TEMP_DIR/aktivist_parse.txt" 2>/dev/null | cut -d':' -f2 | sort -u > "$NICHT_AKTIVISTEN_LIST"

echo "Aktivisten in CSV (Aktivist=Ja): $(wc -l < "$AKTIVISTEN_LIST")"
echo "Nicht-Aktivisten in CSV: $(wc -l < "$NICHT_AKTIVISTEN_LIST")"

# Prüfe Zuordnung
echo ""
echo "=== FEHLERHAFTE ZUORDNUNGEN ==="
echo ""
echo "--- Aktivisten (Aktivist=Ja) die NICHT in Gruppe 'Gründungsteam' sind ---"
comm -13 "$GRUENDUNGSTEAM_LIST" "$AKTIVISTEN_LIST"

echo ""
echo "--- Nicht-Aktivisten die NICHT in Gruppe 'Interessent' sind ---"
comm -13 "$INTERESSENT_LIST" "$NICHT_AKTIVISTEN_LIST"

echo ""
echo "--- Kontakte in 'Gründungsteam' die NICHT als Aktivist markiert sind ---"
comm -13 "$AKTIVISTEN_LIST" "$GRUENDUNGSTEAM_LIST"

echo ""
echo "--- Kontakte in 'Interessent' die als Aktivist markiert sind ---"
comm -12 "$INTERESSENT_LIST" "$AKTIVISTEN_LIST"

# Aufräumen
rm -rf "$TEMP_DIR"
