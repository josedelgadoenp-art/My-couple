# Los retratos de José y Fer

El juego usa cuatro imágenes de esta carpeta:

```
jose.jpg            retrato cuadrado  (medallones, carriles de la carrera y placas del podio)
fer.jpg
jose-tarjeta.jpg    retrato vertical  (las tarjetas grandes del lobby)
fer-tarjeta.jpg
```

Las que están ahora salieron recortadas del boceto original.

## Cambiarlas

Reemplaza los archivos conservando los nombres y listo — no hay que tocar código.

- **Cuadradas:** 320 × 320 px, con la cara centrada. Se recortan en círculo, así que deja
  aire alrededor de la cabeza.
- **Verticales:** 440 × 550 px (proporción 4:5), de la cabeza al pecho.

Si prefieres otros nombres o formatos, cambia las constantes `RETRATO` y `RETRATO_TARJETA`
al inicio del `<script>` de `public/index.html`.

Si alguno de los archivos falta o no carga, el juego dibuja en su lugar la inicial de cada
quien en oro y todo sigue funcionando igual.
