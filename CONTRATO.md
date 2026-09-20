# Project contract

> Living document. We record **what** we decided, **why**, and **what is still open**.
> Nothing is assumed until it appears here with status **Decided**.
> We build this together: propose → discuss → close here before implementing.

**Last updated:** 2026-09-19  
**Overall status:** v1 software complete (F0–F5). Daily session (D-036). Username login (D-037). Data on private repo + Cloudflare Pages (D-038).

---

## 1. How we use this contract

| Rule | Description |
| --- | --- |
| Source of truth | If conversation and this file disagree, **this file** wins. |
| Decisions | Product, architecture, stack, and process decisions are logged here. |
| States | `Proposed` → `In discussion` → `Decided` → `Revisit` (if reopened). |
| History | Do not erase history: mark the old decision and add the new one with a date. |
| Implementation | Only implement what is **Decided**. |
| Phases | Build phases come **after** the base contract is closed (then `docs/fases.md`). |

### Decision format

```
### D-XXX — Short title
- **Status:** Proposed | In discussion | Decided | Revisit
- **Date:** YYYY-MM-DD
- **Decision:** what was chosen
- **Rationale:** why
- **Rejected alternatives:** (if any)
- **Implications:** what it enables or blocks
```

---

## 2. Vision and problem

### D-001 — Working name
- **Status:** Proposed
- **Date:** 2026-09-19
- **Decision:** Working name **Códigos de Tránsito** / public repo `offline-traffic-codes`. Final product name TBD.
- **Rationale:** Anchor the repository while branding is open.

### D-002 — Problem we solve
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** When issuing or reviewing a **comparendo** (traffic citation), a **traffic officer** needs the correct **infraction code** and meaning quickly—often **without reliable internet**.
- **Implications:** UX optimizes for “find the code and understand it,” not full legal procedure or payments.

### D-003 — Value proposition
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** **For traffic officers who need the correct infraction code when writing a citation, this is an experimental offline-first mobile consultation app: catalog on device, categories, search by code or description.**
- **Implications:** Hard filter against mass-market / store features in v1.

---

## 3. Users and context

### D-004 — Target users
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:**
  - **Only role:** traffic officer / agent.
  - **Pilot user:** promoter’s father (traffic officer). v1 is built for him.
  - **Possible expansion:** colleagues get a customized install (credentials in that build’s user JSON). No multi-role admin UI.
- **Implications:** Operational copy; no fleet back-office.

### D-005 — Geography / legal frame
- **Status:** Decided (frame); source detail in D-023
- **Date:** 2026-09-19
- **Decision:** **Colombia.** Codes like `A.01`, `C.28` by letter categories.
- **Implications:** No multi-country in v1.

### D-006 — Product language
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** **Spanish** for the in-app UI and agent-facing copy. **English** for public portfolio docs (this contract, README, `docs/`).
- **Rationale:** Agents work in Spanish; portfolio readers expect English.

### D-033 — Project nature (experimental / custom)
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Experimental, customized app—not a mass store product. Optional small fee for hand-built installs is **outside** the app. Infraction content is relatively stable (years, not weeks).
- **Implications:** No Play/App Store (D-020). Prefer extreme simplicity.

---

## 4. Product scope

### D-007 — Product type
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Mobile **consultation** app: infraction manual (code + description), categories, filters, search. Experimental, single role.

### D-008 — MVP
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Pilot agent can:
  1. Install on Android via **APK** sideload.
  2. Sign in with **username + password** against hybrid users JSON (D-019 / D-037).
  3. Browse infractions by **category**.
  4. **Filter** by category.
  5. **Search** by code (format-tolerant) and description text.
  6. Open **detail** (description + optional `referencias`).
  7. Use all of the above **offline**.
  8. With internet, optionally **refresh** catalog/users from static HTTPS JSON (D-023).
- **Smoke demo:** airplane mode → search “resonador” → **C.28**.

