import 'package:flutter/material.dart';

import 'tokens.dart';

/// The Material theme for both apps, built only from tokens.
abstract final class WWTheme {
  static ThemeData light() {
    final scheme = ColorScheme.fromSeed(
      seedColor: WWColors.primary,
      primary: WWColors.primary,
      secondary: WWColors.brandGreen,
      error: WWColors.danger,
      surface: WWColors.surface,
    );
    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(WWRadius.button));
    final fieldBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(WWRadius.field),
      borderSide: const BorderSide(color: WWColors.border),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: WWFont.familyWithPackage,
      fontFamilyFallback: WWFont.fallback,
      scaffoldBackgroundColor: WWColors.background,
      textTheme: const TextTheme(
        titleLarge: WWType.screenTitle,
        titleMedium: WWType.section,
        titleSmall: WWType.cardTitle,
        bodyLarge: WWType.body,
        bodyMedium: WWType.body,
        bodySmall: WWType.caption,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: WWColors.background,
        foregroundColor: WWColors.textPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: WWType.screenTitle,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: WWColors.primary,
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: buttonShape,
          elevation: 0,
          textStyle: const TextStyle(
            fontFamily: WWFont.familyWithPackage,
            fontFamilyFallback: WWFont.fallback,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: WWColors.primary,
          minimumSize: const Size.fromHeight(48),
          shape: buttonShape,
          side: const BorderSide(color: WWColors.border),
          textStyle: const TextStyle(
            fontFamily: WWFont.familyWithPackage,
            fontFamilyFallback: WWFont.fallback,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: WWColors.surface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        hintStyle: WWType.body.copyWith(color: WWColors.textSecondary),
        border: fieldBorder,
        enabledBorder: fieldBorder,
        focusedBorder: fieldBorder.copyWith(borderSide: const BorderSide(color: WWColors.primary, width: 1.5)),
        errorBorder: fieldBorder.copyWith(borderSide: const BorderSide(color: WWColors.danger)),
      ),
      cardTheme: CardThemeData(
        color: WWColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(WWRadius.card),
          side: const BorderSide(color: WWColors.border),
        ),
      ),
      dividerTheme: const DividerThemeData(color: WWColors.border, thickness: 1),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: WWColors.surface,
        selectedItemColor: WWColors.primary,
        unselectedItemColor: WWColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        unselectedLabelStyle: TextStyle(fontSize: 11),
      ),
    );
  }
}
