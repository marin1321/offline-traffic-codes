# Scope

> Contract: D-007 … D-010, D-019, D-020, D-028 … D-033, D-037.

## Product type

**Android (Flutter, APK)** consultation app for **traffic officers**. Pilot = promoter’s father. **No iOS.**

## MVP

1. Install via **APK**  
2. Login **username + password + device_id** (hybrid `usuarios.json`)  
3. List + category filter  
4. Search by code and description  
5. Detail: description + optional `referencias`  
6. Real offline use  
7. Hybrid catalog (seed + static JSON sync)

### Acceptance demo

> APK → login → airplane mode → search “resonador” → **C.28**.

## Out of scope (v1)

- iOS / Apple Developer / support PWA  
- Play Store / App Store  
- Auth backend, payments, SIMIT, AI, multi-role, extra fine amount fields  

## Success criteria

See **D-024** and **D-010** (pilot finds codes offline; real APK installed).

## Priority stories

| ID | As a… | I want… | So that… | P |
| --- | --- | --- | --- | --- |
| H1–H5 | officer | list / filter / search / detail / offline | write the citation | P0 |
| H6 | officer | username + password login | enter my build | P0 |
| H7 | promoter | edit users JSON + APK/remote | customize installs | P1 |
