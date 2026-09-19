import 'package:shared_preferences/shared_preferences.dart';

/// Local session after successful login.
///
/// Policy (D-036): valid only for the **calendar day** of the last login
/// (device local timezone). Next day → must log in again.
class SessionStore {
  SessionStore({
    SharedPreferences? prefs,
    DateTime Function()? now,
  })  : _prefs = prefs,
        _now = now ?? DateTime.now;

  static const _usuarioKey = 'session_usuario';
  static const _nombreKey = 'session_nombre';
  /// Local calendar day of last successful login: `yyyy-MM-dd`.
  static const _loginDayKey = 'session_login_day';

  SharedPreferences? _prefs;
  final DateTime Function() _now;

  Future<SharedPreferences> _ensurePrefs() async {
    return _prefs ??= await SharedPreferences.getInstance();
  }

  /// `yyyy-MM-dd` in the device local timezone.
  static String dayKey(DateTime dt) {
    final local = dt.toLocal();
    final y = local.year.toString().padLeft(4, '0');
    final m = local.month.toString().padLeft(2, '0');
    final d = local.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  String get todayKey => dayKey(_now());

  Future<bool> get isLoggedIn async {
    final prefs = await _ensurePrefs();
    final u = prefs.getString(_usuarioKey);
    if (u == null || u.isEmpty) return false;
    return isSessionDayValid(prefs);
  }

  /// True if stored login day is still "today".
  bool isSessionDayValid([SharedPreferences? prefs]) {
    final p = prefs ?? _prefs;
    if (p == null) return false;
    final day = p.getString(_loginDayKey);
    if (day == null || day.isEmpty) return false;
    return day == todayKey;
  }

  Future<String?> get usuario async {
    final prefs = await _ensurePrefs();
    if (!isSessionDayValid(prefs)) return null;
    return prefs.getString(_usuarioKey);
  }

  Future<String?> get nombre async {
    final prefs = await _ensurePrefs();
    if (!isSessionDayValid(prefs)) return null;
    return prefs.getString(_nombreKey);
  }

  Future<String?> get loginDay async {
    final prefs = await _ensurePrefs();
    return prefs.getString(_loginDayKey);
  }

  Future<void> saveSession({
    required String usuario,
    required String nombre,
  }) async {
    final prefs = await _ensurePrefs();
    await prefs.setString(_usuarioKey, usuario);
    await prefs.setString(_nombreKey, nombre);
    await prefs.setString(_loginDayKey, todayKey);
  }

  Future<void> clear() async {
    final prefs = await _ensurePrefs();
    await prefs.remove(_usuarioKey);
    await prefs.remove(_nombreKey);
    await prefs.remove(_loginDayKey);
    // Drop legacy key if present.
    await prefs.remove('session_cedula');
  }
}
