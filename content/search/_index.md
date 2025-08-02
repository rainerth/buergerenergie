---
title: "Suche"
layout: "search"
summary: "Durchsuchen Sie unsere Website"
description: "Suchen Sie nach Inhalten auf der Website der Bürgerenergie-Genossenschaft Bösingen"
---

# Suche

Suchen Sie hier nach Inhalten auf unserer Website:

<div id="search"></div>

<script>
    window.addEventListener('DOMContentLoaded', (event) => {
        new PagefindUI({
            element: "#search",
            showImages: false,
            showSubResults: true,
            excerptLength: 30,
            processResult: function (result) {
                // Customize result display if needed
                return result;
            }
        });
    });
</script>