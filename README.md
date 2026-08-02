# Carrera del Amor

Juego de trivia de pareja para dos celulares. Cada quien **adivina** 10 respuestas de su
pareja, se intercambian y **cada quien califica** lo que el otro escribió sobre él. Gana
quien tenga más aciertos.

No hay comparación automática de textos: la persona que conoce la respuesta es la que
decide si le atinaron. Así “el azul” cuenta igual que “azul”, y cuando alguien falla puede
anotar cuál era la respuesta de verdad.

**Dirección de arte:** rosa profundo y oro repujado, marcos de filigrana, tarjetas de
pergamino con encaje, atardecer entre pétalos y un cielo de constelaciones de corazón
para el podio.

Todo el arte (rosas, coronas, medallas, relojes de bolsillo, candados, llaves, banderas,
corazones, filigranas) son ilustraciones vectoriales SVG dibujadas dentro del propio
`index.html`. **No se usa ni un solo emoji**, así que el juego se ve igual en iPhone,
Android, Windows y Mac.

**Sin dependencias de red:** las tipografías (Cinzel Decorative, Cinzel y Great Vibes) van
empotradas en el archivo como `@font-face` con data URI, en un subconjunto con el alfabeto
completo del español. El juego se ve idéntico aunque no cargue nada externo.

---

## Estructura

```
public/index.html            el juego completo (arte, tipografías, estilos y lógica)
public/favicon.*             el icono del sitio, con el corazón del logo de Fer y José
public/site.webmanifest      para agregar el juego a la pantalla de inicio del celular
public/assets/               retratos, escenas del podio y ramo (ver assets/LEEME.md)
netlify/functions/sala.mjs   función serverless que sincroniza los dos celulares
netlify.toml                 configuración de Netlify
```

## Las imágenes

Los avatares de José y Fer están en `public/assets/` y aparecen en los medallones dorados
del lobby, en las tarjetas de corredor, en la barra de la pantalla de preguntas, corriendo
por los carriles de la carrera y en las placas del podio. Ahí mismo viven las dos escenas
del podio —una para cuando gana cada quien— y el ramo de rosas del pedestal. Para cambiarlos basta con
reemplazar los archivos conservando los nombres; los detalles están en
`public/assets/LEEME.md`. Si alguno falta, el juego dibuja la inicial en oro en su lugar.

## Cómo desplegarlo

### 1. Upstash (la base de datos de la sala)

