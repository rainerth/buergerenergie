---
title: "Mitgliederkarte"
subtitle: "Räumliche Übersicht aller CoopX-Einträge"
date: 2026-11-22
draft: false
unlisted: true
slug: "mitgliederkarte"
url: "/intern/mitgliederkarte/"
sitemap:
  disable: true
robotsNoIndex: true
---

Interne Karte aus dem jüngsten CoopX-Export. Stand und Statistik werden aus der GeoJSON gezogen und im Panel rechts oben dargestellt.

{{< mitgliederkarte >}}

---

**Rechtsgrundlage:** Art. 6 Abs. 1 lit. c DSGVO i.V.m. § 30 GenG (Mitgliederverzeichnis). Diese Darstellung dient der Vorstandsarbeit und darf nicht weitergegeben werden.

**Datenfluss:** CoopX-CSV (manueller Export durch rth) → Skill `beg-coopx-map` auf thlx06 (Nominatim-Geocoding, Sensitiv-Felder gestrippt) → GeoJSON auf wme00-buergerenergie → diese Seite. Cron alle 6 Stunden.
