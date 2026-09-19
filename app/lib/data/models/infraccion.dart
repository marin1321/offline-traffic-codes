/// Single traffic infraction entry (D-028).
class Infraccion {
  const Infraccion({
    required this.codigo,
    required this.categoria,
    required this.categoriaTitulo,
    required this.descripcion,
    this.referencias = const [],
  });

  final String codigo;
  final String categoria;
  final String categoriaTitulo;
  final String descripcion;

  /// Associated articles / resolutions, e.g. `Art. 22`, `Res. 20`.
  final List<String> referencias;

  factory Infraccion.fromJson(Map<String, dynamic> json) {
    final rawRefs = json['referencias'] as List<dynamic>? ?? const [];
    return Infraccion(
      codigo: json['codigo'] as String,
      categoria: json['categoria'] as String,
      categoriaTitulo: json['categoria_titulo'] as String,
      descripcion: json['descripcion'] as String,
      referencias: rawRefs.map((e) => '$e'.trim()).where((e) => e.isNotEmpty).toList(
            growable: false,
          ),
    );
  }

  Map<String, dynamic> toJson() => {
        'codigo': codigo,
        'categoria': categoria,
        'categoria_titulo': categoriaTitulo,
        'descripcion': descripcion,
        if (referencias.isNotEmpty) 'referencias': referencias,
      };
}
