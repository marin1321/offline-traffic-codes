# Distribución e instalación

> Contrato: **D-015**, **D-020**, **D-033**.  
> **Solo Android. Solo APK. Sin tiendas. Sin iOS.**

## Android (único canal)

| Paso | Qué pasa |
| --- | --- |
| 1 | Se genera el **`.apk`** con Flutter (`flutter build apk`). |
| 2 | Se envía al agente (WhatsApp, Drive, cable…). |
| 3 | En el teléfono se permite instalar apps de orígenes desconocidos. |
| 4 | Se abre el APK → queda el icono instalado. |

El piloto (padre) no exige un método concreto de instalación; **APK** es el estándar del proyecto.

## iOS

**Fuera de alcance.** No hay cuenta Apple Developer ni soporte a iPhone. Compañeros con iPhone no son usuarios objetivo.

Si en el futuro se quisiera iOS, hay que **reabrir D-015 y D-020** en el contrato (no improvisar).

## Personalización por persona (Android) — si se confirma auth híbrida

1. Mismo **APK genérico** para todos.  
2. Alta: cédula + clave en `usuarios.json` remoto + **device_id** que el agente te envía.  
3. Baja/revocación: `activo: false` o borrar; el teléfono lo nota al sincronizar (y/o al vencer gracia offline).  

Detalle: [`auth.md`](./auth.md).

## Actualizaciones

| Cambio | ¿Nuevo APK? |
| --- | --- |
| Nuevas infracciones (JSON remoto) | **No** |
| Alta/baja usuario o cambio de device | **No** (JSON usuarios remoto) |
| Seed / lógica de la app | **Sí** |
