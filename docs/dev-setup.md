# Development setup

How to test on an **emulator** and/or **physical phone** while shipping phases.

## macOS environment (example)

```bash
export PATH="/opt/homebrew/bin:$PATH"
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
```

```bash
flutter doctor
adb devices
flutter devices
```

Project helpers:

```bash
./scripts/start-emulator.sh
./scripts/run-app.sh
```

---

## Option A — Emulator

```bash
flutter emulators
./scripts/start-emulator.sh    # default AVD Codigos_API_35
cd app && flutter run
```

Hot reload: `r` · hot restart: `R` · quit: `q`.

---

## Option B — Physical phone

1. Enable **Developer options** (tap Build number 7 times).  
2. Enable **USB debugging**.  
3. Plug USB → accept the trust prompt.  
4. `adb devices` should show `device`.  
5. `cd app && flutter run`.

### APK-only install

```bash
adb install -r dist/codigos-transito-piloto.apk
```

Or share the file and open it on the phone (unknown sources).

---

## Both at once

```bash
flutter devices
flutter run -d <deviceId>
```

---

## Common issues

| Symptom | Try |
| --- | --- |
| Flutter cannot find Android SDK | `flutter config --android-sdk …` |
| Emulator fails on Apple Silicon | Use **arm64-v8a** system images |
| Empty `adb devices` | Data cable, USB debugging, trust dialog |
| Login “device not authorized” (release) | Enroll the phone code in `usuarios.json` |
| Debug login after wipe | Debug builds relax device binding; still use valid username/password |

---

## Phase verification

Each phase should be demonstrable with `flutter run` on emulator or phone before closing it (plus criteria in `fases.md`).
