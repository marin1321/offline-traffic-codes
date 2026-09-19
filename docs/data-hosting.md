# Data hosting (private repo → Cloudflare Pages)

Spanish ops notes for the **split** between portfolio code and sensitive/runtime data.

## Goal

| Repo | Visibility | Contents |
| --- | --- | --- |
| **This app repo** | Public (portfolio) | Flutter source, docs, demo seed only |
| **Data repo** | **Private** | Real `catalogo.json`, `usuarios.json` |
| **Cloudflare Pages** | Serves HTTPS | Deployed from the private repo |

## Private data repo layout

```text
codigos-transito-data/          # private on GitHub
  catalogo.json
  usuarios.json
  README.md                     # how to edit / bump version
```

### `usuarios.json` shape

```json
{
  "version": 1,
  "usuarios": [
    {
      "usuario": "oscar",
      "password": "…",
      "nombre": "Nombre visible",
      "activo": true,
      "device_ids": ["uuid-del-telefono"]
    }
  ]
}
```

Login is **username + password** (not cédula).  
Usernames are matched **case-insensitively**.

### Day-to-day edit flow

```bash
# on your PC
cd codigos-transito-data
# edit catalogo.json or usuarios.json
# bump "version"
git add .
git commit -m "Add C.40; enroll oscar device"
git push
# Cloudflare Pages auto-deploys → phones pick it up on next open/sync
```

## Cloudflare Pages

1. Cloudflare dashboard → **Workers & Pages** → Create project.  
2. Connect the **private** GitHub data repo.  
3. Build: static assets, output directory = repo root (or `/` if files are at root).  
4. After deploy, copy HTTPS URLs, e.g.:

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

- Pages gives **HTTPS + CDN**, not secrecy against someone who has the URL (the APK embeds it).  
- Private GitHub keeps secrets **out of your public portfolio**.  
- Still experimental auth: prefer strong-ish passwords; revoke with `activo: false`; enroll devices in release.  
- Do **not** commit production `usuarios.json` to the public app repo (see root `.gitignore`).

## Public app repo `hosting/`

Only **examples**:

- `catalogo.ejemplo.json`
- `usuarios.ejemplo.json`

See `hosting/README.md`.