### D-009 — Out of scope (v1)
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Not in v1:
  - Play Store / App Store public listing
  - User self-registration backend, fancy password recovery
  - In-app payments
  - Official fine payment, SIMIT, RUNT, electronic citation issuance
  - Chat / AI
  - Maps, GPS, speed cameras
  - Multi-country / multi-language UI
  - Multiple in-app roles or web admin CMS
  - End-user editing of the catalog
  - Extra fine fields (SMMLV amounts, etc.) unless later agreed
  - **iOS** as a supported platform (no Apple Developer account)
- **Implications:** User personalization = edit JSON + redistribute APK and/or publish remote users JSON.

### D-010 — Success criteria
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Pilot success =
  1. Pilot officer finds needed codes in the field **without network**.
  2. Code + keyword search is usable in practice.
  3. Android APK install without a store.
  4. Local login works without a server.
- No mass-market retention metrics required.

### D-028 — Content model (infraction)
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Minimum fields:

  | Field | Example |
  | --- | --- |
  | `codigo` | `C.28` |
  | `categoria` | `C` |
  | `categoria_titulo` | category title |
  | `descripcion` | body text |
  | `referencias` | optional list, e.g. `Art. 131`, `Res. 20` |

- Shown in the **detail** sheet when tapping a code.
- Catalog author: promoter, manual JSON (patient fill-in is OK).

### D-029 — Catalog UX
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** List + categories + filter + search + simple detail.

### D-030 — Search behavior
- **Status:** Decided (behavior)
- **Date:** 2026-09-19
- **Decision:** Offline search by normalized code and description text; useful in the field (e.g. “resonador” → C.28). No AI.

### D-031 — Offline-first (critical)
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Consultation **never** depends on internet. Infraction data on device (seed + local copy). Internet only for **updates** when hybrid sync is configured.

---

## 5. Working principles

### D-011 — Documentation first
- **Status:** Decided
- **Decision:** Documentation is mandatory. Binding decisions live here; narrative in `docs/`.

### D-012 — Collaborative contract
- **Status:** Decided
- **Decision:** Built together; closed with promoter confirmation and a log entry here.

### D-013 — Order: contract → phases → code
- **Status:** Decided
- **Decision:** 1) Base contract 2) Phases 3) Implementation.

### D-014 — Transparent assumptions
- **Status:** Decided
- **Decision:** Assumptions are labeled as such.

### D-032 — Product simplicity
- **Status:** Decided
- **Decision:** Prefer simple/experimental solutions that meet the MVP. Avoid over-engineering.

---

## 6. Stack and architecture

### D-015 — App type and platforms
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:**
  - **Only supported platform: Android.**
  - Delivery: **APK** sideload (no Play Store).
  - **iOS: out of scope** (no Apple Developer spend; colleagues on iPhone are not a target).
- **History:** iOS was considered; dropped by explicit choice.

### D-016 — Framework
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** **Flutter** (Dart).
- **Rationale:** Language preference delegated; solid APK path; lists/search/offline fit well. Not chosen “for iOS dual-platform.”
- **Rejected:** Expo/RN (no JS preference), PWA (APK preferred), Kotlin-only (Flutter won on DX).

### D-017 — Backend / API
- **Status:** Decided (MVP)
- **Date:** 2026-09-19
- **Decision:** **No application backend.** No login API or app database. Auth + catalog = JSON (local + optional static HTTPS files). That is **not** a backend (no write API from the app).
- **Implications:** Host static file(s). User add/remove = edit remote JSON, not a new APK (when hybrid is live).

### D-018 — Local data
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:**
  - Catalog: hybrid JSON (D-023).
  - Users: hybrid JSON (D-035) with `usuario`, password, `activo`, `device_ids[]`.
  - In-memory search is enough for typical catalog size (FTS later if needed).
- **Implications:** Two files/URLs. Generic APK possible.

### D-019 — Auth and identity
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:**
  - Login: **username + password + device_id** (D-034, D-037). **No IP.**
  - Users list: **hybrid JSON** (D-035)—promoter adds/revokes/edits without a new APK when remote is configured.
  - Single role (agent). No in-app admin. No write backend (manual JSON + upload).
  - **Experimental** gate, not bank-grade security.
  - **Manual enrollment:** agent sends phone code to promoter; promoter adds it to `device_ids`.
  - **Multiple phones per user** allowed (`device_ids` array).
