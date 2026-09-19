import 'package:codigos_transito/data/catalogo_repository.dart';
import 'package:codigos_transito/data/json_fetcher.dart';
import 'package:codigos_transito/data/local_json_cache.dart';
import 'package:codigos_transito/data/models/catalogo.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('load parsea version e infracciones del asset seed', () async {
    final repo = CatalogoRepository(
      remoteUrl: '',
      localCache: MemoryLocalJsonCache(),
      fetcher: MapJsonFetcher(),
    );
    final Catalogo cat = await repo.load();

    expect(cat.version, greaterThanOrEqualTo(1));
    expect(cat.infracciones, isNotEmpty);
    expect(cat.infracciones.length, 28);

    final codigos = cat.infracciones.map((i) => i.codigo).toSet();
    expect(codigos, contains('A.01'));
    expect(codigos, contains('C.28'));
    expect(codigos, contains('B.01'));

    final c28 = cat.infracciones.firstWhere((i) => i.codigo == 'C.28');
    expect(c28.categoria, 'C');
    expect(c28.descripcion.toLowerCase(), contains('resonador'));
  });

  test('load falla con asset inexistente', () async {
    final repo = CatalogoRepository(
      seedAssetPath: 'assets/data/no_existe.json',
      remoteUrl: '',
      localCache: MemoryLocalJsonCache(),
      fetcher: MapJsonFetcher(),
    );
    await expectLater(repo.load(), throwsA(isA<Error>()));
  });
}
