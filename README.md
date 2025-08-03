# buergerenergie
Hugo Website of Bürgerenergie Bösingen

## 🔍 Suchfunktionalität

Die Website verfügt über eine vollständig implementierte Suchfunktion basierend auf [PageFind](https://pagefind.app/), einem statischen Suchtool.

### Features
- ✅ Volltext-Suche über alle Inhalte
- ✅ Deutsche Lokalisierung
- ✅ Automatische Indexierung
- ✅ Responsive Design
- ✅ Keine Server-Abhängigkeiten

### Verwendung

#### Build mit Suche (Produktiv)
```bash
./build.sh
```

#### Development Server
```bash
hugo server
```

#### VS Code Tasks
- `Ctrl+Shift+P` → "Tasks: Run Task" → "Hugo: Build with Search"
- `Ctrl+Shift+P` → "Tasks: Run Task" → "Hugo: Development Server"

### Konfiguration

Die Suche ist in `hugo.toml` aktiviert:
```toml
[params]
    search = true
    search_provider = "pagefind"
```

### Technische Details

- **Search-Seite:** `/content/search/_index.md`
- **Layout:** `/layouts/_default/search.html`
- **Partial:** `/layouts/partials/search-pagefind.html`
- **Build-Script:** `./build.sh`
- **Index-Pfad:** `public/pagefind/`

Die Suche funktioniert nur in der produktiven Version (nach `./build.sh`). Im Development-Modus wird ein entsprechender Hinweis angezeigt.

### PageFind Installation

Das Build-Script verwendet `npx pagefind`, daher ist keine separate Installation erforderlich, solange Node.js verfügbar ist.

Weitere Details siehe [`SEARCH-README.md`](SEARCH-README.md).

