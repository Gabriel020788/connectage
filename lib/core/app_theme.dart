import 'package:flutter/material.dart';

import 'brand_colors.dart';

class AppTheme {
  static ThemeData get light {
    const scheme = ColorScheme(
      brightness: Brightness.light,
      primary: BrandColors.blue,
      onPrimary: Colors.white,
      primaryContainer: BrandColors.blueSoft,
      onPrimaryContainer: BrandColors.blueStrong,
      secondary: BrandColors.orange,
      onSecondary: Colors.white,
      secondaryContainer: BrandColors.orangeSoft,
      onSecondaryContainer: BrandColors.orangeStrong,
      tertiary: BrandColors.blueLight,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFEAF4FF),
      onTertiaryContainer: BrandColors.blueStrong,
      error: Color(0xFFB3261E),
      onError: Colors.white,
      errorContainer: Color(0xFFF9DEDC),
      onErrorContainer: Color(0xFF410E0B),
      surface: BrandColors.surface,
      onSurface: BrandColors.text,
      surfaceContainerHighest: Color(0xFFF0F5FA),
      onSurfaceVariant: BrandColors.textMuted,
      outline: BrandColors.border,
      outlineVariant: Color(0xFFE8EEF4),
      shadow: Color(0x22034F9E),
      scrim: Colors.black,
      inverseSurface: BrandColors.text,
      onInverseSurface: Colors.white,
      inversePrimary: Color(0xFF9CC8F5),
    );

    final base = ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: BrandColors.background,
      fontFamilyFallback: const ['Arial', 'Roboto'],
    );

    return base.copyWith(
      textTheme: base.textTheme.copyWith(
        headlineLarge: const TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w800,
          color: BrandColors.text,
          height: 1.15,
        ),
        headlineMedium: const TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: BrandColors.text,
          height: 1.18,
        ),
        titleLarge: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: BrandColors.text,
        ),
        titleMedium: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: BrandColors.text,
        ),
        bodyLarge: const TextStyle(
          fontSize: 19,
          height: 1.42,
          color: BrandColors.text,
        ),
        bodyMedium: const TextStyle(
          fontSize: 17,
          height: 1.42,
          color: BrandColors.text,
        ),
        labelLarge: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w800,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: BrandColors.background,
        foregroundColor: BrandColors.blueStrong,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        elevation: 0,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: BrandColors.blueStrong,
        ),
      ),
      cardTheme: CardThemeData(
        color: BrandColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 1.5,
        shadowColor: const Color(0x18034F9E),
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: Color(0xFFE6EDF5)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        labelStyle: const TextStyle(
          color: BrandColors.textMuted,
          fontSize: 17,
        ),
        prefixIconColor: BrandColors.blue,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: BrandColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(
            color: BrandColors.blue,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFFB3261E)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: BrandColors.blue,
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFB7C7D8),
          minimumSize: const Size.fromHeight(58),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: BrandColors.blueStrong,
          side: const BorderSide(color: BrandColors.blue, width: 1.5),
          minimumSize: const Size.fromHeight(54),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: BrandColors.blue,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: BrandColors.orange,
        foregroundColor: Colors.white,
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 80,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        indicatorColor: BrandColors.orangeSoft,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
            color: selected ? BrandColors.blueStrong : BrandColors.textMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: selected ? 29 : 27,
            color: selected ? BrandColors.orange : BrandColors.blue,
          );
        }),
      ),
      chipTheme: base.chipTheme.copyWith(
        backgroundColor: BrandColors.blueSoft,
        selectedColor: BrandColors.orangeSoft,
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: BrandColors.blueStrong,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
      dividerColor: const Color(0xFFE4EBF2),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: BrandColors.orange,
      ),
    );
  }
}
