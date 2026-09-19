#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT/scripts/env.sh"
cd "$ROOT/app"
flutter devices
DEV="$(flutter devices --machine 2>/dev/null | python3 -c "
import sys, json
ds = json.load(sys.stdin)
android = [d for d in ds if str(d.get('targetPlatform', '')).startswith('android')]
print(android[0]['id'] if android else '')
" || true)"
if [[ -z "${DEV}" ]]; then
  echo "No hay Android (emulador o teléfono)."
  echo "  ./scripts/start-emulator.sh"
  exit 1
fi
echo "Usando dispositivo: $DEV"
DEFINE_ARGS=()
if [[ "${USE_DEV_DEVICE:-1}" == "1" ]]; then
  DEFINE_ARGS+=(--dart-define=DEVICE_ID_OVERRIDE=dev-device-alpha)
  echo "DEVICE_ID_OVERRIDE=dev-device-alpha (USE_DEV_DEVICE=0 para desactivar)"
fi
# Optional F4 remote (start ./scripts/serve-remote.sh first)
if [[ "${USE_REMOTE:-0}" == "1" ]]; then
  PORT="${REMOTE_PORT:-8787}"
  # Emulator loopback to host; override REMOTE_HOST for physical device LAN IP
  HOST="${REMOTE_HOST:-10.0.2.2}"
  DEFINE_ARGS+=(--dart-define=CATALOGO_URL=http://$HOST:$PORT/catalogo.json)
  DEFINE_ARGS+=(--dart-define=USUARIOS_URL=http://$HOST:$PORT/usuarios.json)
  echo "Remote: http://$HOST:$PORT/ (USE_REMOTE=1)"
fi
flutter run -d "$DEV" "${DEFINE_ARGS[@]}"
