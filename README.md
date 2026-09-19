# Códigos de Tránsito

**Offline-first Android app** for traffic officers in Colombia: look up **infraction codes** by category or search (code / keywords), even without network.

> Portfolio / open-source **application** repository.  
> **No production credentials or personal IDs** are stored here.  
> Live catalog & user JSON are served from a **private** data pipeline (GitHub private repo → Cloudflare Pages).

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Platform](https://img.shields.io/badge/platform-Android-3DDC84?logo=android)](https://www.android.com/)
[![License](https://img.shields.io/badge/license-Private%20%2F%20TBD-lightgrey)](#)

---

## Why this project

Field work often happens with **poor or no connectivity**. Officers still need to map a situation to the right **infraction code** for a *comparendo*.

This app is a focused **consultation tool**:

- Browse infractions by category (A, B, C, …)
- Search by code (`C.28`, `c28`) or text (`resonador`, `cinturón`)
- Open detail: description + related **articles / resolutions**
- Works **offline** from a local copy of the catalog
- Optional **HTTPS sync** when online (versioned static JSON)
- Simple **username + password** gate, bound to **device id** (release builds)
- Session valid for the **local calendar day** only

Built as an **experimental** product (sideloaded APK, not Play Store).

---

## Architecture (high level)

```text
┌─────────────────────────────┐
│  Public GitHub (this repo)  │  ← portfolio: Flutter app + docs
│  app/ · docs/ · CONTRATO.md │
└──────────────┬──────────────┘
               │ build APK with URL defines
               ▼
┌─────────────────────────────┐
│  Private data repo          │  ← catalogo.json + usuarios.json
│  git push                   │
└──────────────┬──────────────┘
               │
               ▼
┌─────────────────────────────┐
│  Cloudflare Pages (HTTPS)   │  ← static JSON CDN
└──────────────┬──────────────┘
               │ GET on open / login / manual sync
               ▼
┌─────────────────────────────┐
│  Android device             │  ← seed + local cache, offline-first
└─────────────────────────────┘
```

| Layer | Public? | Contents |
| --- | --- | --- |
| This repo | Yes (portfolio) | App source, design contract, docs |
| Private data repo | No | Real `catalogo.json`, `usuarios.json` |
| Cloudflare Pages | URLs not advertised | Serves those JSON files over HTTPS |

---

## Tech stack

- **Flutter** (Dart) — Android only for v1  
- **Local JSON cache** + optional remote sync (`version` field)  
- **SharedPreferences** — session + installation device id  
- No backend API, no App Store / Play Store distribution in v1  

Design decisions are tracked in Spanish in [`CONTRATO.md`](./CONTRATO.md) (project contract).

---

## Features

- Login: **username + password** (+ device enrollment in release)
- Catalog list with category chips and full-text / code search
- Detail sheet with description and `referencias` (e.g. `Art. 131`, `Res. 20`)
- Pull-to-refresh / sync button when remote URLs are configured
- Legal disclaimer (informational tool, not legal advice)

---

## Quick start (development)

### Requirements

- Flutter stable SDK  
- Android SDK  
- Optional: Android emulator or USB device  

Helper scripts (macOS paths may need adjusting):

```bash
./scripts/start-emulator.sh   # if using the project AVD
./scripts/run-app.sh          # flutter run on first Android device
```

Or manually:

```bash
cd app
flutter pub get
flutter test
flutter run
```

### Demo accounts (seed only — not production)

| Username | Password | Notes |
| --- | --- | --- |
| `admin` | `admin123` | Dev admin |
| `oscar` | `piloto123` | Dev pilot agent |
| `revocado` | `revocado` | Inactive user |
| `sindevice` | `sindevice` | Active but no devices (release blocks) |

> **Debug builds** relax device binding so local testing is painless.  
> **Release / pilot APKs** require the phone’s device id in `device_ids`.

---

## Release APK

```bash
# Offline-only seed (no remote URLs)
./scripts/build-piloto.sh

# With Cloudflare Pages (or any HTTPS static host)
CATALOGO_URL='https://YOUR_PAGES.dev/catalogo.json' \
USUARIOS_URL='https://YOUR_PAGES.dev/usuarios.json' \
./scripts/build-piloto.sh
```

Output: `dist/codigos-transito-piloto.apk` (gitignored).

Pilot install / enrollment notes: [`docs/entrega-piloto.md`](./docs/entrega-piloto.md) (Spanish).

---

## Documentation

| Doc | Description |
| --- | --- |
| [`CONTRATO.md`](./CONTRATO.md) | Living product/architecture decisions |
| [`docs/fases.md`](./docs/fases.md) | Delivery phases F0–F5 |
| [`docs/sync.md`](./docs/sync.md) | Hybrid offline/online JSON sync |
| [`docs/data-hosting.md`](./docs/data-hosting.md) | Private repo + Cloudflare Pages |
| [`docs/auth.md`](./docs/auth.md) | Auth & device binding |
| [`docs/dev-setup.md`](./docs/dev-setup.md) | Emulator / device setup |
| [`hosting/README.md`](./hosting/README.md) | Public **examples only** (no secrets) |

---

## What is intentionally NOT in this repo

- Production passwords or real agent accounts  
- Real national ID numbers  
- Signed release keystores  
- Built APKs (`dist/`)  
- Local `.env` / machine secrets  

Sample shapes only: `hosting/*.ejemplo.json` and in-app **demo seed** under `app/assets/data/`.

---

## Roadmap / status

- [x] Offline catalog + search  
- [x] Auth (username / password / device)  
- [x] Daily session expiry  
- [x] Hybrid sync design  
- [ ] Private data repo + Cloudflare Pages (ops)  
- [ ] Full official catalog content (content work)  

---

## Author

Built as a practical Flutter case study: offline-first mobile UX, simple ops with static hosting, and a clear split between **public portfolio code** and **private operational data**.

---

## License

All rights reserved unless otherwise stated. Contact the author before reuse in production or commercial settings.
