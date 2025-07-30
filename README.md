# buergerenergie
Hugo Website of Bürgerenergie Bösingen 


# Installation auf github

git submodule update --init --recursive

Hier ist ein vollständiger Ablauf, wie du ein lokales Git-Projekt zu einem bestehenden GitHub-Repository namens `rainerth/buergerenergie` hochlädst:

---

## 🔧 Voraussetzungen

- Du hast ein lokales Git-Projekt (Verzeichnis mit `git init`)
- Du hast ein GitHub-Repository [`rainerth/buergerenergie`](https://github.com/rainerth/buergerenergie) bereits erstellt
- Du hast SSH- oder HTTPS-Zugriff auf GitHub eingerichtet (z. B. via SSH-Key oder Personal Access Token)

---

## ✅ Schritt-für-Schritt-Anleitung

### 1. Im lokalen Projektverzeichnis arbeiten

```bash
cd /pfad/zum/deinem/projekt
```

### 2. Git initialisieren (falls noch nicht passiert)

```bash
git init
```

### 3. Dateien hinzufügen und committen

```bash
git add .
git commit -m "Initial commit"
```

### 4. Remote-Repository hinzufügen

#### Variante A: Mit HTTPS

```bash
git remote add origin https://github.com/rainerth/buergerenergie.git
```

#### Variante B: Mit SSH

```bash
git remote add origin git@github.com:rainerth/buergerenergie.git
```

> Du kannst prüfen, ob die Remote korrekt gesetzt wurde mit:

```bash
git remote -v
```

### 5. Hauptbranch benennen (falls nötig)

```bash
git branch -M main
```

### 6. Upload zu GitHub

```bash
git push -u origin main
```

---

## 🧹 Optional: `.gitignore` hinzufügen

Falls du bestimmte Dateien wie `public/`, `*.log`, oder `*.pyc` ignorieren willst, lege eine `.gitignore` an:

```bash
echo "public/" >> .gitignore
git add .gitignore
git commit -m "Add .gitignore"
git push
```

---

## 💡 Typische Probleme

- ❗ "non-fast-forward" Fehler → Dein Remote enthält bereits Commits. In dem Fall:

```bash
git pull --rebase origin main
# oder, wenn Konflikte egal sind:
git push -f origin main
```

---

Wenn du möchtest, kann ich dir ein Shell-Skript oder eine Vorlage für `.gitignore` speziell für Hugo/Webprojekte erstellen.
