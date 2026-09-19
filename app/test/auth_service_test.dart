import 'dart:convert';

import 'package:codigos_transito/data/auth_service.dart';
import 'package:codigos_transito/data/device_id_service.dart';
import 'package:codigos_transito/data/json_fetcher.dart';
import 'package:codigos_transito/data/local_json_cache.dart';
import 'package:codigos_transito/data/session_store.dart';
import 'package:codigos_transito/data/usuarios_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthService auth;
  late SessionStore session;

  UsuariosRepository usersRepo(String json) {
    return UsuariosRepository(
      seedAssetPath: 'fake://usuarios.json',
      remoteUrl: '',
      bundle: _FakeBundle(json),
      localCache: MemoryLocalJsonCache(),
      fetcher: MapJsonFetcher(),
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    session = SessionStore(prefs: prefs);

    const seedJson = {
      'version': 1,
      'usuarios': [
        {
          'usuario': 'oscar',
          'password': 'piloto123',
          'nombre': 'Piloto',
          'activo': true,
          'device_ids': ['dev-device-alpha', 'dev-device-beta'],
        },
        {
          'usuario': 'revocado',
          'password': 'revocado',
          'nombre': 'Revocado',
          'activo': false,
          'device_ids': ['dev-device-alpha'],
        },
        {
          'usuario': 'sindevice',
          'password': 'sindevice',
          'nombre': 'Sin device',
          'activo': true,
          'device_ids': <String>[],
        },
      ],
    };

    auth = AuthService(
      usuariosRepository: usersRepo(jsonEncode(seedJson)),
      deviceIdService: DeviceIdService(
        prefs: prefs,
        overrideId: 'dev-device-alpha',
      ),
      sessionStore: session,
      enforceDeviceBinding: true,
    );
  });

  test('login OK con device autorizado', () async {
    final r = await auth.login(usuario: 'oscar', password: 'piloto123');
    expect(r.isOk, isTrue);
    expect(r.usuario!.nombre, 'Piloto');
    expect(await session.isLoggedIn, isTrue);
  });

  test('login es case-insensitive en el nombre de usuario', () async {
    final r = await auth.login(usuario: 'OSCAR', password: 'piloto123');
    expect(r.isOk, isTrue);
  });

  test('login OK con segundo device del mismo usuario', () async {
    final prefs = await SharedPreferences.getInstance();
    final authBeta = AuthService(
      usuariosRepository: usersRepo(jsonEncode({
        'version': 1,
        'usuarios': [
          {
            'usuario': 'oscar',
            'password': 'piloto123',
            'nombre': 'Piloto',
            'activo': true,
            'device_ids': ['dev-device-alpha', 'dev-device-beta'],
          },
        ],
      })),
      deviceIdService: DeviceIdService(prefs: prefs, overrideId: 'dev-device-beta'),
      sessionStore: SessionStore(prefs: prefs),
      enforceDeviceBinding: true,
    );
    final r = await authBeta.login(usuario: 'oscar', password: 'piloto123');
    expect(r.isOk, isTrue);
  });

  test('rechaza device no listado', () async {
    final prefs = await SharedPreferences.getInstance();
    final authOther = AuthService(
      usuariosRepository: usersRepo(jsonEncode({
        'version': 1,
        'usuarios': [
          {
            'usuario': 'oscar',
            'password': 'piloto123',
            'nombre': 'Piloto',
            'activo': true,
            'device_ids': ['dev-device-alpha'],
          },
        ],
      })),
      deviceIdService: DeviceIdService(prefs: prefs, overrideId: 'otro-telefono'),
      sessionStore: SessionStore(prefs: prefs),
      enforceDeviceBinding: true,
    );
    final r = await authOther.login(usuario: 'oscar', password: 'piloto123');
    expect(r.failure, AuthFailure.deviceNotAllowed);
  });

  test('rechaza usuario inactivo', () async {
    final r = await auth.login(usuario: 'revocado', password: 'revocado');
    expect(r.failure, AuthFailure.inactive);
  });

  test('rechaza sin device enrolado', () async {
    final r = await auth.login(usuario: 'sindevice', password: 'sindevice');
    expect(r.failure, AuthFailure.deviceNotAllowed);
  });

  test('rechaza password mala', () async {
    final r = await auth.login(usuario: 'oscar', password: 'wrong');
    expect(r.failure, AuthFailure.badPassword);
  });

  test('restoreSession respeta device y activo', () async {
    await auth.login(usuario: 'oscar', password: 'piloto123');
    final user = await auth.restoreSession();
    expect(user, isNotNull);
    await auth.logout();
    expect(await auth.restoreSession(), isNull);
  });

  test('sesión expira al cambiar el día local', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    var fakeNow = DateTime(2026, 9, 19, 10, 0);

    final session = SessionStore(prefs: prefs, now: () => fakeNow);
    final authDay = AuthService(
      usuariosRepository: usersRepo(jsonEncode({
        'version': 1,
        'usuarios': [
          {
            'usuario': 'oscar',
            'password': 'piloto123',
            'nombre': 'Piloto',
            'activo': true,
            'device_ids': ['dev-device-alpha'],
          },
        ],
      })),
      deviceIdService: DeviceIdService(
        prefs: prefs,
        overrideId: 'dev-device-alpha',
      ),
      sessionStore: session,
      enforceDeviceBinding: true,
    );

    final login = await authDay.login(
      usuario: 'oscar',
      password: 'piloto123',
    );
    expect(login.isOk, isTrue);
    expect(await authDay.restoreSession(), isNotNull);

    fakeNow = DateTime(2026, 9, 19, 23, 50);
    expect(await authDay.restoreSession(), isNotNull);

    fakeNow = DateTime(2026, 9, 20, 0, 5);
    expect(await authDay.restoreSession(), isNull);
    expect(await session.isLoggedIn, isFalse);
  });
}

class _FakeBundle extends CachingAssetBundle {
  _FakeBundle(this.payload);

  final String payload;

  @override
  Future<ByteData> load(String key) async {
    final bytes = utf8.encode(payload);
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }
}
