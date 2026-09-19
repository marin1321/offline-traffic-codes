import 'package:shared_preferences/shared_preferences.dart';

/// Persistent installation id (D-034). Not IMEI. Not IP.
///
/// Override for tests / demo:
/// `flutter run --dart-define=DEVICE_ID_OVERRIDE=dev-device-alpha`
class DeviceIdService {
  DeviceIdService({
    SharedPreferences? prefs,
    String? Function()? uuidFactory,
    String? overrideId,
  })  : _prefs = prefs,
        _uuidFactory = uuidFactory ?? _defaultUuid,
        _overrideId = overrideId ??
            const String.fromEnvironment('DEVICE_ID_OVERRIDE', defaultValue: '');

  static const _prefsKey = 'device_installation_id';

  SharedPreferences? _prefs;
  final String? Function() _uuidFactory;
  final String _overrideId;

  Future<SharedPreferences> _ensurePrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  /// Returns the stable id for this install (creates one on first call).
  Future<String> getDeviceId() async {
    if (_overrideId.isNotEmpty) return _overrideId;
    final prefs = await _ensurePrefs();
    final existing = prefs.getString(_prefsKey);
    if (existing != null && existing.isNotEmpty) return existing;
    final created = _uuidFactory();
    if (created == null || created.isEmpty) {
      throw StateError('No se pudo generar device_id');
    }
    await prefs.setString(_prefsKey, created);
    return created;
  }

  static String _defaultUuid() {
    // RFC4122-ish v4 without extra package dependency.
    final r = List<int>.generate(16, (_) => _nextByte());
    r[6] = (r[6] & 0x0f) | 0x40;
    r[8] = (r[8] & 0x3f) | 0x80;
    String h(int b) => b.toRadixString(16).padLeft(2, '0');
    final p = r.map(h).join();
    return '${p.substring(0, 8)}-${p.substring(8, 12)}-'
        '${p.substring(12, 16)}-${p.substring(16, 20)}-${p.substring(20)}';
  }

  static int _seed = DateTime.now().microsecondsSinceEpoch;
  static int _nextByte() {
    _seed = (_seed * 1103515245 + 12345) & 0x7fffffff;
    return (_seed >> 16) & 0xff;
  }
}
