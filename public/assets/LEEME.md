# Sus retratos

El juego busca dos imágenes en esta carpeta:

```
public/assets/jose.png
public/assets/fer.png
```

Si están, aparecen en los medallones dorados del lobby, en las tarjetas de corredor,
en la barra de la pantalla de preguntas y en los carriles de la carrera.
Si no están, el juego dibuja solo el emblema de cada quien (el auto y la nave) y todo
sigue funcionando igual — no se rompe nada.

**Recomendación:** imágenes cuadradas o verticales, mínimo 600 × 750 px, con la cara
centrada en la parte de arriba (los medallones son circulares y recortan por el centro).
Sirve `.png` o `.jpg` renombrado a `.png`. Si prefieres otro nombre o formato, cambia la
constante `RETRATO` al inicio del `<script>` de `public/index.html`.