1. Entra a [upstash.com](https://upstash.com) y crea una base **Redis** en una región cercana
   (por ejemplo `us-east-1`).
2. En la pestaña **REST API** copia estos dos valores:
   - `UPSTASH_REDIS_REST_URL`
   - `UPSTASH_REDIS_REST_TOKEN`

### 2. Netlify

1. Sube este repositorio a Netlify (o arrastra la carpeta completa a Netlify Drop).
2. En **Site configuration → Environment variables** agrega las dos variables de arriba
   con exactamente esos nombres.
3. Despliega. Netlify lee `netlify.toml` solo: publica `public/` y monta la función en `/api/sala`.
4. Si usas tu dominio propio, apúntalo como siempre.

### 3. Probar

Abre `https://tu-sitio/api/sala?code=TEST`. Debe responder:

```json
{"code":"TEST","J":null,"F":null}
```

Si sale `{"error":"Faltan las variables de Upstash"}`, revisa el paso 2 y vuelve a desplegar
(las variables solo se aplican en un build nuevo).

---

## Cómo se juega

1. **Elegir corredor.** Cada quien abre el sitio y toca su tarjeta con su retrato:
   Fer (*Velocidad de Corazón*) o José (*Paciencia Infinita*). Arriba, la barra **Corazón de
   Afecto** acumula todos los aciertos de la pareja durante la sesión.
2. **Abrir o entrar.** Uno toca **ABRIR NUESTRA SALA** y aparece un código de 4 caracteres
   en fichas de pergamino. El otro escribe ese código y toca **ENTRAR CON CÓDIGO**.
3. **Adivinar (3 minutos).** A cada quien le tocan 10 preguntas *sobre su pareja* y escribe
   lo que cree que va a contestar. Las tarjetas de pergamino se marcan y la llave se abre
   conforme las llenas; el reloj de bolsillo de corazón marca el tiempo.
4. **Intercambio.** Las cartas, rosas y llaves vuelan por la pantalla: las respuestas
   cambian de dueño.
5. **Calificar.** Ahora lees, una por una, la pregunta *sobre ti* y lo que tu pareja
   escribió, y decides: **Sí, le atinó** o **No era**. Cada “sí” avanza una casilla en el
   carril de tu pareja y los dos carriles se mueven en vivo. Cuando alguien falla puedes
   anotarle **cuál era la respuesta** — es opcional y aparece al final.
6. **El podio.** Cielo de constelaciones de corazón, corona flotante, la frase escrita a
   mano letra por letra y la ilustración de los dos celebrando —cambia según quién gana—
   sobre un pedestal de mármol con ramos de rosas: placa de oro con corona para quien gana
   y de plata con medalla para el segundo, cada una con su retrato. El botón **Ver nuestras
   respuestas** abre el repaso de la ronda: qué escribiste, si le atinaste y la respuesta
   verdadera. Quien abrió la sala controla el botón de **siguiente ronda**; el marcador se
   acumula toda la sesión.

También hay un botón de **Cómo se juega** en el lobby que abre estas reglas dentro del juego.

### Modo demo

El botón **Modo demo** del lobby juega contra la computadora en un solo dispositivo: sirve
para enseñar el juego o probar el diseño sin necesidad de servidor. Si el sitio detecta que
`/api/sala` no responde, el demo se vuelve la opción principal automáticamente.
También puedes entrar directo con `?demo=1` en la URL.

---

## Detalles técnicos

- **Sincronización:** sondeo adaptativo — 1.1 s durante la carrera, 2.5 s en las demás pantallas.
  Cada ciclo es una sola petición HTTP: escribe mi estado y devuelve el de los dos.
  Si mi estado no cambió, solo lee (un comando en vez de dos).
- **Consumo de Upstash:** aproximadamente 2 comandos por dispositivo por ciclo. Una partida
  de 15 minutos ronda los 2–3 mil comandos. Si te acercas al límite de tu plan, sube los
  números de `RITMO` en `public/index.html`.
- **Autoridad:** el anfitrión (quien creó la sala) decide los cambios de fase, sortea las
  preguntas y declara al ganador. El invitado sigue lo que publica el anfitrión.
- **Empates:** si los dos terminan con los mismos aciertos, ganan los dos.
- **Fin de la ronda:** el resultado se cierra cuando los dos terminaron de calificar. Si uno
  se queda a medias, el anfitrión puede cerrarla con *Terminar ronda*, y de todos modos se
  cierra sola a los 2 min 30 s (`ESPERA_CALIF`).
- **Reconexión:** el rol se guarda en `sessionStorage`. Si recargas, aparece el botón
  *Retomar sala* en el lobby.
- **Sala:** vive 6 horas en Redis y luego expira sola.
- **Límite:** 260 peticiones por IP por minuto en la función, por si acaso.
- **Accesibilidad:** respeta `prefers-reduced-motion` (apaga las animaciones) y usa
  `env(safe-area-inset-*)` para las muescas de los celulares.

## Personalizar

- **Preguntas:** el arreglo `BANK` al inicio del `<script>`. Cada entrada tiene `a` (como la ves tú)
  y `b` (como la ve tu pareja, con `{X}` para el nombre). Hay 67; agrega las que quieras.
  Si agregas preguntas, añade también su respuesta en `DEMO_ANS` (misma posición) para el modo demo.
- **Nombres:** la constante `NAMES`.
- **Tiempo para adivinar:** la constante `SETUP_SEG` (180 segundos).
- **Preguntas por ronda:** la constante `PREGUNTAS` (10).
- **Colores y tipografías:** las variables CSS en `:root`.
- **Nombres de los rasgos:** la constante `RASGO`.
- **Meta del Corazón de Afecto:** la constante `META_AFECTO` (100 corazones).
- **Retratos y escenas del podio:** las constantes `RETRATO`, `RETRATO_TARJETA` y `ESCENA`.
- **Ilustraciones:** el bloque `<svg id="sprites">`. Cada dibujo es un `<symbol>` con su `id`;
  para cambiar uno solo edita ese símbolo y se actualiza en todas las pantallas donde aparece.
