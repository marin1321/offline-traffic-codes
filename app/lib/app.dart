import 'package:flutter/material.dart';

import 'core/theme.dart';
import 'data/auth_service.dart';
import 'data/catalogo_repository.dart';
import 'data/device_id_service.dart';
import 'data/session_store.dart';
import 'data/sync_service.dart';
import 'data/usuarios_repository.dart';
import 'features/shell/auth_gate.dart';

/// Root widget: auth gate → catálogo.
class CodigosTransitoApp extends StatelessWidget {
  const CodigosTransitoApp({
    super.key,
    this.catalogoRepository,
    this.usuariosRepository,
    this.deviceIdService,
    this.sessionStore,
    this.authService,
    this.syncService,
  });

  final CatalogoRepository? catalogoRepository;
  final UsuariosRepository? usuariosRepository;
  final DeviceIdService? deviceIdService;
  final SessionStore? sessionStore;
  final AuthService? authService;
  final SyncService? syncService;

  @override
  Widget build(BuildContext context) {
    final catalogo = catalogoRepository ?? CatalogoRepository();
    final usuarios = usuariosRepository ?? UsuariosRepository();
    final devices = deviceIdService ?? DeviceIdService();
    final session = sessionStore ?? SessionStore();
    final auth = authService ??
        AuthService(
          usuariosRepository: usuarios,
          deviceIdService: devices,
          sessionStore: session,
        );
    final sync = syncService ??
        SyncService(
          catalogoRepository: catalogo,
          usuariosRepository: usuarios,
        );

    return MaterialApp(
      title: 'Códigos de Tránsito',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: AuthGate(
        authService: auth,
        catalogoRepository: catalogo,
        syncService: sync,
      ),
    );
  }
}
