# App — offline traffic codes

Flutter **Android-only** application. Product decisions: repository root.

## Commands

```bash
flutter pub get
flutter test
flutter run
flutter build apk --release
```

Pilot build (from repo root):

```bash
./scripts/build-piloto.sh
```

With remote sync:

```bash
CATALOGO_URL='https://…/catalogo.json' \
USUARIOS_URL='https://…/usuarios.json' \
./scripts/build-piloto.sh
```

See `../docs/entrega-piloto.md`, `../docs/sync.md`, and `../docs/data-hosting.md`.
