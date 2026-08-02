#!/usr/bin/env bash
# Arma carrera-del-amor.zip, listo para arrastrar a Netlify en un despliegue manual.
# Aplana public/ a la raíz —que es lo que Netlify publica cuando no hay build— y
# mete la función a un lado.
set -euo pipefail
cd "$(dirname "$0")"
SALIDA="$(realpath -m "${1:-carrera-del-amor.zip}")"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

cp -r public/. "$TMP"/
rm -f "$TMP/assets/LEEME.md"
mkdir -p "$TMP/netlify/functions"
cp netlify/functions/sala.mjs "$TMP/netlify/functions/"

cat > "$TMP/netlify.toml" <<'TOML'
# Configuración para un despliegue manual: los archivos del sitio ya están
# en la raíz de esta carpeta, así que no hay nada que construir.

[functions]
  directory = "netlify/functions"
  node_bundler = "esbuild"

[[headers]]
  for = "/api/*"
  [headers.values]
    Cache-Control = "no-store"

[[headers]]
  for = "/*"
  [headers.values]
    X-Content-Type-Options = "nosniff"
    Referrer-Policy = "strict-origin-when-cross-origin"

[[redirects]]
  from = "/api/sala"
  to = "/.netlify/functions/sala"
  status = 200
  force = true
TOML

rm -f "$SALIDA"
( cd "$TMP" && zip -rq "$SALIDA" . -x ".*" )
echo "listo: $SALIDA ($(du -h "$SALIDA" | cut -f1))"
