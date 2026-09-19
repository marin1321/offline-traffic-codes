#!/usr/bin/env bash
# Build release APK de entrega (F5). Sin DEVICE_ID_OVERRIDE (device real).
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT/scripts/env.sh"
cd "$ROOT/app"

echo "Building release APK (piloto)…"
flutter pub get
flutter test

BUILD_CMD=(flutter build apk --release)
if [[ -n "${CATALOGO_URL:-}" ]]; then
  BUILD_CMD+=(--dart-define="CATALOGO_URL=$CATALOGO_URL")
  echo "CATALOGO_URL=$CATALOGO_URL"
fi
if [[ -n "${USUARIOS_URL:-}" ]]; then
  BUILD_CMD+=(--dart-define="USUARIOS_URL=$USUARIOS_URL")
  echo "USUARIOS_URL=$USUARIOS_URL"
fi

"${BUILD_CMD[@]}"

mkdir -p "$ROOT/dist"
OUT="$ROOT/dist/codigos-transito-piloto.apk"
cp -f build/app/outputs/flutter-apk/app-release.apk "$OUT"
ls -lh "$OUT"
echo "Listo: $OUT"
echo "Siguiente: docs/entrega-piloto.md"
