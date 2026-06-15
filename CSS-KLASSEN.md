# CSS-Klassen Dokumentation

Diese Dokumentation beschreibt alle verfügbaren benutzerdefinierten CSS-Klassen für die Bürgerenergiegenossenschaft Bösingen-Herrenzimmern Website.

## 🎨 Farbpalette

Die Website verwendet eine naturinspirierte Farbpalette:

```css
--nature-green: #2d5016        /* Hauptgrün für Headlines */
--nature-light-green: #4a7c1b  /* Helleres Grün für Hover-Effekte */
--nature-accent: #8bc34a       /* Akzentfarbe für Buttons und Hervorhebungen */
--nature-brown: #5d4e37        /* Braun für zusätzliche Akzente */
--nature-blue: #4682b4         /* Blau für Links */
```

## 📐 Layout-Klassen

### Textumfluss um Bilder

#### `.float-left`
- **Zweck:** Positioniert ein Element links, Text fließt rechts darum
- **Verwendung:** Für Bilder, die links vom Text stehen sollen
- **Responsive:** Auf Mobile (< 768px) wird das Element zentriert

```markdown
{{< figure
  src="/img/mein-bild.jpg"
  alt="Beschreibung"
  class="float-left"
  width="300px"
>}}

Text fließt rechts um das Bild...
```

#### `.float-right`
- **Zweck:** Positioniert ein Element rechts, Text fließt links darum
- **Verwendung:** Für Bilder, die rechts vom Text stehen sollen
- **Responsive:** Auf Mobile (< 768px) wird das Element zentriert

```markdown
{{< figure
  src="/img/mein-bild.jpg"
  alt="Beschreibung"
  class="float-right"
  width="300px"
>}}

Text fließt links um das Bild...
```

#### `.clearfix`
- **Zweck:** Beendet den Textumfluss und stellt normales Layout wieder her
- **Verwendung:** Nach Float-Elementen, um das Layout zu "clearen"

```html
<div class="clearfix"></div>
```

**Vollständiges Beispiel:**
```markdown
{{< figure
  src="/img/solar.jpg"
  alt="Solaranlage"
  class="float-right"
  width="350px"
  caption="Photovoltaikanlage in Bösingen"
>}}

Dieser Text fließt links um das Bild herum. Das Bild ist rechts positioniert und der Text passt sich automatisch an die verfügbare Breite an.

Auf mobilen Geräten wird das Bild automatisch zentriert dargestellt, um die Lesbarkeit zu verbessern.

<div class="clearfix"></div>

Nach dem clearfix beginnt das normale Layout wieder.
```

## 🎯 Status- und Hinweis-Klassen

### `.status-badge`
- **Zweck:** Kleine Badges für Statusanzeigen
- **Styling:** Grüner Hintergrund, weiße Schrift, abgerundete Ecken
- **Verwendung:** Für Status wie "in Gründung", "aktiv", etc.

```html
<span class="status-badge">in Gründung</span>
```

### `.contact-info`
- **Zweck:** Hervorhebung von Kontaktinformationen
- **Styling:** Heller Hintergrund mit grünem Rand links
- **Verwendung:** Für wichtige Kontaktdaten

```html
<div class="contact-info">
  <h4>Kontakt</h4>
  <p>Email: info@buergerenergie-bhz.de</p>
</div>
```

## 📄 Dokument-Klassen

### `.document-list`
- **Zweck:** Spezielle Listendarstellung für Dokumente
- **Styling:** Keine Listenpunkte, grüner Hintergrund mit Hover-Effekt
- **Verwendung:** Für Download-Listen oder Dokumentverzeichnisse

```html
<ul class="document-list">
  <li><a href="/docs/satzung.pdf">Satzung (PDF)</a></li>
  <li><a href="/docs/beitritt.pdf">Beitrittserklärung (PDF)</a></li>
</ul>
```

## ⚠️ Admonition-Klassen (Hinweisboxen)

### Basis-Struktur
```html
<div class="admonition admonition-[typ]">
  <div class="admonition-header">Überschrift</div>
  <div class="admonition-content">
    <p>Inhalt der Hinweisbox...</p>
  </div>
</div>
```

### Verfügbare Typen:

#### `.admonition-note`
- **Farbe:** Blau
- **Verwendung:** Allgemeine Hinweise und Informationen

#### `.admonition-tip`
- **Farbe:** Grün (Nature-Theme)
- **Verwendung:** Tipps und hilfreiche Informationen

