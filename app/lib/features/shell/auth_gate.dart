import 'package:flutter/material.dart';

import '../../data/auth_service.dart';
import '../../data/catalogo_repository.dart';
import '../../data/models/usuario.dart';
import '../../data/sync_service.dart';
import '../auth/login_screen.dart';
import '../catalogo/catalogo_list_screen.dart';

/// Decides between login and catalog based on session.
class AuthGate extends StatefulWidget {
  const AuthGate({
    super.key,
    required this.authService,
    required this.catalogoRepository,
    required this.syncService,
  });

  final AuthService authService;
  final CatalogoRepository catalogoRepository;
  final SyncService syncService;

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  bool _loading = true;
  Usuario? _user;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Best-effort hybrid sync (F4). Offline / empty URLs are fine.
    await widget.syncService.syncAll();
    final user = await widget.authService.restoreSession();
    if (!mounted) return;
    setState(() {
      _user = user;
      _loading = false;
    });
  }

  void _onLoggedIn(Usuario user) {
    setState(() => _user = user);
  }

  Future<void> _logout() async {
    await widget.authService.logout();
    if (!mounted) return;
    setState(() => _user = null);
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (_user == null) {
      return LoginScreen(
        authService: widget.authService,
        onLoggedIn: _onLoggedIn,
      );
    }
    return CatalogoListScreen(
      repository: widget.catalogoRepository,
      syncService: widget.syncService,
      sessionUser: _user,
      onLogout: _logout,
    );
  }
}
