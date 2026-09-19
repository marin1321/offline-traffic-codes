# Seed assets (shipped inside the APK)

## `catalogo_seed.json`

Demo / bootstrap catalog. Schema:

```json
{
  "version": 2,
  "infracciones": [
    {
      "codigo": "C.28",
      "categoria": "C",
      "categoria_titulo": "…",
      "descripcion": "…",
      "referencias": ["Art. 131", "Res. 20"]
    }
  ]
}
```

## `usuarios_seed.json`

Demo accounts for local development. **Not production.**

```json
{
  "version": 5,
  "usuarios": [
    {
      "usuario": "oscar",
      "password": "piloto123",
      "nombre": "Agente piloto (dev)",
      "activo": true,
      "device_ids": ["…"]
    }
  ]
}
```

| Field | Meaning |
| --- | --- |
| `usuario` | Login name (`admin`, `oscar`, …) — **not** a national ID |
| `password` | Plain password (experimental gate) |
| `nombre` | Display name |
| `activo` | `false` = revoked |
| `device_ids` | Allowed installation ids (strict in **release**) |

### Dev logins

| usuario | password |
| --- | --- |
| `admin` | `admin123` |
| `oscar` | `piloto123` |

Production users live only in the **private** data repo → Cloudflare Pages.
