import 'usuario.dart';

/// Versioned users file (seed or remote).
class UsuariosFile {
  const UsuariosFile({
    required this.version,
    required this.usuarios,
    this.actualizado,
    this.nota,
  });

  final int version;
  final List<Usuario> usuarios;
  final String? actualizado;
  final String? nota;

  factory UsuariosFile.fromJson(Map<String, dynamic> json) {
    final raw = json['usuarios'] as List<dynamic>? ?? const [];
    return UsuariosFile(
      version: (json['version'] as num?)?.toInt() ?? 0,
      actualizado: json['actualizado'] as String?,
      nota: json['nota'] as String?,
      usuarios: raw
          .map((e) => Usuario.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  Usuario? findByUsuario(String usuario) {
    final needle = usuario.trim().toLowerCase();
    for (final u in usuarios) {
      if (u.usuario.toLowerCase() == needle) return u;
    }
    return null;
  }
}
