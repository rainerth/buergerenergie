# CSS-Klassen Kurzreferenz

## 🎯 Häufig verwendete Klassen

### Textumfluss
```markdown
class="float-left"    # Bild links, Text rechts
class="float-right"   # Bild rechts, Text links
<div class="clearfix"></div>  # Beendet Umfluss
```

### Status & Hinweise
```html
<span class="status-badge">Status</span>
<div class="contact-info">Kontaktinfo</div>
```

### Hinweisboxen
```html
<div class="admonition admonition-tip">
  <div class="admonition-header">Tipp</div>
  <div class="admonition-content"><p>Text</p></div>
</div>
```

**Typen:** `note`, `tip`, `warning`, `important`, `danger`

### Dokumente
```html
<ul class="document-list">
  <li><a href="/doc.pdf">Dokument</a></li>
</ul>
```

### Geschützte Bereiche
```html
<div class="protected-area">
  <h1>Geschützter Bereich</h1>
</div>
```

## 🎨 Farbvariablen
```css
var(--nature-green)       # #2d5016 - Headlines
var(--nature-light-green) # #4a7c1b - Hover
var(--nature-accent)      # #8bc34a - Buttons
var(--nature-blue)        # #4682b4 - Links
```

## 📱 Responsive Breakpoints
- **Desktop:** ≥ 992px
- **Tablet:** 768-991px  
- **Mobile:** ≤ 767px

---
**Tipp:** Vollständige Dokumentation in `CSS-KLASSEN.md`
