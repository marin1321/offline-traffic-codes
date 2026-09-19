# Contrato del proyecto

> Documento vivo. Aquí registramos **qué** decidimos, **por qué**, y **qué queda pendiente**.
> Nada se da por hecho hasta que aparezca en este archivo con estado **Decidido**.
> Lo construimos entre los dos: cada decisión se propone, se discute y se cierra aquí antes de implementarla.

**Última actualización:** 2026-09-19  
**Estado general:** **v1 software completa (F0–F5).** Sesión diaria (D-036). Contenido/enrolamiento en operación.

---

## 1. Cómo usamos este contrato

| Regla | Descripción |
| --- | --- |
| Fuente de verdad | Si hay duda entre conversación y este archivo, manda este archivo. |
| Decisiones | Toda decisión de producto, arquitectura, stack o proceso se anota aquí. |
| Estados | `Propuesto` → `En discusión` → `Decidido` → `Revisar` (si hay que reabrir). |
| Cambios | No se borra historia: se marca la decisión anterior y se añade la nueva con fecha. |
| Implementación | Solo se implementa lo que esté **Decidido**. Lo demás se planifica, no se construye. |
| Fases | Las fases de desarrollo se definen **después** de cerrar el contrato base (secciones 2–7). |

### Formato de cada decisión

```
### D-XXX — Título corto
- **Estado:** Propuesto | En discusión | Decidido | Revisar
- **Fecha:** YYYY-MM-DD
- **Decisión:** qué se eligió (o se propone)
- **Motivo:** por qué
- **Alternativas descartadas:** (si aplica)
- **Implicaciones:** qué habilita o bloquea
```

---

## 2. Visión y problema

### D-001 — Nombre de trabajo del proyecto
- **Estado:** Propuesto
- **Fecha:** 2026-09-19
- **Decisión:** Nombre de trabajo: **Códigos de Tránsito** (carpeta `Codigos_Transito`). Nombre comercial / final pendiente.
- **Motivo:** Anclar el repositorio mientras definimos marca.
- **Implicaciones:** Puede renombrarse sin costo hasta que exista marca pública.

### D-002 — Problema que resolvemos
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** En el momento de levantar o revisar un **comparendo**, el **agente de tránsito** necesita saber **qué código de infracción aplica** y **qué significa**, de forma rápida y clara — a menudo en campo **sin internet confiable**.
- **Motivo:** Uso operativo real del rol primario.
- **Implicaciones:** UX orientada a “encuentro el código y lo entiendo”, no a trámites ni estudio académico.

### D-003 — Propuesta de valor (una frase)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** **Para agentes de tránsito que necesitan el código correcto de una infracción al elaborar un comparendo, Códigos de Tránsito es una app móvil experimental de consulta offline (catálogo en el dispositivo) con listado por categoría y búsqueda por código o descripción.**
- **Motivo:** Rol primario cerrado + naturaleza experimental.
- **Implicaciones:** Filtro duro contra features de producto masivo / stores.

---

## 3. Usuarios y contexto

### D-004 — Usuarios objetivo
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:**
  - **Único rol de la app:** **Agente de tránsito**.
  - **Usuario piloto:** el padre del promotor (agente de tránsito). La v1 se construye **para él**.
  - **Expansión posible:** si compañeros se interesan, se les puede armar un instalable **personalizado** (credenciales en JSON de esa build). No hay roles distintos (admin, conductor, etc.).
  - **No hay** multi-rol, permisos granulares ni perfiles de “tipo de usuario” en la app.
- **Motivo:** Confirmación explícita; producto experimental de un solo rol.
- **Implicaciones:** UI y copy en segunda persona operativa de agente; no pantallas de gestión de flotas ni público general.

### D-005 — Geografía y marco legal
- **Estado:** Decidido (marco); detalle de fuente en D-023
- **Fecha:** 2026-09-19
- **Decisión:** **Colombia.** Catálogo tipo `A.01`, `B.03`, `C.28` por categorías A, B, C, …
- **Implicaciones:** No multi-país en v1.

### D-006 — Idioma(s) del producto
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** **Español** únicamente en v1.

### D-033 — Naturaleza del proyecto (experimental / personalizado)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Proyecto **experimental y personalizado**, no producto de tienda masiva.
  - Un piloto principal; instalaciones puntuales a terceros si se acuerda.
  - Posible cobro simbólico (“unos pesitos”) por armar credenciales + APK a un compañero: es un **acuerdo manual** entre personas, no un sistema de pagos in-app.
  - Contenido de infracciones relativamente **estable** (cambia en años, no cada semana) → razonable “quemar” datos en la app o actualizar de forma poco frecuente.
