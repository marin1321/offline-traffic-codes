# Data hosting (private repo → Cloudflare Pages)

## Goal

| Repo | Visibility | Contents |
| --- | --- | --- |
| **App repo** [`offline-traffic-codes`](https://github.com/marin1321/offline-traffic-codes) | Public (portfolio) | Flutter source, English docs, demo seeds only |
| **Data repo** [`codigos-transito-data`](https://github.com/marin1321/codigos-transito-data) | **Private** | Real `catalogo.json`, `usuarios.json` |
| **Cloudflare Pages** | Serves HTTPS | Deployed from the private repo |

## Why this split

- Portfolio shows **engineering**, not agent passwords.  
- Cloudflare gives **HTTPS + CDN** without running a VPS.  
- Daily ops: edit JSON on your PC → `git push` → Pages publishes.

## Private data repo layout

```text
codigos-transito-data/          # private on GitHub
  public/
    catalogo.json               # served by Cloudflare (edit here)
    usuarios.json
    index.html
  src/index.js
  wrangler.toml
  README.md
```

### `usuarios.json` shape

```json
{
  "version": 1,
  "usuarios": [
    {
      "usuario": "oscar",
      "password": "…",
      "nombre": "Display name",
      "activo": true,
      "device_ids": ["phone-uuid"]
    }
  ]
}
```

Login is **username + password** (not a national ID). Usernames match **case-insensitively**.

### Day-to-day edit flow

```bash
cd codigos-transito-data
# edit catalogo.json or usuarios.json
# bump "version"
git add .
git commit -m "Add C.40; enroll oscar device"
git push
# Cloudflare Pages auto-deploys → phones refresh on next open/sync
```

## Cloudflare Pages setup (checklist)

1. Cloudflare dashboard → **Workers & Pages** → Create.  
2. Connect private GitHub repo `codigos-transito-data`.  
3. Build: static site; output directory = repository root.  
4. Copy HTTPS URLs, e.g.:

```text
https://codigos-transito-data.pages.dev/catalogo.json
https://codigos-transito-data.pages.dev/usuarios.json
```

5. Bake into the APK:

```bash
CATALOGO_URL='https://….pages.dev/catalogo.json' \
USUARIOS_URL='https://….pages.dev/usuarios.json' \
./scripts/build-piloto.sh
```

## Security honesty

- Pages provides **HTTPS + CDN**, not secrecy against someone who has the URL (the APK embeds it).  
- Private GitHub keeps secrets **out of the public portfolio**.  
- Still an experimental gate: prefer decent passwords; revoke with `activo: false`; enroll devices in release.  
- Do **not** commit production `usuarios.json` to the public app repo (see root `.gitignore`).

## Public app repo `hosting/`

Examples only:

- `catalogo.ejemplo.json`
- `usuarios.ejemplo.json`

See [`../hosting/README.md`](../hosting/README.md).
