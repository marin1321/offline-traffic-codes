/// App-wide constants (non-secret).
class AppConstants {
  static const String appName = 'Códigos de Tránsito';
  static const String appVersionLabel = '1.1.0';
  static const String catalogoSeedAsset = 'assets/data/catalogo_seed.json';
  static const String usuariosSeedAsset = 'assets/data/usuarios_seed.json';

  /// Visible short tagline under the name (login / about).
  static const String tagline =
      'Consulta offline de infracciones para agentes de tránsito';

  /// Legal orientation (D-022) — copy de entrega.
  static const String disclaimer = '''
Esta aplicación es una herramienta de consulta experimental, de uso orientativo.

Los códigos y descripciones de infracciones se ofrecen para facilitar el trabajo en campo y no constituyen asesoría legal, no reemplazan la norma oficial vigente ni garantizan el resultado de un comparendo u otro procedimiento.

El uso es responsabilidad del agente. Ante cualquier duda, consulte la fuente normativa oficial y los procedimientos de su autoridad de tránsito.
''';

  /// Short install / enrollment help shown on login.
  static const String enrollmentHelp = '''
1. Copia el «código de este teléfono» (botón copiar).
2. Envíaselo por WhatsApp a quien administra la app.
3. Cuando te confirmen que ya quedó registrado, pulsa Entrar con tu usuario y contraseña.
4. Si no hay internet, igual puedes consultar el catálogo que ya tengas guardado en el teléfono.
''';
}