#### `.admonition-warning`
- **Farbe:** Gelb/Orange
- **Verwendung:** Warnungen und Vorsichtshinweise

#### `.admonition-important`
- **Farbe:** Rot
- **Verwendung:** Wichtige Informationen, die Beachtung benötigen

#### `.admonition-danger`
- **Farbe:** Rot
- **Verwendung:** Kritische Warnungen und Gefahrenhinweise

**Beispiel:**
```html
<div class="admonition admonition-tip">
  <div class="admonition-header">💡 Tipp</div>
  <div class="admonition-content">
    <p>Nutzen Sie das Kontaktformular für schnelle Antworten!</p>
  </div>
</div>
```

## 📊 Tabellen-Klassen (Mitgliederverwaltung)

### `.members-table`
- **Zweck:** Spezielle Styling für Mitgliedertabellen
- **Features:** Schatten, abgerundete Ecken, Hover-Effekte
- **Responsive:** Horizontales Scrolling auf kleinen Bildschirmen

```html
<div class="members-table">
  <table class="table table-dark">
    <!-- Tabelleninhalt -->
  </table>
</div>
```

### Status-Badges in Tabellen:
- `.status-active` - Grün für aktive Mitglieder
- `.status-interested` - Blau für Interessenten
- `.status-inactive` - Rot für inaktive Einträge

### Link-Styling in Tabellen:
- `.email-link` - Spezielle Formatierung für E-Mail-Links
- `.phone-link` - Spezielle Formatierung für Telefon-Links

## 🔒 Geschützte Bereiche

### `.protected-area`
- **Zweck:** Header für geschützte/interne Bereiche
- **Styling:** Grüner Verlauf, weiße Schrift, zentriert
- **Verwendung:** Für interne Seiten mit Zugriffsbeschränkung

```html
<div class="protected-area">
  <div class="lock-icon">🔒</div>
  <h1>Geschützter Bereich</h1>
  <p>Nur für Mitglieder zugänglich</p>
</div>
```

### `.csv-download-section`
- **Zweck:** Hervorhebung von Download-Bereichen
- **Styling:** Heller Hintergrund mit grünem Akzent
- **Verwendung:** Für CSV-Downloads und ähnliche Aktionen

```html
<div class="csv-download-section">
  <a href="/data/export.csv" class="btn btn-success">
    📊 CSV herunterladen
  </a>
</div>
```

## 📱 Responsive Verhalten

### Automatische Anpassungen:

1. **Float-Elemente:** Werden auf Mobile zentriert dargestellt
2. **Schriftgrößen:** Automatische Verkleinerung auf kleineren Bildschirmen
3. **Tabellen:** Horizontales Scrolling bei Überlauf
4. **Navigation:** Spezielle Mobile-Navigation mit Hamburger-Menü

### Breakpoints:
- **Desktop:** ≥ 992px
- **Tablet:** 768px - 991px
- **Mobile:** ≤ 767px
- **Small Mobile:** ≤ 480px

## 🎨 Shortcode-Integration

### Figure mit CSS-Klassen:
```markdown
{{< figure
  src="/img/beispiel.jpg"
  alt="Beschreibung"
  class="float-right shadow rounded"
  width="400px"
  caption="Bildunterschrift"
  title="Bildtitel"
>}}
```

### Tally-Formulare:
```markdown
{{< tally
  src="https://tally.so/embed/..."
  height="400"
  title="Kontaktformular"
>}}
```

## 💡 Best Practices

### 1. Bilder mit Textumfluss:
- Verwenden Sie `width="300px"` bis `width="400px"` für optimale Darstellung
- Setzen Sie immer einen `alt`-Text für Barrierefreiheit
- Nutzen Sie `clearfix` nach Float-Bereichen

### 2. Responsive Design:
- Testen Sie die Darstellung auf verschiedenen Bildschirmgrößen
- Mobile-First: Denken Sie zuerst an kleine Bildschirme

### 3. Farben und Kontraste:
- Nutzen Sie die definierten CSS-Variablen für konsistente Farben
- Achten Sie auf ausreichende Kontraste für Barrierefreiheit

### 4. Performance:
- Optimieren Sie Bildgrößen (WebP-Format bevorzugt)
- Vermeiden Sie übermäßige Verschachtelung von CSS-Klassen

---

**Letzte Aktualisierung:** 5. August 2025
**Version:** 1.0
**Projekt:** Bürgerenergiegenossenschaft Bösingen-Herrenzimmern
