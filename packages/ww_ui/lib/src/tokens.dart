import 'package:flutter/painting.dart';

/// WellWish design tokens (ARCHITECTURE §5.2). This file is the ONE place for exact values.
///
/// Brand colours were sampled from the official logo (docs/ui-reference/wellwish-logo.jpg);
/// the rest from the mockup. When the designer's source file arrives, update the values
/// here and every screen follows.
abstract final class WWColors {
  /// Main buttons (Send OTP, Confirm), selected date, active tab. = the logo's blue.
  static const primary = Color(0xFF0072E4);

  /// "Well" in the wordmark (deeper end of the logo's blue gradient).
  static const brandBlue = Color(0xFF0062D6);

  /// "Wish" in the wordmark and the green hand: "Book Now", online dot, check marks.
  static const brandGreen = Color(0xFF14965E);

  /// The logo's tagline colour.
  static const brandNavy = Color(0xFF0B4266);

  static const textPrimary = Color(0xFF0F2547);
  static const textSecondary = Color(0xFF6B7785);
  static const background = Color(0xFFF5F9FF);
  static const surface = Color(0xFFFFFFFF);
  static const border = Color(0xFFE3EAF3);

  /// Hero card, selected chips, light fills.
  static const tint = Color(0xFFEAF2FF);
  static const greenTint = Color(0xFFE6F7EC);
  static const danger = Color(0xFFE53935);
  static const dangerTint = Color(0xFFFDECEA);

  /// Warnings: expired document, address outside a service area.
  static const warning = Color(0xFFB26A00);
  static const warningTint = Color(0xFFFFF4E0);

  /// Premium crown.
  static const gold = Color(0xFFF4B400);

  /// Family tile and family icons (mockup 3, 8).
  static const familyPurple = Color(0xFF7E57C2);
}

abstract final class WWRadius {
  static const card = 12.0;
  static const button = 10.0;
  static const chip = 10.0;
  static const field = 10.0;
}

abstract final class WWSpacing {
  static const xs = 4.0;
  static const sm = 8.0;
  static const md = 12.0;
  static const lg = 16.0;
  static const xl = 24.0;
  static const xxl = 32.0;

  /// Screen side padding.
  static const screen = 16.0;
}

abstract final class WWFont {
  /// Bundled in this package (fonts/): Poppins for English and Hindi.
  static const family = 'Poppins';
  static const package = 'ww_ui';
  static const familyWithPackage = 'packages/ww_ui/Poppins';

  /// Poppins has no Odia letters: the bundled Noto Sans Oriya draws them (and Noto Sans
  /// Devanagari any Hindi letter Poppins lacks), the same on every phone (ARCHITECTURE §5).
  static const fallback = ['packages/ww_ui/NotoSansOriya', 'packages/ww_ui/NotoSansDevanagari'];
}

/// Type scale from ARCHITECTURE §5.2.
abstract final class WWType {
  static const screenTitle = TextStyle(
    fontFamily: WWFont.familyWithPackage,
    fontFamilyFallback: WWFont.fallback,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: WWColors.textPrimary,
  );
  static const section = TextStyle(
    fontFamily: WWFont.familyWithPackage,
    fontFamilyFallback: WWFont.fallback,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: WWColors.textPrimary,
  );
  static const cardTitle = TextStyle(
    fontFamily: WWFont.familyWithPackage,
    fontFamilyFallback: WWFont.fallback,
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: WWColors.textPrimary,
  );
  static const body = TextStyle(
    fontFamily: WWFont.familyWithPackage,
    fontFamilyFallback: WWFont.fallback,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: WWColors.textPrimary,
  );
  static const caption = TextStyle(
    fontFamily: WWFont.familyWithPackage,
    fontFamilyFallback: WWFont.fallback,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: WWColors.textSecondary,
  );
}
