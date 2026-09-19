# Sync híbrido (F4)

Catálogo y usuarios siguen el mismo modelo (D-023 / D-035):

```text
APK seed (assets)  →  copia local en el teléfono  ←  JSON estático remoto (opcional)
                              ↑
                         la app lee siempre de aquí
```

## Comportamiento

1. **Primera vez / sin cache:** se copia el seed del APK al almacenamiento local.  
2. **Con red y URL configurada:** `GET` del JSON remoto; si `version` remota **>** local, se reemplaza la copia.  
3. **Sin red o fallo:** se sigue con la última copia local (o seed). La consulta **no se bloquea**.  
4. **Login / arranque:** intenta sync de usuarios (best-effort).  
5. **Botón ⟳ / pull-to-refresh:** sync catálogo + usuarios.

## Configurar URLs

Al compilar o ejecutar:

```bash
flutter run -d <device> \
  --dart-define=DEVICE_ID_OVERRIDE=dev-device-alpha \
  --dart-define=CATALOGO_URL=http://10.0.2.2:8787/catalogo.json \
  --dart-define=USUARIOS_URL=http://10.0.2.2:8787/usuarios.json
```

| Define | Uso |
| --- | --- |
| `CATALOGO_URL` | JSON de infracciones |
| `USUARIOS_URL` | JSON de agentes / device_ids |

Sin defines: la app funciona solo con seed (como F1–F3).

### Emulador → Mac

`10.0.2.2` es el localhost de la máquina anfitriona vista desde el emulador Android.

### Teléfono físico en la misma Wi‑Fi

Usa la IP LAN de tu Mac, p. ej. `http://192.168.1.20:8787/catalogo.json`.

## Servidor local de prueba

En el repo:

```bash
./scripts/serve-remote.sh
# sirve hosting/ en :8787
```

Archivos:

- `hosting/catalogo.json` — **v2**, incluye infracción demo **D.01**
- `hosting/usuarios.json` — **v2**

## Producción

Sube los JSON a cualquier hosting estático (GitHub Pages, Cloudflare, S3, Firebase Hosting, etc.) y compila el APK con esas URLs HTTPS.

**No** mezcles usuarios y catálogo en el mismo archivo.  
El JSON de usuarios es sensible (cédulas/claves): URL poco adivinable; no lo indexes en un sitio público genérico si puedes evitarlo.

## Versionado

Sube el campo entero `version` cada vez que publiques un JSON nuevo. Si la remota no es mayor, la app no pisa la copia local.
