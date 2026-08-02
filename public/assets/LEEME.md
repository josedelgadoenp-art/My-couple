# Las imágenes del juego

Todas salieron recortadas de los bocetos originales.

```
jose.jpg            retrato cuadrado   medallones, carriles de la carrera y placas del podio
fer.jpg
jose-tarjeta.jpg    retrato vertical   las tarjetas grandes del lobby
fer-tarjeta.jpg
podio-jose.webp     escena del podio   la que se muestra cuando gana José
podio-fer.webp      escena del podio   cuando gana Fer y cuando empatan
ramo.webp           ramo de rosas      descansa en la repisa del pedestal
```

## Cambiarlas

Reemplaza los archivos conservando los nombres y listo — no hay que tocar código.

- **Retratos cuadrados:** 320 × 320 px, con la cara centrada. Se recortan en círculo, así que
  deja aire alrededor de la cabeza.
- **Retratos verticales:** 440 × 550 px (proporción 4:5), de la cabeza al pecho.
- **Escenas del podio:** 680 px de ancho, proporción cercana a 2:1, en PNG o WebP con
  transparencia. Los bordes de arriba y de los lados van difuminados para que se fundan con
  el cielo; la parte de abajo queda tapada por la repisa del pedestal.
- **Ramo:** 436 × 264 px con transparencia.

Si prefieres otros nombres o formatos, cambia las constantes `RETRATO`, `RETRATO_TARJETA` y
`ESCENA` al inicio del `<script>` de `public/index.html`.

Si un retrato no carga, el juego dibuja en su lugar la inicial de cada quien en oro. Si la
escena del podio no carga, simplemente no se muestra. En los dos casos el juego sigue
funcionando igual.
