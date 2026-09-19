# Fases de desarrollo

> Contrato **cerrado** (incl. auth D-019/D-034/D-035).  
> Orden (D-013): contrato → **estas fases** → código.  
> No se salta una fase sin su **definición de hecho**.

## Visión

APK Android (Flutter) para el piloto: login cédula+clave+device (multi-teléfono), catálogo y usuarios híbridos, consulta offline.

```text
F0 Fundaciones → F1 Catálogo seed → F2 Auth+device → F3 Consulta UX
  → F4 Sync catálogo + usuarios → F5 APK piloto → contenido (paralelo)
```

---

## Fase 0 — Fundaciones (Flutter)

| | |
| --- | --- |
| **Objetivo** | Proyecto Flutter Android + primer APK de prueba. |
| **Incluye** | Scaffold; assets; `.gitignore`; enlace a docs/contrato; UI base; disclaimer stub. |
| **Definición de hecho** | `flutter run` en Android; `flutter build apk` genera APK instalable. |
| **Resultado** | **Cumplida.** APK: `dist/codigos-transito-f0.apk` (también `app/build/app/outputs/flutter-apk/app-release.apk`). Test widget OK. |

---

## Fase 1 — Catálogo seed

| | |
| --- | --- |
| **Objetivo** | JSON de infracciones cargable. |
| **Incluye** | Schema (`codigo`, `categoria`, `categoria_titulo`, `descripcion`, `version` del archivo); seed ejemplo A/B/C; loader; nota de cómo editar. |
| **Definición de hecho** | La app carga el seed y puede enumerar códigos. |
| **Resultado** | **Cumplida.** 28 códigos en seed; lista A/B/C en emulador; tests OK; APK `dist/codigos-transito-f1.apk`. |

---

## Fase 2 — Auth + device_id

| | |
| --- | --- |
| **Objetivo** | Login cédula + contraseña + device; multi-device en datos. |
| **Incluye** | UUID de instalación persistente; UI para **ver/copiar** el código del teléfono; modelo/loader de usuarios (seed/cache); validación `activo` + pertenencia a `device_ids`; sesión local simple. |
| **No incluye** | Sync remoto (F4); IP; R1/R2 TTL. |
| **Definición de hecho** | Sin device en lista → no entra; con device autorizado → entra; segundo device_id en el JSON del mismo usuario también puede entrar (probar con dos ids de prueba); modo avión OK con cache local ya autorizada. |
| **Resultado** | **Cumplida.** Tests auth OK; login en emulador → catálogo; logout; APK `dist/codigos-transito-f2.apk`. |

---

## Fase 3 — UX de consulta

| | |
| --- | --- |
| **Objetivo** | Encontrar el código de infracción. |
| **Incluye** | Lista; filtro por categoría; búsqueda por código y texto; detalle; flujo post-login. |
| **Definición de hecho** | `c28` / “resonador” → C.28; filtro; detalle; modo avión con catálogo local. |
| **Resultado** | **Cumplida.** CatalogoSearch + UI chips/buscador; tests; APK `dist/codigos-transito-f3.apk`. |

---

## Fase 4 — Sync híbrido (catálogo + usuarios)

| | |
| --- | --- |
| **Objetivo** | Actualizar infracciones y permisos sin nuevo APK. |
| **Incluye** | GET catálogo (D-023); GET usuarios (D-035); `version`; fallback local; refresh simple de usuarios con red en arranque o login (**sin** TTL R2 ni bloqueo agresivo); documentar las dos URLs. |
| **Definición de hecho** | Catálogo remoto más nuevo se refleja offline-next; usuario/device actualizado en remoto se refleja tras sync; sin red no se rompe la consulta ni un login ya cacheado. |
| **Resultado** | **Cumplida.** Cache local + GET remoto por version; botón sync; hosting de prueba; tests; emulador mostró v2 / 29 códigos (D.01). APK `dist/codigos-transito-f4.apk`. |

---

## Fase 5 — Pulido y entrega al piloto

| | |
| --- | --- |
| **Objetivo** | APK del padre en uso real experimental. |
| **Incluye** | Release APK; icono/nombre/disclaimer; JSON reales (usuario piloto + su device_id, catálogo lo que haya); enrolamiento real por WhatsApp; instrucciones breves; humo D-024. |
| **Definición de hecho** | Padre instalado, enrolado, busca en avión, una sync de catálogo con red verificada. |
| **Resultado** | **Software de entrega listo.** APK `dist/codigos-transito-piloto.apk` (1.0.0); guía `docs/entrega-piloto.md`; pantalla Acerca de; disclaimer y ayuda de enrolamiento. El enrolamiento físico del padre queda como paso operativo (él envía device_id). |

---

## Paralelo — Contenido

El promotor llena el JSON de infracciones con calma; publica versiones nuevas post-F4.

---

## Dependencias

```text
F0 → F1 → F2 → F3 → F4 → F5
```

## Fuera de v1

iOS, tiendas, backend de escritura, auth por IP, R1/R2 obligatorias, IA, multi-rol.

## Estado

| Fase | Estado |
| --- | --- |
| **F0** | **Hecha** — scaffold Flutter, APK |
| **F1** | **Hecha** — seed JSON, listado |
| **F2** | **Hecha** — login + device_id |
| **F3** | **Hecha** — búsqueda + filtros |
| **F4** | **Hecha** — sync híbrido |
| **F5** | **Hecha** (2026-09-19) — entrega piloto v1.0.0 |
| Contrato / auth | Cerrados |

**Plan v1 completo (F0–F5).** Contenido del catálogo y enrolamiento real del padre: operación continua.
