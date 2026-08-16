import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';

/// Clean Monochrome POS theme matching the customer web app aesthetic.
///
/// - Primary: Pure Solid Black `#000000` / `#0F172A`
/// - Primary Foreground: Pure White `#FFFFFF`
/// - Background: Pure Crisp White `#FFFFFF` & Soft Neutral `#F8FAFC`
/// - Surface: `#FFFFFF`
/// - Border: Crisp Light Gray `#E2E8F0` / `#E5E7EB`
/// - Typography: GoogleFonts Manrope (sans) & Arizonia (script branding)
class TerminalTheme {
  const TerminalTheme._();

  static FThemeData light([bool touch = true]) {
    final baseTheme = touch ? FTheme.neutral.light.touch : FTheme.neutral.light.desktop;

    final colors = baseTheme.colors.copyWith(
      primary: const Color(0xFF000000),
      primaryForeground: const Color(0xFFFFFFFF),
      background: const Color(0xFFF8FAFC),
      border: const Color(0xFFE2E8F0),
    );

    final fontName = GoogleFonts.manrope().fontFamily ?? 'Manrope';

    final typography = FTypography(
      display: FTypeface.inherit(
        fontFamily: fontName,
        colors: colors,
        touch: touch,
      ),
      body: FTypeface.inherit(
        fontFamily: fontName,
        colors: colors,
        touch: touch,
      ),
    );

    return FThemeData(
      colors: colors,
      typography: typography,
      style: baseTheme.style,
      touch: touch,
    );
  }
}