- **Motivo:** Definición explícita del alcance social y comercial del piloto.
- **Implicaciones:** Sin Play Store / App Store (D-020). Auth vía JSON híbrido + device_id (D-019). Priorizar simplicidad extrema.

---

## 4. Alcance del producto

### D-007 — Qué es el producto (tipo)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** App móvil de **consulta** de manual de infracciones (código + descripción), categorías, filtros y búsqueda. Experimental, un rol (agente).

### D-008 — MVP (mínimo viable)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** El agente piloto debe poder:
  1. Instalar la app en su teléfono (**Android vía APK** como camino principal; ver D-015/D-020).
  2. Entrar con **usuario + contraseña** validadas contra un **JSON interno** de la build (D-019).
  3. Ver listado de infracciones por **categoría**.
  4. **Filtrar** por categoría.
  5. **Buscar** por código (tolerante a formato) y por texto en la descripción.
  6. Abrir **detalle** (código + descripción).
  7. Usar todo lo anterior **offline**.
  8. Si hay internet, puede **actualizar el catálogo** desde el JSON remoto (D-023); sin internet usa la copia local/seed.
- **Demo de humo:** modo avión → “resonador” → **C.28** legible.

### D-009 — Fuera de alcance (v1)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** **No** entra en v1:
  - Publicación en Play Store / App Store
  - Backend de usuarios, registro self-service, recuperación de contraseña elaborada
  - Pagos in-app / pasarelas
  - Pago de multas, SIMIT, RUNT, emisión de comparendos
  - Chat / IA
  - Mapas, GPS, fotomultas
  - Multi-país / multi-idioma
  - Varios roles o panel admin web
  - Edición del catálogo desde la app por el agente
  - Campos extra de infracción (sanciones, SMMLV, etc.) — ver D-028
  - **iOS / iPhone** como plataforma soportada (sin Apple Developer ni PWA de soporte)
- **Implicaciones:** Personalización de usuarios = editar JSON y regenerar/repartir instalable (o mecanismo mínimo equivalente).

### D-010 — Criterios de éxito
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Éxito del piloto =
  1. El **agente piloto** (padre) puede, en campo y **sin red**, encontrar el código que necesita para el comparendo en poco tiempo.
  2. Búsqueda por código y por palabras de la descripción es usable en la práctica.
  3. Instalación en su Android por **APK** sin tienda.
  4. Login simple con su cédula/clave funciona sin servidor.
- No se exigen métricas de producto masivo ni retención de miles de usuarios.

### D-028 — Modelo de contenido (infracción)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Solo lo necesario para buscar y entender:
  | Campo | Ejemplo |
  | --- | --- |
  | `codigo` | `C.28` |
  | `categoria` | `C` |
  | `categoria_titulo` | `Infracciones de mayor cuantía ordinaria` |
  | `descripcion` | texto de la infracción |
| `referencias` | lista de strings, ej. `Art. 131`, `Res. 20` (opcional) |
- **Opcional:** `referencias` puede ir vacía o ausente. Se muestra en el detalle al tocar el código.
- **Sin otros campos por ahora** (ni valor en salarios, ni keywords obligatorias). Si más adelante la búsqueda lo pide, se puede añadir `keywords`.
- **Quién llena el catálogo:** el promotor del producto, a mano, en JSON (se demora; es aceptable).
- **Implicaciones:** Schema en `docs/contenido-ejemplo.md` y `app/assets/data/README.md`.

### D-029 — Organización UX del catálogo
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Listado + categorías + filtro + búsqueda + detalle simple.

### D-030 — Requisitos de búsqueda
- **Estado:** Decidido (comportamiento)
- **Fecha:** 2026-09-19
- **Decisión:** Búsqueda offline por código normalizado y por texto en descripción; útil en campo (ej. “resonador” → C.28). Sin IA.

### D-031 — Offline-first (requisito crítico)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** La consulta **nunca** depende de internet. Datos de infracciones en el dispositivo (seed + copia local). Internet se usa para **actualizar** el catálogo (híbrido D-023), nunca como condición para consultar.

---

## 5. Principios de trabajo

### D-011 — Documentación primero
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Documentación fundamental; decisiones en este contrato; narrativa en `docs/`.

### D-012 — Contrato colaborativo
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Lo construimos entre los dos.

