import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum AppThemeMode { cinemaRed, light }

class AppPalette {
  final Color background;
  final Color surface;
  final Color primary;
  final Color onPrimary;
  final Color textPrimary;
  final Color textSecondary;
  final Color error;

  const AppPalette({
    required this.background,
    required this.surface,
    required this.primary,
    required this.onPrimary,
    required this.textPrimary,
    required this.textSecondary,
    required this.error,
  });

  static const cinemaRed = AppPalette(
    background: Color(0xFF111114),
    surface: Color(0xFF1C1C21),
    primary: Color(0xFFE30613),
    onPrimary: Color(0xFFFFFFFF),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFE6E6EA),
    error: Color(0xFFE30613),
  );

  static const light = AppPalette(
    background: Color(0xFFFFFFFF),
    surface: Color(0xFFF3F3F5),
    primary: Color(0xFFE30613),
    onPrimary: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF111114),
    textSecondary: Color(0xFF55555B),
    error: Color(0xFFE30613),
  );
}

final appThemeModeProvider = StateProvider<AppThemeMode>((ref) => AppThemeMode.cinemaRed);

final appPaletteProvider = Provider<AppPalette>((ref) {
  final mode = ref.watch(appThemeModeProvider);
  switch (mode) {
    case AppThemeMode.cinemaRed:
      return AppPalette.cinemaRed;
    case AppThemeMode.light:
      return AppPalette.light;
  }
});
