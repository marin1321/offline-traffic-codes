import 'dart:convert';

import 'package:codigos_transito/app.dart';
import 'package:codigos_transito/data/auth_service.dart';
import 'package:codigos_transito/data/catalogo_repository.dart';
import 'package:codigos_transito/data/device_id_service.dart';
import 'package:codigos_transito/data/json_fetcher.dart';
import 'package:codigos_transito/data/local_json_cache.dart';
import 'package:codigos_transito/data/models/catalogo.dart';
import 'package:codigos_transito/data/models/infraccion.dart';
import 'package:codigos_transito/data/session_store.dart';
import 'package:codigos_transito/data/sync_result.dart';
import 'package:codigos_transito/data/sync_service.dart';
import 'package:codigos_transito/data/usuarios_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeCatalogoRepo extends CatalogoRepository {
  _FakeCatalogoRepo()
      : super(
          seedAssetPath: 'fake',
          remoteUrl: '',
          localCache: MemoryLocalJsonCache(),
          fetcher: MapJsonFetcher(),
        );

  @override
  Future<Catalogo> load({bool forceReload = false}) async {
    return const Catalogo(
      version: 1,
      infracciones: [
        Infraccion(
          codigo: 'C.28',
          categoria: 'C',
          categoriaTitulo: 'Mayor cuantía',
          descripcion: 'Usar resonadores y dispositivos de ruido.',
        ),
      ],
    );
  }

  @override
  Future<SyncResult> sync() async => SyncResult.skipped();
}

class _FakeUsersBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final payload = jsonEncode({
      'version': 1,
      'usuarios': [
        {
          'usuario': 'oscar',
          'password': 'piloto123',
          'nombre': 'Piloto Test',
          'activo': true,
          'device_ids': ['dev-device-alpha'],
        },
      ],
    });
    final bytes = utf8.encode(payload);
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Login y catálogo tras auth OK', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    final usuarios = UsuariosRepository(
      seedAssetPath: 'fake',
      remoteUrl: '',
      bundle: _FakeUsersBundle(),
      localCache: MemoryLocalJsonCache(),
      fetcher: MapJsonFetcher(),
    );

    final catalogo = _FakeCatalogoRepo();
    final auth = AuthService(
      usuariosRepository: usuarios,
      deviceIdService: DeviceIdService(
        prefs: prefs,
        overrideId: 'dev-device-alpha',
      ),
      sessionStore: SessionStore(prefs: prefs),
    );

    await tester.pumpWidget(
      CodigosTransitoApp(
        catalogoRepository: catalogo,
        usuariosRepository: usuarios,
        authService: auth,
        syncService: SyncService(
          catalogoRepository: catalogo,
          usuariosRepository: usuarios,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Ingreso de agente'), findsOneWidget);
    expect(find.textContaining('dev-device-alpha'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), 'oscar');
    await tester.enterText(find.byType(TextField).at(1), 'piloto123');
    await tester.tap(find.text('Entrar'));
    await tester.pumpAndSettle();

    expect(find.text('C.28'), findsOneWidget);
    expect(find.text('Piloto Test'), findsOneWidget);
  });
}
