#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
# shellcheck disable=SC1091
source "$ROOT/scripts/env.sh"
AVD_NAME="${1:-Codigos_API_35}"
if adb devices | grep -q emulator; then
  echo "Ya hay un emulador en adb."
  adb devices -l
  exit 0
fi
echo "Arrancando $AVD_NAME..."
nohup emulator -avd "$AVD_NAME" -netdelay none -netspeed full >/tmp/emulator-codigos.log 2>&1 &
adb wait-for-device
for _ in $(seq 1 60); do
  boot="$(adb shell getprop sys.boot_completed 2>/dev/null | tr -d '\r')"
  [[ "$boot" == "1" ]] && break
  sleep 3
done
adb devices -l
flutter devices