- **Illustrative shape (not real credentials):**
  ```json
  {
    "version": 5,
    "usuarios": [
      {
        "usuario": "oscar",
        "password": "simple-password",
        "nombre": "Pilot agent",
        "activo": true,
        "device_ids": ["uuid-phone-1", "uuid-phone-2"]
      }
    ]
  }
  ```
- **History:** Started as embedded cédula+password JSON; reopened to hybrid + device binding; then **username** instead of national ID (D-037).

### D-037 — Login identifier: username (not national ID)
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Login uses field **`usuario`** (e.g. `admin`, `oscar`) + password. **No cédula** or other government ID in the app.
- **Rationale:** Less sensitive PII in the users JSON; simpler ops; cleaner portfolio story.
- **Implications:** Case-insensitive username match. Spanish UI label «Usuario».

### D-034 — Bind credentials to device
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:**
  - **Do not use IP.**
  - **Do use** an installation UUID stored on first launch.
  - No required IMEI.
  - Login rule: username + password OK, `activo == true`, and local `device_id` ∈ `device_ids`.
  - Multiple phones per user allowed.
  - Manual enrollment without a write API (WhatsApp the code → edit JSON → publish).
  - **Debug builds** may relax device binding for developer testing; **release** stays strict.
- **Limits:** Not anti-forensics; same physical phone shared is indistinguishable; owning the remote JSON bypasses the gate.

### D-035 — Hybrid auth JSON (offline/online)
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Same family as D-023 for **users**:
  1. Local seed / cache.
  2. With network: GET remote `usuarios.json` (`version`); replace local if newer.
  3. Offline: login against last local copy.
  4. Separate file/URL from the catalog.
  5. **R1/R2 offline revoke policies not required** (promoter said they do not matter). Optional best-effort refresh on open/login is enough.
- **Accepted limit:** a revoked user who never syncs again may keep an old local copy.

### D-036 — Session expiry (daily login)
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Session is **not** indefinite. After a successful login it is valid only for the device’s **local calendar day**. From the **next day** (local midnight onward), opening the app requires login again.
- **Rationale:** Promoter request—do not leave session open forever until revoke.
- **Implications:** Store local login date `yyyy-MM-dd`. Same day reopen: no login. After midnight: login. Revoke / device removal still apply on restore.
- **Not:** a rolling 24-hour TTL from login time; it is **calendar day**.

### D-020 — Hosting, distribution, install
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:**
  - No public Play Store / App Store as the product channel.
  - Only installable: **Android APK** (Flutter release / sideload).
  - Human distribution (WhatsApp, Drive, cable…).
  - Catalog hosting: static JSON URL(s) for hybrid sync (D-023).
- **Implications:** Auth/user/device changes → remote JSON when hybrid is live. App logic changes → new APK.

### D-038 — Data hosting (portfolio vs operations)
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:**
  - **Public repo (portfolio):** Flutter app, docs (English), demo seeds only. No real passwords or national IDs.
  - **Private data repo:** real `catalogo.json` + `usuarios.json`.
  - **Cloudflare Pages:** HTTPS deploy from the private repo (`git push` → publish).
- **Rationale:** Portfolio credibility + do not expose agent JSON on public repos.
- **Implications:** Public `.gitignore` excludes production hosting JSON; only `*.ejemplo.json` samples. See `docs/data-hosting.md`.
- **Repos:**  
  - Public: `https://github.com/marin1321/offline-traffic-codes`  
  - Private: `https://github.com/marin1321/codigos-transito-data`

### D-021 — AI
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** No AI in v1.

### D-023 — Catalog source and updates
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:** Strategy **C — hybrid from day one**.
  1. App includes a **seed** catalog → offline immediately after install.
  2. With internet, GET a static remote JSON (versioned).
  3. If remote is newer, replace local copy.
  4. If offline/fail, keep last local copy; consultation is never blocked.
  5. Promoter fills and publishes JSON by hand; no API/DB required.
  6. Hosting: static (Cloudflare Pages from private repo).
