import 'package:flutter/foundation.dart';

import 'device_id_service.dart';
import 'models/usuario.dart';
import 'session_store.dart';
import 'usuarios_repository.dart';

enum AuthFailure {
  emptyFields,
  unknownUser,
  badPassword,
  inactive,
  deviceNotAllowed,
  loadError,
}

class AuthResult {
  const AuthResult.ok(this.usuario) : failure = null;
  const AuthResult.fail(this.failure) : usuario = null;

  final Usuario? usuario;
  final AuthFailure? failure;

  bool get isOk => usuario != null;
}

/// Validates usuario + password + device_id (D-019 / D-034).
/// Session lasts until end of local calendar day (D-036).
///
/// **Debug builds only:** if usuario/clave/activo OK, device_id does not block.
/// Release stays strict with device_ids.
class AuthService {
  AuthService({
    required UsuariosRepository usuariosRepository,
    required DeviceIdService deviceIdService,
    required SessionStore sessionStore,
    /// When null: skip device check in debug builds only.
    /// Tests pass `true` to assert release-like binding.
    bool? enforceDeviceBinding,
  })  : _usuarios = usuariosRepository,
        _devices = deviceIdService,
        _session = sessionStore,
        _enforceDeviceBinding = enforceDeviceBinding ?? !kDebugMode;

  final UsuariosRepository _usuarios;
  final DeviceIdService _devices;
  final SessionStore _session;
  final bool _enforceDeviceBinding;

  Future<String> deviceId() => _devices.getDeviceId();

  bool _deviceOk(Usuario user, String deviceId) {
    if (user.allowsDevice(deviceId)) return true;
    if (!_enforceDeviceBinding) return true;
    return false;
  }

  Future<AuthResult> login({
    required String usuario,
    required String password,
  }) async {
    final u = usuario.trim();
    final p = password;
    if (u.isEmpty || p.isEmpty) {
      return const AuthResult.fail(AuthFailure.emptyFields);
    }

    try {
      await _usuarios.sync();
      final file = await _usuarios.load(forceReload: true);
      final user = file.findByUsuario(u);
      if (user == null) {
        return const AuthResult.fail(AuthFailure.unknownUser);
      }
      if (user.password != p) {
        return const AuthResult.fail(AuthFailure.badPassword);
      }
      if (!user.activo) {
        return const AuthResult.fail(AuthFailure.inactive);
      }
      final deviceId = await _devices.getDeviceId();
      if (!_deviceOk(user, deviceId)) {
        return const AuthResult.fail(AuthFailure.deviceNotAllowed);
      }
      await _session.saveSession(usuario: user.usuario, nombre: user.nombre);
      return AuthResult.ok(user);
    } catch (_) {
      return const AuthResult.fail(AuthFailure.loadError);
    }
  }

  Future<Usuario?> restoreSession() async {
    if (!await _session.isLoggedIn) {
      await _session.clear();
      return null;
    }
    final usuario = await _session.usuario;
    if (usuario == null) {
      await _session.clear();
      return null;
    }
    try {
      await _usuarios.sync();
      final file = await _usuarios.load(forceReload: true);
      final user = file.findByUsuario(usuario);
      if (user == null || !user.activo) {
        await _session.clear();
        return null;
      }
      final deviceId = await _devices.getDeviceId();
      if (!_deviceOk(user, deviceId)) {
        await _session.clear();
        return null;
      }
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<void> logout() => _session.clear();

  static String messageFor(AuthFailure f) {
    switch (f) {
      case AuthFailure.emptyFields:
        return 'Ingresa usuario y contraseña.';
      case AuthFailure.unknownUser:
        return 'Usuario no encontrado.';
      case AuthFailure.badPassword:
        return 'Contraseña incorrecta.';
      case AuthFailure.inactive:
        return 'Usuario inactivo o revocado.';
      case AuthFailure.deviceNotAllowed:
        return 'Este teléfono no está autorizado para ese usuario. '
            'Copia el «código de este teléfono» de abajo y envíaselo al administrador.';
      case AuthFailure.loadError:
        return 'No se pudo cargar la lista de usuarios.';
    }
  }
}
