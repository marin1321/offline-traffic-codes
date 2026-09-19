# Autenticación

> Contrato: **D-019**, **D-034**, **D-035** — **Decidido**.  
> Nivel: pestillo experimental, no seguridad bancaria.

## Resumen

| Pieza | Acuerdo |
| --- | --- |
| Factores de login | **Usuario + contraseña + device_id** |
| IP | **No** |
| Usuarios | **JSON híbrido** (seed/cache local + remoto) |
| Enrolamiento | **Manual**: el agente manda el código del teléfono al promotor |
| Teléfonos por usuario | **Varios** permitidos (`device_ids[]`) |
| R1/R2 (TTL / sync obligatorio duro) | **No se exigen** — no importan al promotor |
| Rol | Solo agente |

## Login

Entra si y solo si:

1. Existe usuario con esa usuario y contraseña  
2. `activo === true`  
3. El `device_id` de **esta** instalación está en `device_ids`  

## Device ID

- UUID generado al primer arranque y guardado en el teléfono.  
- La UI debe poder **mostrar/copiar** ese código para WhatsApp.  
- No IMEI obligatorio. No IP.

## Varios teléfonos

Misma usuario/clave puede listar varios ids:

```json
"device_ids": ["uuid-telefono-laboral", "uuid-telefono-backup"]
```

- **Añadir** un teléfono: el promotor agrega el id a la lista.  
- **Quitar** un teléfono: borra solo ese id.  
- **Revocar persona:** `activo: false` o eliminar el usuario.

## Enrolamiento

```text
1. Promotor crea usuario (usuario, clave, activo: true)
2. Agente instala APK genérico → ve "Código de este teléfono"
3. Se lo envía al promotor
4. Promotor añade el id a device_ids y publica usuarios.json
5. Agente, con red, sincroniza y hace login
```

## Híbrido `usuarios.json`

1. Copia local (seed o última bajada).  
2. Con red: GET remoto si `version` es mayor → reemplaza local.  
3. Sin red: login con la copia local.  
4. URL **distinta** a la del catálogo de infracciones.

### Revocación offline (límite aceptado)

Sin R1/R2 obligatorias: si alguien quedó revocado en el remoto pero **nunca** vuelve a sincronizar, puede seguir con la copia vieja. Se acepta. Con red, conviene refrescar usuarios en arranque o login **sin** TTL ni dramatizar.

## Forma del archivo

```json
{
  "version": 3,
  "usuarios": [
    {
      "usuario": "1234567890",
      "password": "clave-simple",
      "nombre": "Agente piloto",
      "activo": true,
      "device_ids": [
        "550e8400-e29b-41d4-a716-446655440000",
        "7c9e6679-7425-40de-944b-e07fc1f90ae7"
      ]
    }
  ]
}
```

## APK

Un **APK genérico** para todos; la verdad de quién entra está en el JSON de usuarios (remoto + cache).


## Caducidad de sesión (D-036)

- Tras login OK, la sesión dura el resto del **día calendario** en la zona horaria del teléfono.
- **Mismo día:** cerrar y abrir la app sigue dentro (si activo + device ok).
- **Día siguiente (desde 00:00 locales):** al abrir pide usuario y contraseña otra vez.
- También se cierra si: logout manual, revocación (`activo: false`), o device ya no autorizado.
- No hay timer mientras la app está abierta; se comprueba al abrir/restaurar sesión.
