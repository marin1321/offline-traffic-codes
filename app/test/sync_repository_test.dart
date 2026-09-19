import 'dart:convert';

import 'package:codigos_transito/data/catalogo_repository.dart';
import 'package:codigos_transito/data/json_fetcher.dart';
import 'package:codigos_transito/data/local_json_cache.dart';
import 'package:codigos_transito/data/sync_result.dart';
import 'package:codigos_transito/data/usuarios_repository.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const seedCatalogo = {
    'version': 1,
    'infracciones': [
      {
        'codigo': 'A.01',
        'categoria': 'A',
        'categoria_titulo': 'A',
        'descripcion': 'Uno',
      },
    ],
  };

  const remoteCatalogo = {
    'version': 2,
    'infracciones': [
      {
        'codigo': 'A.01',
        'categoria': 'A',
        'categoria_titulo': 'A',
        'descripcion': 'Uno',
      },
      {
        'codigo': 'D.01',
        'categoria': 'D',
        'categoria_titulo': 'Demo',
        'descripcion': 'Remoto',
      },
    ],
  };

  test('catalogo usa seed y cachea local', () async {
    final cache = MemoryLocalJsonCache();
    final repo = CatalogoRepository(
      seedAssetPath: 'fake://cat',
      remoteUrl: '',
      bundle: _FakeBundle(jsonEncode(seedCatalogo)),
      localCache: cache,
      fetcher: MapJsonFetcher(),
    );

    final cat = await repo.load();
    expect(cat.version, 1);
    expect(cat.infracciones.length, 1);
    expect(cache.store.containsKey(CatalogoRepository.cacheKey), isTrue);

    final again = await repo.load();
    expect(again.version, 1);
  });

  test('seed más nuevo reemplaza cache local vieja', () async {
    final cache = MemoryLocalJsonCache();
    await cache.write(
      UsuariosRepository.cacheKey,
      jsonEncode({
        'version': 1,
        'usuarios': [
          {
            'usuario': 'oscar',
            'password': 'piloto123',
            'nombre': 'Viejo',
            'activo': true,
            'device_ids': <String>[],
          },
        ],
      }),
    );

    final repo = UsuariosRepository(
      seedAssetPath: 'fake://users',
      remoteUrl: '',
      bundle: _FakeBundle(jsonEncode({
        'version': 3,
        'usuarios': [
          {
            'usuario': 'oscar',
            'password': 'piloto123',
            'nombre': 'Nuevo',
            'activo': true,
            'device_ids': ['4056aed5-5938-4a80-addc-46ccd55c3c6e'],
          },
        ],
      })),
      localCache: cache,
      fetcher: MapJsonFetcher(),
    );

    final file = await repo.load();
    expect(file.version, 3);
    expect(file.usuarios.first.deviceIds, contains('4056aed5-5938-4a80-addc-46ccd55c3c6e'));
  });

  test('catalogo sync actualiza si remoto es más nuevo', () async {
    const url = 'https://example.test/catalogo.json';
    final cache = MemoryLocalJsonCache();
    final repo = CatalogoRepository(
      seedAssetPath: 'fake://cat',
      remoteUrl: url,
      bundle: _FakeBundle(jsonEncode(seedCatalogo)),
      localCache: cache,
      fetcher: MapJsonFetcher({url: jsonEncode(remoteCatalogo)}),
    );

    final before = await repo.load();
    expect(before.version, 1);

    final result = await repo.sync();
    expect(result.status, SyncStatus.updated);
    expect(result.remoteVersion, 2);

    final after = await repo.load(forceReload: true);
    expect(after.version, 2);
    expect(after.infracciones.any((i) => i.codigo == 'D.01'), isTrue);
  });

  test('catalogo sync no baja versión', () async {
    const url = 'https://example.test/catalogo.json';
    final cache = MemoryLocalJsonCache();
    // Pre-seed local with v2
    await cache.write(CatalogoRepository.cacheKey, jsonEncode(remoteCatalogo));
    final repo = CatalogoRepository(
      seedAssetPath: 'fake://cat',
      remoteUrl: url,
      bundle: _FakeBundle(jsonEncode(seedCatalogo)),
      localCache: cache,
      fetcher: MapJsonFetcher({url: jsonEncode(seedCatalogo)}),
    );

    final result = await repo.sync();
    expect(result.status, SyncStatus.upToDate);
    final cat = await repo.load(forceReload: true);
    expect(cat.version, 2);
  });

  test('catalogo sync falla offline y conserva local', () async {
    const url = 'https://example.test/catalogo.json';
    final cache = MemoryLocalJsonCache();
    final repo = CatalogoRepository(
      seedAssetPath: 'fake://cat',
      remoteUrl: url,
      bundle: _FakeBundle(jsonEncode(seedCatalogo)),
      localCache: cache,
      fetcher: MapJsonFetcher(), // empty → fail
    );

    await repo.load();
    final result = await repo.sync();
    expect(result.status, SyncStatus.failed);
    final cat = await repo.load(forceReload: true);
    expect(cat.version, 1);
  });

  test('usuarios sync skipped sin URL', () async {
    final repo = UsuariosRepository(
      seedAssetPath: 'fake://users',
      remoteUrl: '',
      bundle: _FakeBundle(jsonEncode({
        'version': 1,
        'usuarios': [
          {
            'usuario': '1',
            'password': 'x',
            'nombre': 'A',
            'activo': true,
            'device_ids': ['d'],
          },
        ],
      })),
      localCache: MemoryLocalJsonCache(),
      fetcher: MapJsonFetcher(),
    );
    final r = await repo.sync();
    expect(r.status, SyncStatus.skipped);
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
