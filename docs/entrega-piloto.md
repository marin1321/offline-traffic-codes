# Pilot delivery (F5)

How to install **Códigos de Tránsito** on the pilot officer’s Android phone.

## What you deliver

| File | Description |
| --- | --- |
| `dist/codigos-transito-piloto.apk` | Release APK |
| This document | Install + enrollment steps |

## WhatsApp message (to the pilot)

```text
Hi — here is the Códigos de Tránsito app (offline infraction lookup).

1) Download and install the APK I sent.
2) If Android warns about unknown sources, allow install from Files/WhatsApp.
3) Open the app. On the login screen you will see a "code for this phone".
4) Tap copy and send it to me in this chat.
5) When I confirm it is registered, sign in with the username and password I gave you.
6) Try searching "resonador" or "c28". You should see C.28.
7) You can use it without internet (airplane mode) for lookup.

This is an orientation tool; it does not replace the official statute.
```

## Promoter checklist

### Before sending the APK

- [ ] APK built with `./scripts/build-piloto.sh` (and production URLs if using Pages).  
- [ ] Pilot **username + password** chosen (store privately—not in the public repo).  
- [ ] If using remote sync: `catalogo.json` / `usuarios.json` published; APK baked with those URLs.

### Enrollment

1. Pilot installs and sends the **phone code**.  
2. You add that id under `device_ids` for their user:
   - **Remote (recommended):** edit private `usuarios.json`, bump `version`, push → Pages.  
   - **Seed-only:** edit APK seed, bump version, **rebuild APK**, resend.  
3. Confirm: “you’re set—try logging in.”

### User template

```json
{
  "usuario": "agent_username",
  "password": "agreed-password",
  "nombre": "Agent display name",
  "activo": true,
  "device_ids": ["uuid-from-whatsapp"]
}
```

## Install details on the phone

1. Open the APK from WhatsApp / Files / Drive.  
2. If needed: **Settings → Apps → [source] → Install unknown apps → Allow**.  
3. Install → Open.  
4. No Play Store required.

## Smoke test (D-024)

- [ ] Login with username + password + enrolled device (release).  
- [ ] Infraction list visible.  
- [ ] Category filter.  
- [ ] Search `c28` → **C.28**.  
- [ ] Search `resonador` → **C.28**.  
- [ ] Open detail (description + referencias if any).  
- [ ] **Airplane mode** still works for catalog.  
- [ ] (If remote) Online sync updates catalog; offline does not break.  
- [ ] Logout and login again.  
- [ ] Next calendar day asks for login again.

## Dev-only accounts (not the real pilot)

| Username | Password |
| --- | --- |
| `admin` | `admin123` |
| `oscar` | `piloto123` |

**Do not use these on the father’s phone.** Create real credentials.

## Build

```bash
./scripts/build-piloto.sh

CATALOGO_URL='https://….pages.dev/catalogo.json' \
USUARIOS_URL='https://….pages.dev/usuarios.json' \
./scripts/build-piloto.sh
```

## Conscious limits

- Auth is an experimental gate, not bank security.  
- Without sync, a revoked offline user may keep an old copy until they sync.  
- Seed catalog is not the full official list until you complete and publish it.
