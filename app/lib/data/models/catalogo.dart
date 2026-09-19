import 'infraccion.dart';

/// Versioned catalog file (seed or remote JSON).
class Catalogo {
  const Catalogo({
    required this.version,
    required this.infracciones,
    this.actualizado,
    this.fuenteNota,
  });

  final int version;
  final List<Infraccion> infracciones;
  final String? actualizado;
  final String? fuenteNota;

  factory Catalogo.fromJson(Map<String, dynamic> json) {
    final raw = json['infracciones'] as List<dynamic>? ?? const [];
    return Catalogo(
      version: (json['version'] as num?)?.toInt() ?? 0,
      actualizado: json['actualizado'] as String?,
      fuenteNota: json['fuente_nota'] as String?,
      infracciones: raw
          .map((e) => Infraccion.fromJson(e as Map<String, dynamic>))
          .toList(growable: false),
    );
  }

  /// Unique categories in catalog order of first appearance.
  List<({String id, String titulo})> get categorias {
    final seen = <String>{};
    final out = <({String id, String titulo})>[];
    for (final i in infracciones) {
      if (seen.add(i.categoria)) {
        out.add((id: i.categoria, titulo: i.categoriaTitulo));
      }
    }
    return out;
  }

  List<Infraccion> porCategoria(String categoria) =>
      infracciones.where((i) => i.categoria == categoria).toList(growable: false);
}
