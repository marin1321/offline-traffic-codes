# Delivery phases

> Base contract **closed**. Auth includes D-019 / D-034 / D-035 / D-036 / D-037.  
> Order (D-013): contract → **these phases** → code.

## Plan overview

Android APK (Flutter) for the pilot: username+password+device login, hybrid catalog/users, offline consultation.

```text
F0 Foundations → F1 Catalog seed → F2 Auth+device → F3 Search UX
  → F4 Hybrid sync → F5 Pilot APK → content (ongoing)
```

| Phase | Status |
| --- | --- |
| **F0** | **Done** — Flutter scaffold |
| **F1** | **Done** — catalog seed |
| **F2** | **Done** — auth + device |
| **F3** | **Done** — search/filters |
| **F4** | **Done** — hybrid sync |
| **F5** | **Done** — pilot APK 1.x |

## Phase summaries

### F0 — Foundations
Flutter Android project, assets layout, disclaimer stub, first APK.  
**Done when:** `flutter run` / `flutter build apk` works.

### F1 — Catalog seed
JSON schema + seed loader + list by category.  
**Done when:** app enumerates seed codes (e.g. 28 sample rows).

### F2 — Auth + device_id
Username/password (now `usuario`), installation UUID, show/copy phone code, session.  
**Done when:** unauthorized device rejected in release; authorized login reaches catalog.

### F3 — Consultation UX
Category chips + search bar (code + description) + detail.  
**Done when:** `c28` / “resonador” → C.28; airplane mode OK.

### F4 — Hybrid sync
GET catalog + users; `version` compare; local fallback; sync button / pull-to-refresh.  
**Done when:** newer remote version appears without reinstalling APK.

### F5 — Pilot delivery
Release APK, about screen, enrollment help, English portfolio docs, install guide.  
**Done when:** pilot APK + `docs/entrega-piloto.md`; physical enrollment remains an ops step.

## Parallel — content

Promoter fills the full official catalog over time; publish new versions after F4/Pages.

## Out of v1 plan

iOS, stores, write backend, IP auth, mandatory offline revoke TTL, AI, multi-role.
