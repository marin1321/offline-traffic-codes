import 'package:codigos_transito/data/catalogo_search.dart';
import 'package:codigos_transito/data/models/infraccion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const items = [
    Infraccion(
      codigo: 'A.01',
      categoria: 'A',
      categoriaTitulo: 'No automotores',
      descripcion: 'No transitar por la derecha de la vía.',
    ),
    Infraccion(
      codigo: 'C.06',
      categoria: 'C',
      categoriaTitulo: 'Mayor cuantía',
      descripcion: 'No utilizar el cinturón de seguridad en los casos exigidos.',
    ),
    Infraccion(
      codigo: 'C.28',
      categoria: 'C',
      categoriaTitulo: 'Mayor cuantía',
      descripcion:
          'Usar resonadores, dispositivos productores de ruido, cornetas en perímetro urbano.',
    ),
    Infraccion(
      codigo: 'C.38',
      categoria: 'C',
      categoriaTitulo: 'Mayor cuantía',
      descripcion:
          'Usar teléfonos o sistemas móviles mientras se conduce, salvo manos libres.',
    ),
  ];

  test('c28 y variantes encuentran C.28 primero', () {
    for (final q in ['c28', 'C.28', 'C28', 'c 28', 'C-28']) {
      final r = CatalogoSearch.filter(items: items, query: q);
      expect(r, isNotEmpty, reason: 'query=$q');
      expect(r.first.codigo, 'C.28', reason: 'query=$q');
    }
  });

  test('resonador encuentra C.28', () {
    final r = CatalogoSearch.filter(items: items, query: 'resonador');
    expect(r.first.codigo, 'C.28');
  });

  test('cinturón con acento y sin acento', () {
    final con = CatalogoSearch.filter(items: items, query: 'cinturón');
    final sin = CatalogoSearch.filter(items: items, query: 'cinturon');
    expect(con.first.codigo, 'C.06');
    expect(sin.first.codigo, 'C.06');
  });

  test('filtro por categoría C', () {
    final r = CatalogoSearch.filter(
      items: items,
      query: '',
      categoria: 'C',
    );
    expect(r.every((i) => i.categoria == 'C'), isTrue);
    expect(r.length, 3);
  });

  test('categoría + búsqueda', () {
    final r = CatalogoSearch.filter(
      items: items,
      query: 'telefono',
      categoria: 'C',
    );
    expect(r.first.codigo, 'C.38');
  });

  test('sin resultados', () {
    final r = CatalogoSearch.filter(items: items, query: 'xyznoexiste');
    expect(r, isEmpty);
  });
}
