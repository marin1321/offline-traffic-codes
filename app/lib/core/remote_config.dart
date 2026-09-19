/// Remote static JSON URLs (D-023 / D-035).
///
/// Configure at build/run time:
/// ```bash
/// flutter run \
///   --dart-define=CATALOGO_URL=https://ejemplo.com/catalogo.json \
///   --dart-define=USUARIOS_URL=https://ejemplo.com/usuarios.json
/// ```
///
/// Emulator → host machine HTTP server:
/// `http://10.0.2.2:8787/catalogo.json`
///
/// Empty URL = sync disabled for that file (seed/local only).
class RemoteConfig {
  static const catalogoUrl = String.fromEnvironment(
    'CATALOGO_URL',
    defaultValue: '',
  );

  static const usuariosUrl = String.fromEnvironment(
    'USUARIOS_URL',
    defaultValue: '',
  );

  static bool get hasCatalogoUrl => catalogoUrl.trim().isNotEmpty;
  static bool get hasUsuariosUrl => usuariosUrl.trim().isNotEmpty;
}
