#!/usr/bin/env bash
# Sirve hosting/ para probar sync F4 (emulador: http://10.0.2.2:8787/...)
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PORT="${1:-8787}"
cd "$ROOT/hosting"
echo "Sirviendo $ROOT/hosting en http://0.0.0.0:$PORT/"
echo "Emulador Android:"
echo "  CATALOGO_URL=http://10.0.2.2:$PORT/catalogo.json"
echo "  USUARIOS_URL=http://10.0.2.2:$PORT/usuarios.json"
python3 -m http.server "$PORT" --bind 0.0.0.0
