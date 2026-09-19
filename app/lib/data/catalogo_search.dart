import 'models/infraccion.dart';

/// Offline catalog search (D-030): code + description, Spanish-friendly.
class CatalogoSearch {
  CatalogoSearch._();

  /// Lowercase, strip accents, collapse non-alphanumerics for code matching.
  static String normalize(String input) {
    final lower = input.toLowerCase().trim();
    final buf = StringBuffer();
    for (final rune in lower.runes) {
      final ch = String.fromCharCode(rune);
      final mapped = _accentMap[ch] ?? ch;
      if (_isAsciiLetterOrDigit(mapped)) {
        buf.write(mapped);
      }
      // spaces/punctuation dropped for code-style match; for text we also
      // keep a spaced variant via [normalizeWords].
    }
    return buf.toString();
  }

  /// Like [normalize] but keeps single spaces between tokens.
  static String normalizeWords(String input) {
    final lower = input.toLowerCase().trim();
    final buf = StringBuffer();
    var lastSpace = false;
    for (final rune in lower.runes) {
      final ch = String.fromCharCode(rune);
      final mapped = _accentMap[ch] ?? ch;
      if (_isAsciiLetterOrDigit(mapped)) {
        buf.write(mapped);
        lastSpace = false;
      } else if (!lastSpace && buf.isNotEmpty) {
        buf.write(' ');
        lastSpace = true;
      }
    }
    return buf.toString().trim();
  }

  static bool _isAsciiLetterOrDigit(String ch) {
    if (ch.isEmpty) return false;
    final c = ch.codeUnitAt(0);
    return (c >= 48 && c <= 57) || (c >= 97 && c <= 122);
  }

  static const _accentMap = <String, String>{
    'á': 'a',
    'à': 'a',
    'ä': 'a',
    'â': 'a',
    'ã': 'a',
    'é': 'e',
    'è': 'e',
    'ë': 'e',
    'ê': 'e',
    'í': 'i',
    'ì': 'i',
    'ï': 'i',
    'î': 'i',
    'ó': 'o',
    'ò': 'o',
    'ö': 'o',
    'ô': 'o',
    'õ': 'o',
    'ú': 'u',
    'ù': 'u',
    'ü': 'u',
    'û': 'u',
    'ñ': 'n',
    'ç': 'c',
  };

  /// Score > 0 means match. Higher = better (code hits rank first).
  static int score(Infraccion item, String query) {
    final q = query.trim();
    if (q.isEmpty) return 1;

    final qCode = normalize(q);
    final qWords = normalizeWords(q);
    if (qCode.isEmpty && qWords.isEmpty) return 1;

    final codeNorm = normalize(item.codigo);
    final catNorm = normalize(item.categoria);
    final descWords = normalizeWords(item.descripcion);
    final descCompact = normalize(item.descripcion);

    var s = 0;

    // Exact / prefix code (c28, C.28, c 28 → c28)
    if (qCode.isNotEmpty) {
      if (codeNorm == qCode) {
        s += 1000;
      } else if (codeNorm.startsWith(qCode) || qCode.startsWith(codeNorm)) {
        s += 800;
      } else if (codeNorm.contains(qCode)) {
        s += 600;
      }
      // Category letter alone: "c" or "C"
      if (qCode == catNorm) {
        s += 200;
      }
    }

    // Description: all query tokens must appear (order-independent).
    if (qWords.isNotEmpty) {
      final tokens = qWords.split(' ').where((t) => t.isNotEmpty).toList();
      if (tokens.isNotEmpty) {
        final allInDesc = tokens.every(
          (t) => descWords.contains(t) || descCompact.contains(t),
        );
        if (allInDesc) {
          s += 400;
          // Bonus if first token is early / full phrase-ish
          if (descWords.contains(qWords)) s += 100;
        }
      }
    }

    return s;
  }

  static List<Infraccion> filter({
    required List<Infraccion> items,
    String query = '',
    String? categoria,
  }) {
    final q = query.trim();
    Iterable<Infraccion> it = items;
    if (categoria != null && categoria.isNotEmpty) {
      it = it.where((i) => i.categoria == categoria);
    }
    if (q.isEmpty) {
      return it.toList(growable: false);
    }

    final ranked = <({Infraccion item, int score})>[];
    for (final item in it) {
      final sc = score(item, q);
      if (sc > 0) ranked.add((item: item, score: sc));
    }
    ranked.sort((a, b) {
      final byScore = b.score.compareTo(a.score);
      if (byScore != 0) return byScore;
      return a.item.codigo.compareTo(b.item.codigo);
    });
    return ranked.map((e) => e.item).toList(growable: false);
  }
}