### D-013 — Orden: contrato → fases → código
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Contrato base → fases → implementación.

### D-014 — Transparencia de supuestos
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Supuestos marcados como tales.

### D-032 — Simplicidad del producto
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Preferir lo simple y experimental. Evitar over-engineering.

---

## 6. Stack y arquitectura

### D-015 — Tipo de aplicación y plataformas
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:**
  - **Única plataforma soportada: Android.**
  - Entrega: **APK** por sideload (sin Play Store).
  - **Usuario que importa:** el padre del promotor (agente, Android). Cómo se instale le da igual mientras funcione; el canal elegido es APK.
  - **iOS: fuera de alcance.** No se pagará cuenta Apple Developer. Compañeros con iPhone **no son objetivo** del producto (“opcional / no prioritario / no se soporta”).
  - Play Store / App Store: fuera de alcance (D-020).
- **Motivo:** Confirmación explícita del promotor (2026-09-19): foco total en el piloto Android; iPhone no justifica costo ni complejidad.
- **Historia:** Se consideró iOS por compañeros; se descartó al no haber Apple Developer ni prioridad de negocio.
- **Implicaciones:** Stack y QA solo Android. Reabrir solo con nueva decisión explícita en este contrato.

### D-016 — Frontend / framework móvil
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** **Flutter** (lenguaje **Dart**).
- **Motivo (delegado al co-diseño; el promotor no tenía preferencia de lenguaje):**
  - Objetivo claro = **APK Android** usable para el piloto.
  - UI de listas, filtros y búsqueda offline es un caso natural de Flutter.
  - Generación de APK madura (`flutter build apk`).
  - Buena productividad para un producto simple experimental.
  - iOS no se soporta (D-015); no se eligió Flutter “para dual-plataforma”, sino por solidez del APK y del modelo de app. (Kotlin nativo era alternativa válida; se prefirió Flutter por DX de UI y velocidad de MVP.)
- **Alternativas descartadas:**
  - Expo/RN: equivalente técnico; sin preferencia JS no aportaba ventaja.
  - PWA: innecesaria si el piloto acepta APK y iOS está fuera.
  - Kotlin-only: válida en Android-only; descartada en favor de Flutter por decisión de co-diseño.
  - Capacitor / KMP: sin beneficio extra aquí.
- **Implicaciones:** Toolchain Flutter + Android SDK. Proyecto(s) bajo convenciones Flutter. Detalle en `docs/stack.md`.


### D-017 — Backend / API
- **Estado:** Decidido (MVP)
- **Fecha:** 2026-09-19
- **Decisión:** **Sin backend de aplicación en el MVP.** No hay API de login con lógica de servidor ni base de datos de app. Auth y catálogo = JSON (local + estáticos en hosting: D-023, D-035). Eso **no** es un backend (sin escritura desde la app, sin DB).
- **Motivo:** Experimental, simplicidad.
- **Implicaciones:** Hospedar archivo(s) estático(s) de catálogo y de usuarios. Altas/bajas de usuarios = editar JSON remoto, no nuevo APK.

### D-018 — Datos y persistencia local
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:**
  - **Catálogo:** JSON híbrido D-023.
  - **Usuarios:** JSON híbrido D-035 (cédula, clave, activo, device_ids[]).
  - Runtime: copias locales de ambos; fuentes JSON editables por el promotor.
  - Búsqueda de catálogo en memoria (FTS solo si hace falta).
- **Motivo:** JSON + sync sin backend.
- **Implicaciones:** Dos URLs/archivos. APK genérico; no hace falta rebuild por alta de usuario.

### D-019 — Auth e identidad
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:**
  - Login: **usuario + contraseña + device_id** de la instalación (D-034). **Sin IP.**
  - Lista de usuarios: **JSON híbrido** (D-035) — el promotor agrega/revoca/edita sin nuevo APK.
  - Un solo rol (agente). Sin admin in-app. Sin backend de escritura (edición manual del JSON + upload).
  - Pestillo **experimental**, no seguridad bancaria.
  - Enrolamiento **manual**: el agente envía el código del teléfono al promotor; el promotor lo carga en `device_ids` (D-034).
  - Un usuario **puede tener varios teléfonos** (`device_ids` con múltiples entradas).
