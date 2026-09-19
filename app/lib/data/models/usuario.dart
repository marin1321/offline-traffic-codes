/// Agent account entry (D-019 / D-034). Login id is [usuario], not a national ID.
class Usuario {
  const Usuario({
    required this.usuario,
    required this.password,
    required this.nombre,
    required this.activo,
    required this.deviceIds,
  });

  /// Login name, e.g. `admin`, `oscar`.
  final String usuario;
  final String password;
  final String nombre;
  final bool activo;
  final List<String> deviceIds;

  factory Usuario.fromJson(Map<String, dynamic> json) {
    final rawIds = json['device_ids'] as List<dynamic>? ?? const [];
    // Accept legacy "cedula" key so old caches still parse once.
    final rawUser = json['usuario'] ?? json['cedula'] ?? '';
    return Usuario(
      usuario: '$rawUser'.trim(),
      password: '${json['password']}',
      nombre: (json['nombre'] as String?) ?? '',
      activo: json['activo'] as bool? ?? false,
      deviceIds: rawIds.map((e) => '$e').toList(growable: false),
    );
  }

  bool allowsDevice(String deviceId) => deviceIds.contains(deviceId);

  Map<String, dynamic> toJson() => {
        'usuario': usuario,
        'password': password,
        'nombre': nombre,
        'activo': activo,
        'device_ids': deviceIds,
      };
}
