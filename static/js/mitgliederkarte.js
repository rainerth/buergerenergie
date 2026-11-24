/* BEG-Mitgliederkarte — Leaflet-Setup
 * Lädt /data/mitgliederkarte.geojson und rendert Pins mit MarkerCluster.
 * Filter nach Stadium, Suche nach Name/Mitgliedsnummer.
 */
(function () {
    'use strict';

    const DATA_URL = '/data/mitgliederkarte.geojson';
    const BOESINGEN = [48.182, 8.566];
    const MK_BLAU = '#2763a5';
    const MK_GOLD = '#f9b61d';

    const state = {
        map: null,
        cluster: null,
        features: [],
        markers: new Map(),   // mitgliedsnummer → marker
        show: { mitglied: true, bewerber: true },
    };

    function fmtEuro(n) {
        return n.toLocaleString('de-DE') + ' €';
    }

    function fmtDate(iso) {
        return iso || '';
    }

    function renderStats(stats, generatedAt) {
        const el = document.getElementById('mitgliederkarte-stats');
        if (!el) return;
        const d = new Date(generatedAt);
        const dateStr = d.toLocaleString('de-DE', {
            dateStyle: 'short', timeStyle: 'short',
        });
        el.innerHTML = `
          <div class="mk-stat"><span class="mk-stat-value">${stats.total}</span>
            <span>Einträge</span></div>
          <div class="mk-stat"><span class="mk-stat-value">${stats.mitglieder}</span>
            <span>Mitglieder</span></div>
          <div class="mk-stat"><span class="mk-stat-value">${stats.bewerber}</span>
            <span>Bewerber:innen</span></div>
          <div class="mk-stat"><span class="mk-stat-value">${stats.anteile_sum}</span>
            <span>Anteile = ${fmtEuro(stats.einlage_sum_eur)}</span></div>
          <div class="mk-generated">Stand ${dateStr}</div>
        `;
    }

    /**
     * Deterministischer Jitter für Features, die auf exakt denselben Koordinaten
     * sitzen (Familien an einer Adresse). Verteilt sie auf einen Kreis mit
     * ~15 m Radius, Winkel aus dem Index in der Gruppe.
     */
    function applyJitter(features) {
        const groups = new Map();
        for (const ft of features) {
            const [lon, lat] = ft.geometry.coordinates;
            const key = `${lat.toFixed(6)},${lon.toFixed(6)}`;
            if (!groups.has(key)) groups.set(key, []);
            groups.get(key).push(ft);
        }
        const R = 0.00015; // ca. 15 m bei lat 48°
        for (const grp of groups.values()) {
            if (grp.length < 2) continue;
            // Sortiert nach Mitgliedsnummer → stabile Reihenfolge
            grp.sort((a, b) =>
                parseInt(a.properties.mitgliedsnummer) -
                parseInt(b.properties.mitgliedsnummer));
            const n = grp.length;
            for (let i = 0; i < n; i++) {
                const angle = (2 * Math.PI * i) / n - Math.PI / 2;
                const [lon0, lat0] = grp[i].geometry.coordinates;
                // Längengrad bei lat 48° stauchen (cos(48°) ≈ 0.669)
                grp[i].geometry.coordinates = [
                    lon0 + (R * Math.cos(angle)) / Math.cos(lat0 * Math.PI / 180),
                    lat0 + R * Math.sin(angle),
                ];
                grp[i].properties._jittered = true;
            }
        }
    }

    function markerFor(feature) {
        const p = feature.properties;
        const isMitglied = p.stadium === 'Mitglied';
        const [lon, lat] = feature.geometry.coordinates;
        const size = 28;
        const cls = isMitglied ? 'mk-marker-mitglied' : 'mk-marker-bewerber';
        const icon = L.divIcon({
            className: '',
            html: `<div class="mk-marker ${cls}"
                        style="width:${size}px;height:${size}px"></div>`,
            iconSize: [size, size],
            iconAnchor: [size / 2, size / 2],
        });
        const marker = L.marker([lat, lon], { icon });
        marker.bindPopup(popupHtml(p), { maxWidth: 320 });
        marker._mkData = p;   // für Filter/Suche
        return marker;
    }

    function popupHtml(p) {
        const badge = p.stadium === 'Mitglied'
            ? '<span class="mk-badge mk-badge-mitglied">Mitglied</span>'
            : '<span class="mk-badge mk-badge-bewerber">Bewerber:in</span>';
        const ortsteil = p.ortsteil
            ? ` · ${escape(p.ortsteil)}`
            : '';
        const accuracyHint = p.geocode_accuracy !== 'house'
            ? `<div class="mk-popup-row" style="color:#999;font-size:0.85em"><em>Position: nur ${p.geocode_accuracy === 'street' ? 'Straße' : 'Stadt'}</em></div>`
            : '';
        return `
          <h4>Nr. ${escape(p.mitgliedsnummer)} — ${escape(p.name)}</h4>
          <div class="mk-popup-row">${badge}</div>
          <div class="mk-popup-row"><span class="mk-popup-label">Anschrift:</span>
            <span>${escape(p.strasse)}<br>${escape(p.plz)} ${escape(p.ort)}${ortsteil}</span></div>
          ${accuracyHint}
        `;
    }

    function escape(s) {
        return String(s ?? '').replace(/[&<>"']/g, c => ({
            '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;', "'": '&#39;',
        }[c]));
    }

    function refilter() {
        state.cluster.clearLayers();
        for (const [num, m] of state.markers) {
            const isMitglied = m._mkData.stadium === 'Mitglied';
            if (isMitglied && state.show.mitglied) state.cluster.addLayer(m);
            else if (!isMitglied && state.show.bewerber) state.cluster.addLayer(m);
        }
    }

    function addLegend() {
        const legend = L.control({ position: 'bottomright' });
        legend.onAdd = function () {
            const div = L.DomUtil.create('div', 'mk-legend');
            div.innerHTML = `
              <h4>Filter</h4>
              <label><input type="checkbox" id="flt-mitglied" checked>
                <span class="mk-swatch mk-swatch-mitglied"></span>Mitglieder</label>
              <label><input type="checkbox" id="flt-bewerber" checked>
                <span class="mk-swatch mk-swatch-bewerber"></span>Bewerber:innen</label>
              <button id="flt-fitall">Alle zeigen</button>
            `;
            L.DomEvent.disableClickPropagation(div);
            L.DomEvent.disableScrollPropagation(div);
            setTimeout(() => {
                document.getElementById('flt-mitglied').onchange = (e) => {
                    state.show.mitglied = e.target.checked; refilter();
                };
                document.getElementById('flt-bewerber').onchange = (e) => {
                    state.show.bewerber = e.target.checked; refilter();
                };
                document.getElementById('flt-fitall').onclick = () => {
                    const bounds = L.latLngBounds(
                        state.features.map(f => [f.geometry.coordinates[1], f.geometry.coordinates[0]])
                    );
                    state.map.fitBounds(bounds.pad(0.1));
                };
            }, 0);
            return div;
        };
        legend.addTo(state.map);
    }

    function addSearch() {
        const search = L.control({ position: 'topleft' });
        search.onAdd = function () {
            const div = L.DomUtil.create('div', 'mk-search');
            div.innerHTML = `<input type="search"
                placeholder="Name oder Nummer suchen …"
                id="mk-searchbox">`;
            L.DomEvent.disableClickPropagation(div);
            setTimeout(() => {
                const box = document.getElementById('mk-searchbox');
                box.oninput = (e) => {
                    const q = e.target.value.trim().toLowerCase();
                    if (q.length < 2) return;
                    for (const [num, m] of state.markers) {
                        const p = m._mkData;
                        if (p.mitgliedsnummer === q
                            || p.name.toLowerCase().includes(q)) {
                            state.map.setView(m.getLatLng(), 17, { animate: true });
                            m.openPopup();
                            return;
                        }
                    }
                };
            }, 0);
            return div;
        };
        search.addTo(state.map);
    }

    function init(geojson) {
        applyJitter(geojson.features);
        state.features = geojson.features;
        renderStats(geojson.stats, geojson.generated_at);

        state.map = L.map('mitgliederkarte').setView(BOESINGEN, 14);
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>-Mitwirkende',
        }).addTo(state.map);

        state.cluster = L.markerClusterGroup({
            maxClusterRadius: 40,
            spiderfyOnMaxZoom: true,
            showCoverageOnHover: false,
            spiderfyDistanceMultiplier: 1.5,
            disableClusteringAtZoom: 18,
        });
        state.map.addLayer(state.cluster);

        for (const feature of geojson.features) {
            const marker = markerFor(feature);
            state.markers.set(feature.properties.mitgliedsnummer, marker);
            state.cluster.addLayer(marker);
        }

        // Fit auf alle Features mit kleinem Padding, aber Default-Zoom nicht
        // zu sehr rauszoomen (Wien-Ausreißer würde sonst ganz Europa zeigen).
        const boesingenFeatures = state.features.filter(f => f.properties.plz.startsWith('786'));
        if (boesingenFeatures.length) {
            const bounds = L.latLngBounds(
                boesingenFeatures.map(f => [f.geometry.coordinates[1], f.geometry.coordinates[0]])
            );
            state.map.fitBounds(bounds.pad(0.2));
        }

        addLegend();
        addSearch();
    }

    document.addEventListener('DOMContentLoaded', () => {
        fetch(DATA_URL, { credentials: 'same-origin' })
            .then(r => {
                if (!r.ok) throw new Error(`HTTP ${r.status}`);
                return r.json();
            })
            .then(init)
            .catch(e => {
                const el = document.getElementById('mitgliederkarte');
                if (el) el.innerHTML = `<p style="padding:20px;color:#a00">
                    Konnte Mitgliederdaten nicht laden: ${e.message}</p>`;
            });
    });
})();