- **Forma ilustrativa (no real):**
  ```json
  {
    "version": 3,
    "usuarios": [
      {
        "usuario": "1234567890",
        "password": "clave-simple",
        "nombre": "Agente piloto",
        "activo": true,
        "device_ids": ["uuid-tel-1", "uuid-tel-2"]
      }
    ]
  }
  ```
  - `activo: false` o sin usuario = revocado.
  - `device_ids` vacío = aún no enrolado → no entra hasta que el promotor cargue al menos un id.
- **Motivo:** OK explícito del promotor (híbrido, device_id, enrolamiento manual, multi-dispositivo).
- **Historia:** Empezó como JSON solo embebido cédula+clave; reabierto y cerrado el mismo ciclo con híbrido + device binding.
- **Implicaciones:** APK genérico viable. Ver D-034, D-035, `docs/auth.md`.


### D-037 — Identificador de login: usuario (no cédula)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** El login usa un campo **`usuario`** (ej. `admin`, `oscar`) + contraseña. **No** se usa cédula ni otro documento de identidad en la app.
- **Motivo:** Menos dato personal sensible en el JSON de usuarios; más simple de operar y de mostrar en portfolio sin PII de documentos.
- **Implicaciones:** Schema `usuarios.json` con `usuario`. Matching case-insensitive. UI en español: etiqueta «Usuario».

### D-036 — Caducidad de sesión (login diario)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** La sesión no es indefinida. Tras un login exitoso, vale solo el **día calendario local** del dispositivo. Al día siguiente (desde las 00:00 locales), al abrir la app se exige login otra vez.
- **Motivo:** Pedido del promotor.
- **Implicaciones:** Se guarda la fecha local del último login (yyyy-MM-dd). Mismo día: no pide login al reabrir. Cruzar medianoche: sí. Siguen revocación y device.
- **No es:** TTL de 24 horas exactas desde el login; es día calendario.

### D-038 — Hosting de datos (portfolio vs operaciones)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:**
  - **Repo público (portfolio):** código Flutter, docs, seeds de demo. Sin contraseñas reales ni cédulas.
  - **Repo privado de datos:** `catalogo.json` + `usuarios.json`.
  - **Cloudflare Pages:** despliegue HTTPS desde el repo privado (`git push` → publish).
- **Motivo:** Credibilidad de portfolio + no exponer JSON de agentes en repos públicos.
- **Implicaciones:** `.gitignore` excluye `hosting/usuarios.json` / `catalogo.json` de producción; solo `*.ejemplo.json` en público. Ver `docs/data-hosting.md`.

### D-020 — Hosting, distribución e instalación
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:**
  - **No** Play Store, **no** App Store, **no** canal iOS.
  - **Único instalable:** **APK Android** (Flutter release/sideload).
  - Reparto: WhatsApp, Drive, cable u otro medio humano.
  - El piloto no exige un modo de instalación concreto; se estandariza en APK por simplicidad operativa.
  - **Hosting del catálogo:** archivo(s) JSON estático(s) para sync híbrido (D-023). Hosting concreto se fija en implementación/fases (p. ej. GitHub Pages/raw u otro estático).
- **Motivo:** Foco en el padre (Android); sin Apple Developer; iOS fuera (D-015).
- **Implicaciones:** Alta/baja de usuarios y device ids ⇒ JSON remoto de usuarios, **sin** nuevo APK. Lógica de app ⇒ nuevo APK. Catálogo ⇒ JSON remoto (D-023).
- **Hosting:** URL catálogo + URL **usuarios** (D-035). URL de usuarios poco adivinable si se puede; no es secreto criptográfico.

### D-021 — IA / automatización
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Sin IA en v1.

### D-023 — Fuente y actualización del catálogo (JSON)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Estrategia **C — híbrido desde el día 1**.
  1. La app **incluye un catálogo seed** (JSON embebido o copiado al almacén local en el primer arranque) → **offline inmediato** tras instalar.
  2. Si hay **internet**, la app puede **consultar un JSON estático** en una URL configurada (versionado con campo `version` o equivalente).
  3. Si el remoto es más nuevo (o el local está vacío/corrupto), se **descarga y reemplaza la copia local**.
  4. Si no hay red o falla la descarga, se sigue con la **última copia local** sin bloquear la consulta.
  5. El promotor **llena y publica** el JSON (a mano, con paciencia); no hace falta API ni base de datos.
  6. Hosting del archivo: estático simple (ej. GitHub raw/Pages, Cloudflare R2, S3 público, Firebase Hosting, etc. — se elige al implementar; no es “backend de app”).
