# Entrega al piloto (F5)

Guía para instalar **Códigos de Tránsito** en el Android del agente piloto (padre) y dejarlo operativo.

## Qué entregas

| Archivo | Descripción |
| --- | --- |
| `dist/codigos-transito-piloto.apk` | APK de entrega (versión 1.0.0) |
| Este documento | Pasos de instalación y enrolamiento |

## Mensaje listo para WhatsApp (al piloto)

Puedes copiar y pegar:

```text
Hola, te paso la app Códigos de Tránsito (consulta de infracciones offline).

1) Descarga e instala el APK que te envío.
2) Si Android avisa de "origen desconocido", permite instalar desde Archivos/WhatsApp.
3) Abre la app. En la pantalla de ingreso verás un "código de este teléfono".
4) Toca copiar y envíamelo por este chat.
5) Cuando te diga que ya quedó, entra con la usuario y contraseña que te pasé.
6) Prueba buscar "resonador" o "c28". Debe aparecer C.28.
7) Puedes usarla sin internet (modo avión) para consultar.

Es una herramienta orientativa, no reemplaza la norma oficial.
```

## Checklist del administrador (tú)

### Antes de enviar el APK

- [ ] APK generado con `./scripts/build-piloto.sh` (o el build release acordado).
- [ ] Decides usuario y contraseña del piloto (anótalas en un sitio privado, **no** en el repo público).
- [ ] Si usarás sync remoto: JSON de usuarios y catálogo publicados, y el APK compilado con esas `CATALOGO_URL` / `USUARIOS_URL`.

### Enrolamiento

1. El piloto instala y te manda el **código del teléfono**.
2. Agregas ese id en `device_ids` de su usuario:
   - **Con remoto (recomendado):** editas `usuarios.json` en el hosting, subes `version`, el piloto abre la app con red (o toca sincronizar tras login de un admin… o reintenta login).
   - **Solo seed en APK:** editas `app/assets/data/usuarios_seed.json`, subes `version`, **generas otro APK** y se lo reenvías.
3. Confirmas por WhatsApp: “ya quedó, prueba entrar”.

### Ejemplo de usuario (plantilla)

```json
{
  "usuario": "nombre_usuario",
  "password": "clave-que-acordaron",
  "nombre": "Nombre del agente",
  "activo": true,
  "device_ids": [
    "uuid-que-te-envio-por-whatsapp"
  ]
}
```

Varios teléfonos del mismo agente: varios ids en `device_ids`.

## Instalación en el teléfono (detalle)

1. Abrir el APK desde WhatsApp / Files / Drive.  
2. Si pide permiso: **Ajustes → Apps → [origen] → Instalar apps desconocidas → Permitir**.  
3. Instalar → Abrir.  
4. No hace falta Play Store.

## Prueba de humo (D-024) — contigo o con el piloto

- [ ] Login con cédula + clave + device enrolado.  
- [ ] Listado de infracciones visible.  
- [ ] Filtro por categoría (A/B/C…).  
- [ ] Buscar `c28` → **C.28**.  
- [ ] Buscar `resonador` → **C.28**.  
- [ ] Abrir detalle de una infracción.  
- [ ] **Modo avión:** lista, filtro, búsqueda y detalle siguen OK.  
- [ ] (Si hay remoto) Con red, sync actualiza catálogo; sin red no rompe.  
- [ ] Cerrar sesión y volver a entrar.

## Credenciales de desarrollo (solo pruebas, no piloto real)

| Usuario | Clave | Device de demo |
| --- | --- | --- |
| `oscar` | `piloto123` | `dev-device-alpha` / `beta` (builds con `DEVICE_ID_OVERRIDE`) |

**No uses estas claves en el teléfono del padre.** Crea las suyas.

## Build de entrega

```bash
./scripts/build-piloto.sh
# → dist/codigos-transito-piloto.apk
```

Con remoto de producción:

```bash
CATALOGO_URL='https://tu-dominio/catalogo.json' \
USUARIOS_URL='https://tu-dominio/usuarios.json' \
./scripts/build-piloto.sh
```

## Límites conscientes (recordatorio)

- Auth es un pestillo experimental, no seguridad bancaria.  
- Sin sync, un revocado offline puede seguir hasta que sincronice.  
- El catálogo seed no es el listado oficial completo hasta que lo completes y publiques.
