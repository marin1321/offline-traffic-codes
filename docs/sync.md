# Hybrid sync (F4)

Catalog and users follow the same model (D-023 / D-035):

```text
APK seed (assets)  →  local copy on phone  ←  optional remote static JSON
                              ↑
                     app always reads from here
```

## Behavior

1. **First run / empty cache:** copy APK seed to local storage.  
2. **With network + URL:** `GET` remote JSON; if remote `version` **>** local, replace.  
3. **No network or failure:** keep last local copy (or seed). Consultation is **not** blocked.  
4. **Login / startup:** best-effort users sync.  
5. **Sync button ⟳ / pull-to-refresh:** catalog + users.  
6. **Newer seed in a new APK** (higher `version`) replaces a stale local cache.

There is **no polling loop** while the app stays open—only open/login/manual triggers.

## Configure URLs

```bash
flutter run -d <device> \
  --dart-define=CATALOGO_URL=https://your.pages.dev/catalogo.json \
  --dart-define=USUARIOS_URL=https://your.pages.dev/usuarios.json
```

| Define | Use |
| --- | --- |
| `CATALOGO_URL` | Infractions JSON |
| `USUARIOS_URL` | Agents JSON |

Empty defines → seed-only (like early phases).

### Emulator → host machine HTTP (local test)

`10.0.2.2` is the host loopback from an Android emulator.

```bash
./scripts/serve-remote.sh   # if using local samples
USE_REMOTE=1 ./scripts/run-app.sh
```

## Production hosting

Private GitHub data repo → **Cloudflare Pages**. See [`data-hosting.md`](./data-hosting.md).

## Versioning

Bump the integer `version` whenever you publish a real content change. If remote is not greater, the app does not overwrite local.