- **Motivo:** Confirmación explícita del usuario. El catálogo se irá completando con el tiempo; el híbrido evita reinstalar el APK del piloto (y de eventuales androides) por cada tanda de códigos.
- **Alternativas descartadas para v1:** solo embebido sin sync (A); backend gordo.
- **Implicaciones:** Catálogo = “local + GET”. El JSON de **usuarios es otro archivo/URL** (D-035), nunca mezclado con el de infracciones. Catálogo = no secreto (normativa).

### D-034 — Vínculo credenciales ↔ dispositivo (anti uso en otro teléfono)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:**
  - **No usar IP** como factor de login.
  - **Sí:** ID de instalación (**UUID** generado y persistido por la app en ese teléfono al primer arranque).
  - **No** IMEI como requisito.
  - Regla de login: usuario + contraseña correctas, `activo == true`, y el `device_id` local ∈ `device_ids` del usuario.
  - **Varios teléfonos por usuario permitidos:** `device_ids` es una lista; el promotor puede registrar más de un aparato para la misma cédula/clave.
  - **Enrolamiento manual (sin backend de escritura):**
    1. Promotor crea usuario (cédula, clave, `activo: true`, `device_ids` puede empezar vacío o ya con ids conocidos).
    2. Agente instala APK; la app muestra el **código de este teléfono**.
    3. Se lo envía al promotor (p. ej. WhatsApp).
    4. Promotor **añade** ese id a `device_ids` (sin borrar otros si ya había) y publica el JSON.
    5. Agente sincroniza usuarios (con red) y puede entrar.
  - **Quitar un teléfono:** el promotor elimina ese id de la lista (los demás siguen válidos).
  - **Revocar usuario entero:** `activo: false` o borrar el usuario.
- **Límites conscientes:** no es antimafia; mismo teléfono físico compartido no se distingue; clonar datos de app o editar JSON remoto bypassea el pestillo.
- **Motivo:** OK explícito del promotor.

### D-035 — Auth híbrida offline/online (JSON de usuarios)
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:**
  1. Seed local (vacío o fixtures de dev / piloto de emergencia).
  2. Con internet: GET de `usuarios.json` remoto (`version`); si más nuevo, reemplaza copia local.
  3. Sin internet o fallo: login contra **última copia local** (cédula + clave + device_id).
  4. Alta/baja/edición de device_ids: el promotor sube JSON nuevo — sin nuevo APK.
  5. Archivo/URL de usuarios **separado** del catálogo de infracciones.
  6. **Políticas R1/R2 de revocación offline: no se exigen.** El promotor indicó que no importan. Comportamiento suficiente:
     - Cuando haya red, la app **puede/debe intentar** refrescar usuarios en algún momento natural (arranque o login) de forma simple, sin diseñar TTL ni bloqueo agresivo.
     - Se acepta el límite: un revocado con copia local vieja y sin volver a sincronizar puede seguir entrando offline hasta que sincronice o reinstale.
- **Seguridad:** JSON con cédulas/claves = sensible a nivel archivo/URL; nivel experimental (D-025).
- **Motivo:** OK explícito; simplicidad sobre kill-switch offline.


---
## 7. Calidad, legal y restricciones

### D-022 — Naturaleza de la información legal
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Informa y orienta; no es asesoría legal ni sustituye la norma oficial. Disclaimer visible.

### D-024 — Pruebas y calidad mínima
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:** Antes de llamar “listo el piloto” a una entrega:
  1. **Humo funcional** (emulador o dispositivo): login, listado, filtro por categoría, búsqueda, detalle.
  2. **Casos de búsqueda:** `C.28` / `c28`, texto “resonador”, al menos un código de categoría A y uno de B del seed.
  3. **Modo avión:** lista, filtro, búsqueda y detalle operativos con el catálogo local/seed; login con copia local de usuarios **si** el device ya está enrolado.
  4. **Sync catálogo (con red):** versión remota más nueva actualiza local; fallo de red no rompe consulta.
  5. **Auth:** device no listado → rechazo; `activo: false` en copia usada → rechazo; misma clave en device no autorizado → rechazo; multi-device del mismo usuario OK si ambos ids están en la lista; con red, intentar refresh de usuarios en arranque/login (sin TTL R2).
  6. **APK real:** instalación del `.apk` en un Android de prueba/piloto.
- **No exigido en v1:** cobertura de tests automatizados al 100 %, CI compleja, pruebas en iOS.
- **Motivo:** Cerrar definición de hecho alineada al MVP experimental.

