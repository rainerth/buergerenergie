# PageFind Suchfunktion - Konfiguration und Datenschutz

## Übersicht

Die Website verwendet [PageFind](https://pagefind.app/) für die Volltextsuche. Die Konfiguration ist datenschutzfreundlich und schließt sensible Bereiche explizit vom Suchindex aus.

## Aktuelle Konfiguration

```bash
npx pagefind --site public --output-subdir pagefind \
  --exclude-selectors "[data-pagefind-ignore]" \
  --glob "**/*.html" \
  --exclude-glob "**/intern/**"
```

## Parameter-Erklärung

### `--site public`
- **Zweck**: Definiert das Verzeichnis mit den zu indexierenden HTML-Dateien
- **Wert**: `public` (Hugo's Standard-Output-Verzeichnis)

### `--output-subdir pagefind`
- **Zweck**: Bestimmt den Unterordner für die Suchindex-Dateien
- **Resultat**: Suchindex wird in `public/pagefind/` gespeichert

### `--exclude-selectors "[data-pagefind-ignore]"`
- **Zweck**: Schließt HTML-Elemente mit dem Attribut `data-pagefind-ignore` aus
- **Verwendung**: Für granulare Kontrolle in Templates
- **Beispiel**: 
  ```html
  <div data-pagefind-ignore>
    Dieser Inhalt wird nicht indexiert
  </div>
  ```

### `--glob "**/*.html"`
- **Zweck**: Indexiert nur HTML-Dateien (Sicherheitsmaßnahme)
- **Ausgeschlossen**: CSS, JS, Bilder, CSV-Dateien, etc.

### `--exclude-glob "**/intern/**"`
- **Zweck**: **DATENSCHUTZ** - Schließt das gesamte `/intern/` Verzeichnis aus
- **Geschützt**: Mitgliederdaten, CSV-Listen, authentifizierte Bereiche

## Datenschutz-Maßnahmen

### 🔒 Vollständig ausgeschlossen vom Suchindex:
- `/intern/` Verzeichnis (kompletter Mitgliederbereich)
- CSV-Dateien mit Mitgliederdaten
- Alle mit `data-pagefind-ignore` markierten Inhalte

### ✅ Suchbar (öffentliche Bereiche):
- Startseite und allgemeine Informationen
- Neuigkeiten und Termine
- Dokumente im öffentlichen Bereich
- Impressum und Datenschutz

## Zusätzliche Ausschluss-Optionen

### HTML-Attribut-basiert
```html
<!-- Kompletter Bereich ausschließen -->
<section data-pagefind-ignore>
  <h2>Interne Informationen</h2>
  <p>Diese Daten sind nicht suchbar</p>
</section>

<!-- Nur Inhalt ausschließen, Titel bleibt suchbar -->
<section>
  <h2>Öffentlicher Titel</h2>
  <div data-pagefind-ignore>
    <p>Dieser Text ist nicht suchbar</p>
  </div>
</section>
```

### Meta-Tags für komplette Seiten
```html
<head>
  <meta name="pagefind-ignore" content="true">
</head>
```

## Weitere PageFind-Optionen

### Zusätzliche Verzeichnisse ausschließen
```bash
--exclude-glob "**/intern/**,**/private/**,**/admin/**"
```

### Sprachspezifische Konfiguration
```bash
--force-language de
```

### Verbosity für Debugging
```bash
--verbose
```

## Integration in Build-Prozess

Die PageFind-Indexierung erfolgt **nach** dem Hugo-Build aber **mit** expliziten Ausschlüssen für sensible Daten:

1. ✅ Hugo baut die komplette Website (inkl. geschützter Bereiche)
2. 🔍 PageFind indexiert nur öffentliche Bereiche
3. 🔐 Apache `.htaccess` schützt weiterhin den `/intern/` Bereich
4. 📊 CSV-Daten bleiben ausschließlich authentifizierten Nutzern zugänglich

## Wartung und Updates

### PageFind-Version prüfen
```bash
npx pagefind --version
```

### Suchindex manuell neu erstellen
```bash
cd /path/to/website
npx pagefind --site public --output-subdir pagefind \
  --exclude-selectors "[data-pagefind-ignore]" \
  --glob "**/*.html" \
  --exclude-glob "**/intern/**"
```

### Suchindex-Größe prüfen
```bash
du -sh public/pagefind/
find public/pagefind/ -name "*.json" | wc -l
```

## Fehlerbehebung

### PageFind-Build schlägt fehl
1. Prüfen ob `public/` Verzeichnis existiert
2. Überprüfen ob HTML-Dateien vorhanden sind
3. Node.js und npm-Versionen aktualisieren

### Suchfunktion findet sensible Daten
1. `--exclude-glob` Parameter überprüfen
2. Sicherstellen dass `/intern/` korrekt ausgeschlossen wird
3. Bei Bedarf zusätzliche `data-pagefind-ignore` Attribute setzen

### Performance-Optimierung
```bash
# Minimale Indexierung nur für kritische Seiten
--glob "**/index.html,**/neuigkeiten/**/*.html"
```

## Compliance und Rechtliches

- ✅ **DSGVO-konform**: Keine Indexierung personenbezogener Daten
- ✅ **Datensparsamkeit**: Nur öffentliche Inhalte werden durchsuchbar
- ✅ **Zugriffskontrolle**: Authentifizierung bleibt unberührt
- ✅ **Transparenz**: Suchbare Inhalte entsprechen öffentlich zugänglichen Bereichen

---

**Letzte Aktualisierung**: 3. August 2025  
**PageFind Version**: Latest (via npx)  
**Konfiguriert in**: `build.sh`
