# App — Códigos de Tránsito

Flutter **Android only**. Producto y contrato: repo padre.

## Comandos

```bash
flutter pub get
flutter test
flutter run
flutter build apk --release
```

Entrega piloto (desde la raíz del repo):

```bash
./scripts/build-piloto.sh
```

Con sync remoto:

```bash
CATALOGO_URL='https://…/catalogo.json' \
USUARIOS_URL='https://…/usuarios.json' \
./scripts/build-piloto.sh
```

Ver `../docs/entrega-piloto.md` y `../docs/sync.md`.
