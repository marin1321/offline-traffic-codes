# Hosting samples (public app repo)

**Templates only** for the public portfolio repository.

| File | Purpose |
| --- | --- |
| `catalogo.ejemplo.json` | Infraction catalog schema sample |
| `usuarios.ejemplo.json` | Agents schema sample (username + password) |

**Production JSON is not stored here.**

Production files live in the **private** GitHub repo that deploys to **Cloudflare Pages**:

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

Public app: https://github.com/marin1321/offline-traffic-codes  
Private data: https://github.com/marin1321/codigos-transito-data  

Details: `docs/data-hosting.md`.
