---
title: "Suche"
layout: "search"
summary: "Durchsuche unsere Website"
description: "Such nach Inhalten auf der Website der Bürgerenergiegenossenschaft Bösingen-Herrenzimmern"
---

# Suche

Such hier nach Inhalten auf unserer Website:

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