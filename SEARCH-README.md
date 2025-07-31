# Search Setup für Hugo Site

## Übersicht

Die Suche ist mit PageFind implementiert, einem statischen Suchtool, das nach dem Build der Website läuft.

## Installation von PageFind

PageFind kann auf verschiedene Weise installiert werden:

### Option 1: NPX (Empfohlen - keine Installation erforderlich)
```bash
npx pagefind --site public --output-subdir pagefind
```

### Option 2: NPM Global Installation
```bash
npm install -g pagefind
```

### Option 3: NPM als Dev-Dependency
```bash
npm install --save-dev pagefind
```

### Option 4: Precompiled Binary (Linux/macOS/Windows)
```bash
# Linux/macOS
curl -fsSL https://github.com/CloudCannon/pagefind/releases/latest/download/pagefind-extended-$(uname -m)-unknown-linux-musl.tar.gz | tar -xz

# Windows (PowerShell)
Invoke-WebRequest -Uri "https://github.com/CloudCannon/pagefind/releases/latest/download/pagefind-extended-x86_64-pc-windows-msvc.zip" -OutFile "pagefind.zip"
Expand-Archive -Path "pagefind.zip" -DestinationPath "."
```

### Option 5: Cargo (Rust)
```bash
cargo install pagefind
```

**Hinweis:** Das Build-Script (`./build.sh`) in diesem Projekt verwendet `npx pagefind`, daher ist keine separate Installation erforderlich, solange Node.js installiert ist.

## Verwendung

### Build mit Suche
```bash
./build.sh
```

Oder mit VS Code Task:
- `Ctrl+Shift+P` → "Tasks: Run Task" → "Hugo: Build with Search"

### Development Server
```bash
hugo server
```

Oder mit VS Code Task:
- `Ctrl+Shift+P` → "Tasks: Run Task" → "Hugo: Development Server"

## Konfiguration

Die Suche ist in `hugo.toml` konfiguriert:

```toml
[params]
    search = true
    search_provider = "pagefind"
```

## Search-Seite

Die Search-Seite befindet sich unter `/content/search/_index.md`

## PageFind

PageFind wird automatisch durch das Build-Script ausgeführt und erstellt einen Suchindex in `public/pagefind/`.

### Manuelle PageFind-Ausführung

```bash
npx pagefind --site public --output-subdir pagefind
```

## Deployment

Für das Deployment müssen Sie immer das Build-Script verwenden:

```bash
./build.sh
```

Dies stellt sicher, dass sowohl Hugo als auch PageFind ausgeführt werden.

## Troubleshooting

### Suche funktioniert nicht
1. Prüfen Sie, ob PageFind-Dateien in `public/pagefind/` vorhanden sind
2. Führen Sie `./build.sh` aus, um den Suchindex neu zu erstellen
3. Prüfen Sie die Browser-Konsole auf JavaScript-Fehler

### 404-Fehler bei /search
1. Prüfen Sie, ob `/content/search/_index.md` existiert
2. Führen Sie `hugo` aus, um die Website neu zu erstellen

### PageFind-Index ist leer
1. Prüfen Sie, ob die HTML-Seiten korrekt generiert wurden
2. Führen Sie PageFind manuell aus: `npx pagefind --site public --output-subdir pagefind`
