import 'package:flutter/material.dart';
import 'wazn_colors.dart';

class WaznFonts {
  static const ui = 'IBM Plex Sans Arabic';
  static const logo = 'Aref Ruqaa';
  static const quran = 'Amiri';
}

class WaznRadii {
  static const card = 28.0;
  static const chip = 999.0;
  static const button = 28.0;
  static const tile = 20.0;
  static const field = 14.0;
  static const small = 11.0;
}

class WaznTheme {
  static ThemeData light() {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: WaznColors.emerald,
      onPrimary: WaznColors.sand,
      secondary: WaznColors.gold,
      onSecondary: WaznColors.ink,
      surface: WaznColors.sand,
      onSurface: WaznColors.ink,
      error: Color(0xFFB3261E),
      onError: Colors.white,
    );
    return _base(scheme, WaznColors.sand);
  }

  static ThemeData dark() {
    const scheme = ColorScheme(
      brightness: Brightness.dark,
      primary: WaznColors.gold,
      onPrimary: WaznColors.ink,
      secondary: WaznColors.oasis,
      onSecondary: WaznColors.sand,
      surface: WaznColors.emeraldNight,
      onSurface: WaznColors.sand,
      error: Color(0xFFFFB4AB),
      onError: Color(0xFF690005),
    );
    return _base(scheme, WaznColors.emeraldNight);
  }

  static ThemeData _base(ColorScheme scheme, Color bg) {
    final isDark = scheme.brightness == Brightness.dark;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: bg,
      fontFamily: WaznFonts.ui,
      textTheme: _textTheme(isDark),
      splashFactory: InkSparkle.splashFactory,
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        foregroundColor: isDark ? WaznColors.sand : WaznColors.ink,
        titleTextStyle: TextStyle(
          fontFamily: WaznFonts.ui,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark ? WaznColors.sand : WaznColors.ink,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(WaznRadii.button)),
          textStyle: const TextStyle(
              fontFamily: WaznFonts.ui,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ),
      ),
      segmentedButtonTheme: const SegmentedButtonThemeData(
        style: ButtonStyle(
          textStyle: WidgetStatePropertyAll(TextStyle(
              fontFamily: WaznFonts.ui,
              fontWeight: FontWeight.w600,
              fontSize: 14)),
        ),
      ),
    );
  }

  static TextTheme _textTheme(bool isDark) {
    final c = isDark ? WaznColors.sand : WaznColors.ink;
    return TextTheme(
      displayLarge: TextStyle(
          fontFamily: WaznFonts.ui,
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: c),
      headlineMedium: TextStyle(
          fontFamily: WaznFonts.ui,
          fontSize: 26,
          fontWeight: FontWeight.w700,
          color: c),
      titleLarge: TextStyle(
          fontFamily: WaznFonts.ui,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: c),
      titleMedium: TextStyle(
          fontFamily: WaznFonts.ui,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: c),
      bodyLarge: TextStyle(
          fontFamily: WaznFonts.ui, fontSize: 15, color: c, height: 1.6),
      bodyMedium: TextStyle(
          fontFamily: WaznFonts.ui, fontSize: 14, color: c, height: 1.6),
      labelLarge: TextStyle(
          fontFamily: WaznFonts.ui,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: c),
    );
  }
}
