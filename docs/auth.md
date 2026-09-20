# Authentication

> Contract: **D-019**, **D-034**, **D-035**, **D-036**, **D-037** — **Decided**.  
> Level: experimental gate, not bank-grade security.

## Summary

| Piece | Agreement |
| --- | --- |
| Login factors | **Username + password + device_id** |
| IP | **No** |
| Users file | **Hybrid JSON** (local seed/cache + remote) |
| Enrollment | **Manual**: agent sends phone code to promoter |
| Phones per user | **Multiple** allowed (`device_ids[]`) |
| R1/R2 offline revoke TTL | **Not required** |
| Role | Agent only |
| Session | **Local calendar day** only (D-036) |
| Identifier | **`usuario`** (not national ID) |

## Login

Access is granted if and only if:

1. A user exists with that **username** (case-insensitive) and password  
2. `activo === true`  
3. This install’s `device_id` is in `device_ids` (**release** builds; debug may relax this)

## Device ID

- UUID generated on first launch and stored on the phone.  
- UI must **show/copy** that code for WhatsApp.  
- No mandatory IMEI. No IP.  
- Clearing app data creates a **new** device id.

## Multiple phones

```json
"device_ids": ["uuid-work-phone", "uuid-backup"]
```

- **Add** a phone: promoter appends the id.  
- **Remove** a phone: delete only that id.  
- **Revoke person:** `activo: false` or remove the user.

## Enrollment

```text
1. Promoter creates user (usuario, password, activo: true)
2. Agent installs generic APK → sees "code for this phone"
3. Sends it to the promoter
4. Promoter adds id to device_ids and publishes usuarios.json
5. Agent syncs (with network) and logs in
```

## Hybrid `usuarios.json`

1. Local copy (seed or last download).  
2. With network: GET remote if `version` is higher → replace local.  
3. Without network: login against local copy.  
4. **Different URL** from the infraction catalog.

### Offline revoke (accepted limit)

Without mandatory R1/R2: if someone is revoked remotely but **never** syncs again, they may keep the old copy. Accepted.

## File shape

```json
{
  "version": 5,
  "usuarios": [
    {
      "usuario": "oscar",
      "password": "simple-password",
      "nombre": "Pilot agent",
      "activo": true,
      "device_ids": [
        "550e8400-e29b-41d4-a716-446655440000"
      ]
    }
  ]
}
```

## Session expiry (D-036)

- After login OK, session lasts for the rest of the **calendar day** (device timezone).  
- **Same day:** close and reopen → still inside (if still active + device OK).  
- **Next day (from local 00:00):** open app → login screen again.  
- Also cleared by manual logout, revoke, or device removal.  
- No background timer; checked on open/restore.

## APK

One **generic APK** for everyone when remote users JSON is used; who can enter is defined by that JSON (+ cache).
