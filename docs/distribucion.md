# Distribution and install

> Contract: **D-015**, **D-020**, **D-033**.  
> **Android only. APK only. No stores. No iOS.**

## Android (only channel)

| Step | What happens |
| --- | --- |
| 1 | Build `.apk` with Flutter (`flutter build apk` / `./scripts/build-piloto.sh`). |
| 2 | Send to the agent (WhatsApp, Drive, cable…). |
| 3 | Allow install from unknown sources on the phone. |
| 4 | Open the APK → icon appears. |

## iOS

**Out of scope.** No Apple Developer account and no iPhone support target.

Reopen **D-015 / D-020** in the contract before any iOS work.

## Per-person customization

With hybrid users JSON:

1. Same generic APK.  
2. Onboard: username + password in remote `usuarios.json` + **device_id** the agent sends.  
3. Revoke: `activo: false` or remove user; phone notices on next successful sync.

## Updates

| Change | New APK? |
| --- | --- |
| New infractions (remote JSON) | **No** (with network + sync) |
| Add/remove user or device | **No** (remote users JSON) |
| App logic / UI | **Yes** |