- **Implications:** Catalog URL ≠ users URL. Catalog is non-secret (regulatory text). Users file is sensitive.

---

## 7. Quality, legal, constraints

### D-022 — Legal nature of content
- **Status:** Decided
- **Decision:** Informs and orients; not legal advice; does not replace the official statute. Visible disclaimer required.

### D-024 — Minimum quality / definition of done
- **Status:** Decided
- **Decision:** Before calling a pilot build “ready”:
  1. Functional smoke: login, list, category filter, search, detail.
  2. Search cases: `C.28` / `c28`, “resonador”, sample A and B codes.
  3. Airplane mode: list/filter/search/detail work with local catalog; login works if device already enrolled (release).
  4. Catalog sync with network when configured; failed network does not break consultation.
  5. Auth: unknown device rejected in release; `activo: false` rejected; multi-device OK when listed; best-effort users refresh on open/login.
  6. Real APK install on a test/pilot Android device.

### D-025 — Privacy
- **Status:** Decided (experimental level)
- **Decision:**
  - Access data: **username, password, installation device_id**, optional display name.
  - With hybrid auth, users JSON is also on hosting (read-only GET). Treat URL carefully.
  - No plates, photos, or offender PII required.
  - **No IP** as identifier.
  - Level: **low / experimental** (gate among agents, not strong compliance).
- **Implications:** Be transparent with the pilot: not a “secure” banking app.

### D-026 — Environment constraints
- **Status:** Decided
- **Decision:** Offline-first; experimental pilot; Android APK; single promoter builds hand installs; catalog filled manually over time.

---

## 8. Documentation layout

### D-027 — Docs layout
- **Status:** Decided
- **Date:** 2026-09-19
- **Decision:**

```
/
├── CONTRATO.md              ← this file (English for portfolio)
├── README.md                ← English portfolio entry
├── app/                     ← Flutter (Android)
├── docs/                    ← English narrative docs
├── hosting/                 ← examples only (*.ejemplo.json)
└── scripts/
```

Public portfolio docs are **English**. In-app UI remains **Spanish** for agents.

---

## 9. Chronological log (short)

| Date | Event |
| --- | --- |
| 2026-09-19 | Restart from zero. Contract + docs base. |
| 2026-09-19 | Vision: offline consultation app; MVP UX; no AI. |
| 2026-09-19 | User = traffic officer; pilot = father; experimental; Android APK. |
| 2026-09-19 | Hybrid catalog C; Flutter; F0–F5 delivered. |
| 2026-09-19 | Auth: hybrid users + device_id; multi-phone; no mandatory R1/R2. |
| 2026-09-19 | D-036 daily calendar session. |
| 2026-09-19 | `referencias` on infractions; detail UI. |
| 2026-09-19 | D-037 username login (not cédula). D-038 private data + Cloudflare Pages. Public docs English. |
| 2026-09-19 | Repos: `offline-traffic-codes` (public), `codigos-transito-data` (private). |

---

## 10. Next steps (ops)

1. Connect **private** `codigos-transito-data` to **Cloudflare Pages**.
2. Bake HTTPS URLs into pilot APK (`CATALOGO_URL` / `USUARIOS_URL`).
3. Replace demo users with real pilot username/password + enroll device id (release).
4. Grow the official catalog content over time.

---

## 11. Base contract checklist

- [x] Vision and problem  
- [x] Target users  
- [x] Geography (Colombia)  
- [x] Product type  
- [x] MVP and out of scope  
- [x] Success criteria  
- [x] Stack (**Flutter**, Android APK)  
- [x] Auth (username + password + device; hybrid JSON)  
- [x] Catalog hybrid updates  
- [x] Legal disclaimer  
- [x] Privacy (experimental)  
- [x] Quality smoke (D-024)  
- [x] Offline-first  
- [x] Content model + search  
- [x] No AI; no app backend  
- [x] Android-only distribution  
- [x] Daily session  
- [x] Portfolio vs private data hosting  

**Base contract closed. Phases F0–F5 software complete. Remaining work is content + Cloudflare ops.**
