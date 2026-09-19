import 'package:http/http.dart' as http;

/// Fetches remote JSON text. Returns null on any failure (offline, 404, etc.).
abstract class JsonFetcher {
  Future<String?> get(String url);
}

class HttpJsonFetcher implements JsonFetcher {
  HttpJsonFetcher({
    http.Client? client,
    this.timeout = const Duration(seconds: 12),
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final Duration timeout;

  @override
  Future<String?> get(String url) async {
    final trimmed = url.trim();
    if (trimmed.isEmpty) return null;
    try {
      final response = await _client
          .get(Uri.parse(trimmed))
          .timeout(timeout);
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return response.body;
      }
      return null;
    } catch (_) {
      return null;
    }
  }
}

/// Test double: map of url → body (missing = fail).
class MapJsonFetcher implements JsonFetcher {
  MapJsonFetcher([this.responses = const {}]);

  final Map<String, String> responses;

  @override
  Future<String?> get(String url) async => responses[url];
}
