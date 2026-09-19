# Hosting samples (public app repo)

This folder holds **templates only** for the public portfolio repository.

| File | Purpose |
| --- | --- |
| `catalogo.ejemplo.json` | Schema sample for the infraction catalog |
| `usuarios.ejemplo.json` | Schema sample for agents (username + password) |

**Production JSON is NOT here.**

Production files live in a **private** GitHub repo that deploys to **Cloudflare Pages**:

```text
(private) codigos-transito-data
  ├── catalogo.json
  └── usuarios.json
        │
        ▼ git push
  Cloudflare Pages (HTTPS)
        │
        ▼ CATALOGO_URL / USUARIOS_URL baked into the APK
```

See `docs/sync.md` and `docs/data-hosting.md`.
