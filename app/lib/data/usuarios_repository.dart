import 'dart:convert';

import 'package:flutter/services.dart';

import '../core/remote_config.dart';
import 'json_fetcher.dart';
import 'local_json_cache.dart';
import 'models/usuarios_file.dart';
import 'sync_result.dart';

enum UsuariosSource { memory, local, seed, remote }

/// Hybrid users file: local cache + seed + optional remote (D-035).
class UsuariosRepository {
  UsuariosRepository({
    this.seedAssetPath = 'assets/data/usuarios_seed.json',
    this.remoteUrl = RemoteConfig.usuariosUrl,
    AssetBundle? bundle,
    LocalJsonCache? localCache,
    JsonFetcher? fetcher,
  })  : _bundle = bundle ?? rootBundle,
        _localCache = localCache ?? FileLocalJsonCache(),
        _fetcher = fetcher ?? HttpJsonFetcher();

  static const cacheKey = 'usuarios';

  final String seedAssetPath;
  final String remoteUrl;
  final AssetBundle _bundle;
  final LocalJsonCache _localCache;
  final JsonFetcher _fetcher;

  UsuariosFile? _cache;
  UsuariosSource _source = UsuariosSource.memory;

  UsuariosFile? get cached => _cache;
  UsuariosSource get source => _source;

  /// Local cache wins only if its version is >= seed. Newer seed in a new APK
  /// replaces a stale local copy (fixes enrolments added to seed after first run).
  Future<UsuariosFile> load({bool forceReload = false}) async {
    if (!forceReload && _cache != null) return _cache!;

    final seedRaw = await _bundle.loadString(seedAssetPath);
    final seed = UsuariosFile.fromJson(
      json.decode(seedRaw) as Map<String, dynamic>,
    );

    final localRaw = await _localCache.read(cacheKey);
    if (localRaw != null) {
      try {
        final local = UsuariosFile.fromJson(
          json.decode(localRaw) as Map<String, dynamic>,
        );
        if (local.version >= seed.version) {
          _cache = local;
          _source = UsuariosSource.local;
          return local;
        }
        // Seed in APK is newer than disk cache → promote seed.
      } catch (_) {
        await _localCache.delete(cacheKey);
      }
    }

    await _localCache.write(cacheKey, seedRaw);
    _cache = seed;
    _source = UsuariosSource.seed;
    return seed;
  }

  Future<UsuariosFile> loadSeed({bool forceReload = false}) =>
      load(forceReload: forceReload);

  Future<SyncResult> sync() async {
    final url = remoteUrl.trim();
    if (url.isEmpty) return SyncResult.skipped();

    final current = await load();
    final body = await _fetcher.get(url);
    if (body == null) {
      return SyncResult.failed('Sin red o URL de usuarios no disponible');
    }

    try {
      final remote = UsuariosFile.fromJson(
        json.decode(body) as Map<String, dynamic>,
      );
      if (remote.version > current.version) {
        await _localCache.write(cacheKey, body);
        _cache = remote;
        _source = UsuariosSource.remote;
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
      return SyncResult.failed('JSON de usuarios remoto inválido');
    }
  }
}
