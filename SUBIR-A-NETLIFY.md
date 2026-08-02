# Subir Carrera del Amor a Netlify a mano

Todo lo que necesitas está en `carrera-del-amor.zip`. Los archivos ya vienen acomodados
como Netlify los espera en un despliegue manual: el juego en la raíz y la función a un lado.

```
index.html            el juego completo — arte, tipografías, estilos y lógica
favicon.svg           el icono del sitio (más los PNG de 16, 32, 180 y 512)
site.webmanifest      para agregar el juego a la pantalla de inicio del celular
assets/               los retratos, las escenas del podio y el ramo de rosas
netlify.toml          la configuración
netlify/functions/
  sala.mjs            lo que sincroniza los dos celulares
```

---

## 1. Crear la base de datos (Upstash)

La sala vive seis horas en una base Redis gratuita. Es el único servicio externo.

1. Entra a **upstash.com**, crea una cuenta y haz clic en **Create Database**.
2. Elige **Redis** y una región cercana (`us-east-1` está bien desde México).
3. Ya creada, abre la pestaña **REST API** y copia estos dos valores:
   - `UPSTASH_REDIS_REST_URL`
   - `UPSTASH_REDIS_REST_TOKEN`

Déjalos a la mano, los necesitas en el paso 3.

## 2. Subir el sitio

1. Entra a **app.netlify.com** y haz clic en **Add new site → Deploy manually**.
2. Arrastra el **archivo `carrera-del-amor.zip` completo**, sin descomprimir, a la zona de
   soltar. Netlify lo abre solo.
3. En un minuto tienes una liga tipo `https://algo-random-123.netlify.app`.

> Si prefieres descomprimirlo, arrastra la carpeta que sale, no una carpeta que la contenga.
> Lo que arrastres tiene que tener `index.html` hasta arriba.

## 3. Conectar la base de datos

En el sitio recién creado, ve a **Site configuration → Environment variables → Add a variable**
y agrega las dos, **con exactamente esos nombres**:

| Nombre | Valor |
|---|---|
| `UPSTASH_REDIS_REST_URL` | lo que copiaste de Upstash |
| `UPSTASH_REDIS_REST_TOKEN` | lo que copiaste de Upstash |

Después vuelve a **Deploys** y arrastra el ZIP otra vez. **Esto es importante:** las
variables solo se aplican en un despliegue nuevo, así que si no lo vuelves a subir, el
juego no va a encontrar la base.

## 4. Comprobar que quedó

Abre en el navegador:

```
https://tu-sitio.netlify.app/api/sala?code=TEST
```

Debe contestar exactamente esto:

```json
{"code":"TEST","J":null,"F":null}
```

- Si sale `{"error":"Faltan las variables de Upstash"}` → falta el paso 3, o no volviste a
  subir el ZIP después de agregar las variables.
- Si sale un 404 → la carpeta `netlify/functions` no llegó. Revisa que hayas arrastrado el
  ZIP completo y no solo los archivos del juego.

Cuando eso conteste bien, abre el sitio en los dos celulares y ya.

## 5. Tu dominio (opcional)

En **Domain management → Add a domain** pones el dominio de GoDaddy y Netlify te dice qué
registros apuntar. El juego funciona igual con la liga `.netlify.app`.

---

## Cómo se juega

1. Cada quien abre el sitio en **su propio celular** y toca su tarjeta: Fer o José.
2. Uno toca **Abrir nuestra sala** y le dicta al otro el código de 4 letras.
3. Tienen 3 minutos para **adivinar** 10 respuestas de la pareja.
4. Se intercambian y cada quien **califica** lo que el otro escribió sobre él: *Sí, le
   atinó* o *No era*. Si falló, puedes anotarle cuál era la respuesta.
5. Gana quien tenga más aciertos. En el podio, **Ver nuestras respuestas** muestra el
   repaso de la ronda.

El botón **Modo demo** del lobby juega contra la computadora en un solo celular, por si
quieres enseñarlo sin que estén los dos.

## Cambiar cosas después

- **Los retratos:** reemplaza los archivos de `assets/` conservando los nombres.
- **Las preguntas:** el arreglo `BANK` al inicio del `<script>` de `index.html`. Hay 67.
- **El tiempo para adivinar:** la constante `SETUP_SEG` (180 segundos).
- **Las preguntas por ronda:** la constante `PREGUNTAS` (10).

Cada vez que cambies algo, vuelve a comprimir la carpeta y arrástrala a **Deploys**.
