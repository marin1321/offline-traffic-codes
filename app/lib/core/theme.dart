import 'package:flutter/material.dart';

/// Visual baseline — simple, readable in field conditions.
class AppTheme {
  static const Color seed = Color(0xFF0B3D91);

  static ThemeData get light {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ),
      useMaterial3: true,
    );
    return base.copyWith(
      appBarTheme: AppBarTheme(
        backgroundColor: base.colorScheme.primary,
        foregroundColor: base.colorScheme.onPrimary,
        centerTitle: false,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
