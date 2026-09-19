enum SyncStatus {
  /// No URL configured.
  skipped,
  /// Network/parse failure; kept previous local/seed.
  failed,
  /// Remote version not greater than local.
  upToDate,
  /// Local cache replaced with newer remote.
  updated,
}

class SyncResult {
  const SyncResult({
    required this.status,
    this.localVersion,
    this.remoteVersion,
    this.message,
  });

  final SyncStatus status;
  final int? localVersion;
  final int? remoteVersion;
  final String? message;

  bool get didUpdate => status == SyncStatus.updated;

  factory SyncResult.skipped([String? message]) => SyncResult(
        status: SyncStatus.skipped,
        message: message ?? 'Sin URL remota configurada',
      );

  factory SyncResult.failed([String? message]) => SyncResult(
        status: SyncStatus.failed,
        message: message ?? 'No se pudo sincronizar',
      );

  factory SyncResult.upToDate({int? localVersion, int? remoteVersion}) =>
      SyncResult(
        status: SyncStatus.upToDate,
        localVersion: localVersion,
        remoteVersion: remoteVersion,
        message: 'Ya está actualizado',
      );

  factory SyncResult.updated({
    required int localVersion,
    required int remoteVersion,
  }) =>
      SyncResult(
        status: SyncStatus.updated,
        localVersion: localVersion,
        remoteVersion: remoteVersion,
        message: 'Actualizado v$localVersion → v$remoteVersion',
      );
}
