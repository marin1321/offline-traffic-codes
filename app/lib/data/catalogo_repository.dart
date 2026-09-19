import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/remote_config.dart';
import 'json_fetcher.dart';
import 'local_json_cache.dart';
import 'models/catalogo.dart';
import 'sync_result.dart';

enum CatalogoSource { memory, local, seed, remote }

/// Hybrid catalog: local cache + seed asset + optional remote JSON (D-023).
class CatalogoRepository {
  CatalogoRepository({
    this.seedAssetPath = 'assets/data/catalogo_seed.json',
    this.remoteUrl = RemoteConfig.catalogoUrl,
    AssetBundle? bundle,
    LocalJsonCache? localCache,
    JsonFetcher? fetcher,
  })  : _bundle = bundle ?? rootBundle,
        _localCache = localCache ?? FileLocalJsonCache(),
        _fetcher = fetcher ?? HttpJsonFetcher();

  static const cacheKey = 'catalogo';

  final String seedAssetPath;
  final String remoteUrl;
  final AssetBundle _bundle;
  final LocalJsonCache _localCache;
  final JsonFetcher _fetcher;

  Catalogo? _cache;
  CatalogoSource _source = CatalogoSource.memory;

  Catalogo? get cached => _cache;
  CatalogoSource get source => _source;

  /// Local wins only if version >= seed; newer APK seed replaces stale cache.
  Future<Catalogo> load({bool forceReload = false}) async {
    if (!forceReload && _cache != null) return _cache!;

    final seedRaw = await _bundle.loadString(seedAssetPath);
    final seed = Catalogo.fromJson(
      json.decode(seedRaw) as Map<String, dynamic>,
    );

    final localRaw = await _localCache.read(cacheKey);
    if (localRaw != null) {
      try {
        final local = Catalogo.fromJson(
          json.decode(localRaw) as Map<String, dynamic>,
        );
        if (local.version >= seed.version) {
          _cache = local;
          _source = CatalogoSource.local;
          return local;
        }
      } catch (_) {
        await _localCache.delete(cacheKey);
      }
    }

    await _localCache.write(cacheKey, seedRaw);
    _cache = seed;
    _source = CatalogoSource.seed;
    return seed;
  }

  Future<Catalogo> loadSeed({bool forceReload = false}) =>
      load(forceReload: forceReload);

  Future<SyncResult> sync() async {
    final url = remoteUrl.trim();
    if (url.isEmpty) return SyncResult.skipped();

    final current = await load();
    final body = await _fetcher.get(url);
    if (body == null) {
      return SyncResult.failed('Sin red o URL de catálogo no disponible');
    }

    try {
      final remote = Catalogo.fromJson(
        json.decode(body) as Map<String, dynamic>,
      );
      if (remote.version > current.version) {
        await _localCache.write(cacheKey, body);
        _cache = remote;
        _source = CatalogoSource.remote;
        return SyncResult.updated(
          localVersion: current.version,
          remoteVersion: remote.version,
        );
      }
      return SyncResult.upToDate(
        localVersion: current.version,
        remoteVersion: remote.version,
      );
    } catch (_) {
      return SyncResult.failed('JSON de catálogo remoto inválido');
    }
  }
}
