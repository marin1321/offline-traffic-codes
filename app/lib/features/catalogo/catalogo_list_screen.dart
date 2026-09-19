import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../data/catalogo_repository.dart';
import '../../data/catalogo_search.dart';
import '../../data/models/catalogo.dart';
import '../../data/models/infraccion.dart';
import '../../data/models/usuario.dart';
import '../../data/sync_result.dart';
import '../../data/sync_service.dart';
import '../shell/about_screen.dart';

/// Catalog list with category filter + search (F3) + hybrid sync (F4).
class CatalogoListScreen extends StatefulWidget {
  const CatalogoListScreen({
    super.key,
    required this.repository,
    this.syncService,
    this.sessionUser,
    this.onLogout,
  });

  final CatalogoRepository repository;
  final SyncService? syncService;
  final Usuario? sessionUser;
  final Future<void> Function()? onLogout;

  @override
  State<CatalogoListScreen> createState() => _CatalogoListScreenState();
}

class _CatalogoListScreenState extends State<CatalogoListScreen> {
  late Future<Catalogo> _future;
  final _searchCtrl = TextEditingController();
  final _searchFocus = FocusNode();

  /// null = todas las categorías
  String? _categoriaFiltro;
  String _query = '';
  bool _syncing = false;

  @override
  void initState() {
    super.initState();
    _future = widget.repository.load();
    _searchCtrl.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final next = _searchCtrl.text;
    if (next == _query) return;
    setState(() => _query = next);
  }

  Future<void> _reload() async {
    setState(() {
      _future = widget.repository.load(forceReload: true);
    });
    await _future;
  }