### D-025 — Privacidad y datos personales
- **Estado:** Decidido (nivel experimental)
- **Fecha:** 2026-09-19
- **Decisión:**
  - Datos de acceso: **cédula, contraseña, device_id de instalación**, nombre opcional.
  - Con auth híbrida: el JSON de usuarios vive también en **hosting** (lectura por la app). No es un “servidor de perfiles” con lógica; es un archivo. Igual implica cédulas/claves fuera del teléfono → tratar URL y repo con cuidado.
  - En el dispositivo: device_id local + copia cacheada de usuarios + sesión.
  - No se piden placas, fotos ni datos de infractores.
  - **No** se usa IP como identificador.
  - Nivel: **bajo / experimental** (pestillo entre agentes, no compliance fuerte).
  - Si el alcance crece, reabrir (hashes de password, JSON no público, backend real).
- **Implicaciones:** Transparencia con el piloto: no es app “segura”; es control de quién la usa en qué teléfono.

### D-026 — Restricciones de entorno
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:**
  - Offline-first (D-031).
  - Experimental, piloto familiar (D-033).
  - Android APK sin tiendas (D-020).
  - Un desarrollador/promotor arma builds personalizadas a mano.
  - Catálogo llenado manualmente con paciencia (D-028).
- **Pendiente menor:** plazos deseados del piloto (si hay fecha).

---

## 8. Estructura de documentación (repo)

### D-027 — Layout de docs
- **Estado:** Decidido
- **Fecha:** 2026-09-19
- **Decisión:**

```
/
├── CONTRATO.md
├── README.md
├── dist/                       ← APKs de prueba (gitignored)
├── app/                        ← Flutter (Android)
│   ├── lib/
│   ├── assets/data/
│   └── android/
└── docs/
    ├── README.md
    ├── vision.md
    ├── alcance.md
    ├── stack.md
    ├── auth.md
    ├── distribucion.md
    ├── fases.md
    ├── contenido-ejemplo.md
    └── decisiones/
```

---

## 9. Registro cronológico breve

| Fecha | Evento |
| --- | --- |
| 2026-09-19 | Reinicio de cero. Contrato + docs base. |
| 2026-09-19 | Visión app consulta infracciones offline, MVP UX, sin IA. |
| 2026-09-19 | Cierre: usuario = agente de tránsito; piloto = padre; un solo rol; experimental; auth cédula+clave vía JSON interno; sin stores; Android APK; catálogo JSON campos mínimos; sin backend MVP. |
| 2026-09-19 | D-023 **Decidido:** catálogo híbrido C desde día 1. Debate framework en docs/stack.md. |
| 2026-09-19 | **Cierre contrato base:** iOS fuera; **Flutter** + APK Android; D-024. → fases. |
| 2026-09-19 | Reapertura auth (propuesta híbrida + device; no IP). |
| 2026-09-19 | **Auth cerrada:** device_id sí; usuarios híbridos; enrolamiento manual; multi-teléfono por usuario; R1/R2 no obligatorias. |
| 2026-09-19 | OK a fases. **F0 hecha:** app Flutter en `app/`, APK release generado. |

---

## 10. Próximos pasos de planificación

1. ~~F0–F5~~ **hechas** (software).
2. Operación: completar catálogo, publicar JSON, enrolar device del padre (`docs/entrega-piloto.md`).
3. Hosting de producción + `./scripts/build-piloto.sh` con URLs finales cuando existan.

---

## 11. Checklist de cierre del contrato base

- [x] Visión y problema
- [x] Usuarios objetivo (agente; piloto padre; un rol)
- [x] Geografía / marco legal (Colombia)
- [x] Tipo de producto
- [x] MVP y fuera de alcance
- [x] Criterios de éxito (piloto)
- [x] Stack framework (**Flutter**, D-016)
- [x] Auth (híbrido + device_id + multi-teléfono; sin IP; sin R1/R2 obligatorios)
- [x] Fuentes/actualización del catálogo (D-023 — híbrido C desde día 1)
- [x] Disclaimer / límites legales
- [x] Privacidad (nivel experimental)
- [x] Estándar de calidad / humo (D-024)
- [x] Restricciones (experimental, APK, sin tiendas)
- [x] Offline-first
- [x] Modelo de contenido (solo código/categoría/descripcion)
- [x] Sin IA; sin backend MVP
- [x] Distribución **solo** Android APK; **iOS fuera de alcance**

**Checklist de contrato completo otra vez.** Siguiente: OK a `docs/fases.md` → implementación F0.
