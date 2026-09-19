# Entorno de desarrollo y pruebas

Cómo probar la app en **emulador** y/o **teléfono físico** mientras avanzamos las fases.

## Requisitos en la Mac

```bash
export PATH="/opt/homebrew/bin:$PATH"
export ANDROID_HOME=/opt/homebrew/share/android-commandlinetools
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export PATH="$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
```

(Puedes pegar eso en `~/.zshrc` / `~/.bash_profile` para no repetirlo.)

Comprobar:

```bash
flutter doctor
adb devices
flutter devices
```

---

## Opción A — Emulador (en la Mac)

### Primera vez (ya automatizado en F0+ si corrimos el setup)

1. Paquetes SDK: `emulator` + system image `android-35;google_apis;arm64-v8a` (Mac Apple Silicon).
2. AVD llamado p. ej. `Codigos_API_35`.

### Arrancar el emulador

```bash
flutter emulators
flutter emulators --launch Codigos_API_35
# o:
emulator -avd Codigos_API_35
```

Espera a que termine de bootear (pantalla de Android estable). Luego:

```bash
cd app
flutter devices          # debe listar el emulador
flutter run
```

Hot reload: con la app corriendo, guarda un archivo o pulsa `r` en la terminal; `R` hot restart; `q` salir.

### Instalar el APK a mano en el emulador

```bash
adb install -r dist/codigos-transito-f0.apk
# o el release de app/build/...
```

---

## Opción B — Teléfono físico (recomendado para “se siente real”)

### En el Android

1. **Ajustes → Acerca del teléfono** → toca **Número de compilación** 7 veces (activa *Opciones de desarrollador*).
2. **Ajustes → Sistema → Opciones de desarrollador**:
   - Activa **Depuración USB**.
   - (Opcional) **Instalar vía USB** / desactiva optimizaciones que bloqueen installs.
3. Conecta el cable USB a la Mac.
4. En el teléfono acepta el diálogo **“¿Permitir depuración USB?”** (marca “siempre” si quieres).

### En la Mac

```bash
adb devices
# Debe salir algo como:
# ABC123XYZ    device
```

Si sale `unauthorized`, revisa el diálogo en el teléfono.  
Si no sale nada: prueba otro cable (algunos solo cargan), otro puerto, o en el teléfono modo **Transferencia de archivos (MTP)**.

Luego:

```bash
cd app
flutter devices
flutter run
```

### Sin cable (ADB por Wi‑Fi, Android 11+)

En opciones de desarrollador: **Depuración sin cable** / Wireless debugging — emparejar con código. O clásico:

```bash
adb tcpip 5555
adb connect IP_DEL_TELEFONO:5555
```

(El teléfono y la Mac en la misma Wi‑Fi.)

### Solo instalar APK (sin `flutter run`)

```bash
adb install -r dist/codigos-transito-f0.apk
```

O copia el APK al teléfono y ábrelo (orígenes desconocidos), como en `docs/distribucion.md`.

---

## Ambas a la vez

Puedes tener emulador **y** teléfono conectados:

```bash
flutter devices
flutter run -d <deviceId>    # elige cuál
```

Útil: UI rápida en emulador; humo “de verdad” (instalación, rendimiento, teclado) en el del piloto/tuyo.

---

## Comandos del día a día

| Acción | Comando |
| --- | --- |
| Ver dispositivos | `flutter devices` / `adb devices` |
| Correr app | `cd app && flutter run` |
| Tests | `cd app && flutter test` |
| APK release | `cd app && flutter build apk` |
| Logs del teléfono | `adb logcat` (o `flutter logs`) |
| Reiniciar adb | `adb kill-server && adb start-server` |

---

## Problemas frecuentes

| Síntoma | Qué probar |
| --- | --- |
| `flutter` no encuentra Android SDK | `flutter config --android-sdk /opt/homebrew/share/android-commandlinetools` |
| Emulador no arranca en Apple Silicon | Usar imagen **arm64-v8a**, no x86_64 |
| `adb devices` vacío con cable | Cable de datos, depuración USB, confiar en el Mac |
| Install bloqueado en el teléfono | Orígenes desconocidos / “Instalar apps desconocidas” para Files/Chrome |
| Gradle lento la 1ª vez | Normal; siguientes builds son más rápidos |

---

## Relación con las fases

Cada fase debería poder demostrarse con `flutter run` en emulador o teléfono antes de darla por cerrada (además de los criterios de `docs/fases.md`).