  Future<void> _syncNow({bool silent = false}) async {
    final sync = widget.syncService;
    if (sync == null) {
      await _reload();
      return;
    }
    if (_syncing) return;
    setState(() => _syncing = true);
    final result = await sync.syncAll();
    await _reload();
    if (!mounted) return;
    setState(() => _syncing = false);
    if (silent) return;

    final cat = result.catalogo;
    final users = result.usuarios;
    final parts = <String>[];
    if (cat.didUpdate) {
      parts.add('Catálogo ${cat.message}');
    } else if (cat.status == SyncStatus.failed) {
      parts.add('Catálogo: sin red');
    }
    if (users.didUpdate) {
      parts.add('Usuarios ${users.message}');
    } else if (users.status == SyncStatus.failed) {
      parts.add('Usuarios: sin red');
    }
    if (parts.isEmpty) {
      if (cat.status == SyncStatus.skipped &&
          users.status == SyncStatus.skipped) {
        parts.add('Sync no configurado (sin URLs remotas)');
      } else {
        parts.add('Todo al día');
      }
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(parts.join(' · '))),
    );
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_onSearchChanged);
    _searchCtrl.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          if (widget.syncService != null)
            IconButton(
              tooltip: 'Actualizar datos',
              onPressed: _syncing ? null : () => _syncNow(),
              icon: _syncing
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.sync),
            ),
          IconButton(
            tooltip: 'Acerca de',
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AboutScreen(),
                ),
              );
            },
          ),
          if (widget.onLogout != null)
            IconButton(
              tooltip: 'Cerrar sesión',
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final ok = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Cerrar sesión'),
                    content: const Text(
                      '¿Salir de la cuenta en este teléfono?',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancelar'),
                      ),
                      FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Salir'),
                      ),
                    ],
                  ),
                );
                if (ok == true) await widget.onLogout?.call();
              },
            ),
        ],
      ),
      body: FutureBuilder<Catalogo>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return _ErrorBody(
              error: snapshot.error!,
              onRetry: _reload,
            );
          }
          final catalogo = snapshot.data!;
          final filtered = CatalogoSearch.filter(
            items: catalogo.infracciones,
            query: _query,
            categoria: _categoriaFiltro,
          );

          return RefreshIndicator(
            onRefresh: () => _syncNow(silent: true),
            child: CustomScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: _Header(
                      catalogo: catalogo,
                      sessionUser: widget.sessionUser,
                      visibleCount: filtered.length,
                      hasActiveFilter:
                          _query.trim().isNotEmpty || _categoriaFiltro != null,
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                    child: TextField(
                      controller: _searchCtrl,
                      focusNode: _searchFocus,
                      textInputAction: TextInputAction.search,
                      keyboardType: TextInputType.text,
                      autocorrect: false,
                      decoration: InputDecoration(
                        labelText: 'Buscar',
                        hintText: 'Código o palabra (ej. c28, resonador)',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _query.isEmpty
                            ? null
                            : IconButton(
                                tooltip: 'Limpiar',
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchCtrl.clear();
                                  _searchFocus.requestFocus();
                                },
                              ),
                      ),
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 48,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: FilterChip(
                            label: const Text('Todas'),
                            selected: _categoriaFiltro == null,
                            onSelected: (_) {
                              setState(() => _categoriaFiltro = null);
                            },
                          ),
                        ),
                        for (final cat in catalogo.categorias)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: FilterChip(
                              label: Text(cat.id),
                              selected: _categoriaFiltro == cat.id,
                              tooltip: cat.titulo,
                              onSelected: (selected) {
                                setState(() {
                                  _categoriaFiltro =
                                      selected ? cat.id : null;
                                });
                              },
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                if (filtered.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text(
                          'Sin resultados.\nPrueba otro código o palabra.',
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                else if (_query.trim().isNotEmpty)
                  // Flat ranked list when searching (best matches first).
                  SliverList.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, indent: 16),
                    itemBuilder: (context, index) {
                      final item = filtered[index];
                      return _InfraccionTile(
                        item: item,
                        onTap: () => _showDetail(context, item),
                      );
                    },
                  )
                else ...[
                  // Grouped by category when not searching.
                  for (final cat in catalogo.categorias) ...[
                    if (_categoriaFiltro == null ||
                        _categoriaFiltro == cat.id) ...[
                      Builder(
                        builder: (context) {
                          final items = filtered
                              .where((i) => i.categoria == cat.id)
                              .toList(growable: false);
                          if (items.isEmpty) {
                            return const SliverToBoxAdapter(
                              child: SizedBox.shrink(),
                            );
                          }
                          return SliverMainAxisGroup(
                            slivers: [
                              SliverToBoxAdapter(
                                child: _CategoryHeader(
                                  id: cat.id,
                                  titulo: cat.titulo,
                                  count: items.length,
                                ),
                              ),
                              SliverList.separated(
                                itemCount: items.length,
                                separatorBuilder: (context, index) =>
                                    const Divider(height: 1, indent: 16),
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  return _InfraccionTile(
                                    item: item,
                                    onTap: () => _showDetail(context, item),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ],
                ],
                const SliverToBoxAdapter(child: SizedBox(height: 24)),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showDetail(BuildContext context, Infraccion item) {
    final theme = Theme.of(context);
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            8,
            24,
            24 + MediaQuery.paddingOf(context).bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.codigo,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${item.categoria} — ${item.categoriaTitulo}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  'Descripción',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  item.descripcion,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 20),
                Text(
                  'Artículos / resoluciones',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                if (item.referencias.isEmpty)
                  Text(
                    'Sin referencias registradas para este código.',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final ref in item.referencias)
                        Chip(
                          label: Text(ref),
                          visualDensity: VisualDensity.compact,
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                        ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

}

class _InfraccionTile extends StatelessWidget {
  const _InfraccionTile({required this.item, required this.onTap});

  final Infraccion item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        item.codigo,
        style: const TextStyle(fontWeight: FontWeight.w700),
      ),
      subtitle: Text(item.descripcion),
      isThreeLine: item.descripcion.length > 80,
      onTap: onTap,
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.catalogo,
    required this.visibleCount,
    required this.hasActiveFilter,
    this.sessionUser,
  });

  final Catalogo catalogo;
  final int visibleCount;
  final bool hasActiveFilter;
  final Usuario? sessionUser;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = catalogo.infracciones.length;
    final countLabel = hasActiveFilter
        ? '$visibleCount de $total códigos'
        : '$total códigos · seed v${catalogo.version}'
            '${catalogo.actualizado != null ? ' · ${catalogo.actualizado}' : ''}';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (sessionUser != null) ...[
          Text(
            sessionUser!.nombre.isEmpty
                ? sessionUser!.usuario
                : sessionUser!.nombre,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
        ],
        Text(
          'Catálogo de infracciones',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          countLabel,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        if (!hasActiveFilter && catalogo.fuenteNota != null) ...[
          const SizedBox(height: 8),
          Text(
            catalogo.fuenteNota!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }
}

class _CategoryHeader extends StatelessWidget {
  const _CategoryHeader({
    required this.id,
    required this.titulo,
    required this.count,
  });

  final String id;
  final String titulo;
  final int count;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      color: theme.colorScheme.surfaceContainerHighest,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Text(
        '$id — $titulo ($count)',
        style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class _ErrorBody extends StatelessWidget {
  const _ErrorBody({required this.error, required this.onRetry});

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48),
            const SizedBox(height: 12),
            Text(
              'No se pudo cargar el catálogo seed.',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$error',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: onRetry,
              child: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
