import 'catalogo_repository.dart';
import 'sync_result.dart';
import 'usuarios_repository.dart';

class CombinedSyncResult {
  const CombinedSyncResult({
    required this.catalogo,
    required this.usuarios,
  });

  final SyncResult catalogo;
  final SyncResult usuarios;

  bool get anyUpdated => catalogo.didUpdate || usuarios.didUpdate;
}

/// Coordinates best-effort hybrid sync (F4).
class SyncService {
  SyncService({
    required CatalogoRepository catalogoRepository,
    required UsuariosRepository usuariosRepository,
  })  : _catalogo = catalogoRepository,
        _usuarios = usuariosRepository;

  final CatalogoRepository _catalogo;
  final UsuariosRepository _usuarios;

  Future<SyncResult> syncCatalogo() => _catalogo.sync();

  Future<SyncResult> syncUsuarios() => _usuarios.sync();

  Future<CombinedSyncResult> syncAll() async {
    final cat = await _catalogo.sync();
    final users = await _usuarios.sync();
    return CombinedSyncResult(catalogo: cat, usuarios: users);
  }
}
