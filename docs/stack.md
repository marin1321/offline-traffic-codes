# Stack and architecture

> Closed in the contract: **D-015 … D-021**, **D-023**, **D-038**.

## Agreed summary

| Layer | Choice | Status |
| --- | --- | --- |
| Platform | **Android only** | Decided |
| iOS | **Out of scope** | Decided |
| Framework | **Flutter** (Dart) | Decided |
| Deliverable | **APK** sideload (no Play Store) | Decided |
| App backend | None | Decided |
| Catalog | Hybrid JSON (seed + remote) | Decided |
| Auth | Hybrid JSON + device_id + username | Decided |
| AI | No | Decided |
| Data hosting | Private GitHub → Cloudflare Pages | Decided |

## Why Flutter (even without iOS)

1. Strong fit for list + search + offline + APK.  
2. Clear `flutter build apk` path for the pilot.  
3. Fast MVP UI without fighting platform XML by default.  

## Rejected (reminder)

| Option | Why not |
| --- | --- |
| Expo / RN | No JS preference; Flutter covers the case |
| PWA | Native APK preferred; iOS unsupported |
| Kotlin-only | Valid Android-only path; Flutter chosen for DX |
| Apple / TestFlight | Explicitly out of scope |

## Runtime pieces

| Piece | Approach |
| --- | --- |
| UI | Flutter screens (login, catalog, detail, about) |
| Catalog seed | Asset JSON in the APK |
| Local copy | App documents JSON cache |
| Sync | HTTP GET + `version` compare |
| Auth | `usuarios.json` validation + installation UUID |
| Session | SharedPreferences; calendar-day expiry |

Distribution details: [`distribucion.md`](./distribucion.md).
