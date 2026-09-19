# Stack y arquitectura

> Decisiones cerradas en el contrato: **D-015 … D-021**, **D-023**.  
> Debate histórico de candidatos (Flutter vs Expo vs PWA, etc.) quedó resuelto el 2026-09-19.

## Resumen acordado

| Capa | Elección | Estado |
| --- | --- | --- |
| Plataforma | **Solo Android** | Decidido |
| iOS | **Fuera de alcance** (sin Apple Developer; no es objetivo) | Decidido |
| Framework | **Flutter** (Dart) | Decidido |
| Entregable | **APK** sideload (sin Play Store) | Decidido |
| Backend de app | Ninguno | Decidido |
| Catálogo | JSON híbrido (seed local + GET estático) | Decidido |
| Auth | Híbrido + device_id + multi-teléfono | **Decidido** |
| IA | No | Decidido |

## Por qué Flutter (si iOS no importa)

El promotor delegó el lenguaje. Con **solo Android** también valía **Kotlin nativo**. Se eligió **Flutter** porque:

1. Encaja muy bien con lista + búsqueda + offline + APK.
2. `flutter build apk` es un flujo claro para el piloto.
3. Buena velocidad de MVP y UI consistente sin pelearse con XML/Compose si no hace falta.
4. No se eligió “por multiplataforma”: iOS está explícitamente **fuera**. Si un día se reabre iOS, Flutter *podría* reutilizarse, pero **no es un compromiso actual**.

## Descartado (recordatorio)

| Opción | Por qué no |
| --- | --- |
| Expo / RN | Sin preferencia JS; Flutter cubre el caso |
| PWA | APK nativo basta; el piloto acepta cualquier instalación simple; iOS no se soporta |
| Kotlin-only | Alternativa legítima; Flutter ganó por decisión de co-diseño/DX |
| Apple / TestFlight / PWA-iOS | Sin presupuesto Apple Developer; iPhone no es objetivo |

## Piezas técnicas previstas (implementación)

| Pieza | Enfoque tentativo |
| --- | --- |
| UI | Pantallas Flutter (login, catálogo, detalle) |
| Catálogo seed | Asset JSON en el APK |
| Copia local | Almacenamiento en disco de la app tras primer arranque / sync |
| Sync | HTTP GET a URL de `catalogo.json` (+ `version`) |
| Auth | Leer `usuarios.json` (asset o asset por flavor) y validar en local |
| Búsqueda | Filtrado en memoria sobre el catálogo cargado (suficiente al tamaño típico); FTS solo si hace falta después |

El detalle de librerías exactas se fija al implementar (no bloquea el contrato).

## Distribución

Ver [`distribucion.md`](./distribucion.md).


## Auth

Ver [`auth.md`](./auth.md): usuarios.json híbrido + UUID de instalación; multi-device; **sin IP**; sin R1/R2 obligatorias.
