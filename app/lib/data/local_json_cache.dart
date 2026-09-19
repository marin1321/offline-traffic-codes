import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Persists JSON payloads on device (hybrid offline copy).
abstract class LocalJsonCache {
  Future<String?> read(String key);
  Future<void> write(String key, String contents);
  Future<void> delete(String key);
}

/// File-based cache under app documents.
class FileLocalJsonCache implements LocalJsonCache {
  FileLocalJsonCache({this.rootOverride});

  final Directory? rootOverride;

  Future<Directory> _dir() async {
    if (rootOverride != null) return rootOverride as Directory;
    final base = await getApplicationDocumentsDirectory();
    final dir = Directory('${base.path}/json_cache');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> _file(String key) async {
    final safe = key.replaceAll(RegExp(r'[^a-zA-Z0-9_\-]'), '_');
    final dir = await _dir();
    return File('${dir.path}/$safe.json');
  }

  @override
  Future<String?> read(String key) async {
    try {
      final f = await _file(key);
      if (!await f.exists()) return null;
      return await f.readAsString();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> write(String key, String contents) async {
    final f = await _file(key);
    await f.writeAsString(contents, flush: true);
  }

  @override
  Future<void> delete(String key) async {
    try {
      final f = await _file(key);
      if (await f.exists()) await f.delete();
    } catch (_) {}
  }
}

/// In-memory cache for unit tests.
class MemoryLocalJsonCache implements LocalJsonCache {
  final Map<String, String> store = {};

  @override
  Future<String?> read(String key) async => store[key];

  @override
  Future<void> write(String key, String contents) async {
    store[key] = contents;
  }

  @override
  Future<void> delete(String key) async {
    store.remove(key);
  }
}
