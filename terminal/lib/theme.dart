import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:terminal/theme/terminal_colors.dart';

export 'package:terminal/theme/terminal_colors.dart';

/// Clean Monochrome POS theme matching the customer web app aesthetic.
/// Follows the 60/30/10 design rule with token-based single source of truth.
class TerminalTheme {
  const TerminalTheme._();

  static FThemeData light([bool touch = true]) {
    final baseTheme =
        touch ? FTheme.neutral.light.touch : FTheme.neutral.light.desktop;

    final colors = baseTheme.colors.copyWith(
      primary: TerminalColors.primary,
      primaryForeground: TerminalColors.textWhite,
      background: TerminalColors.pageBackground,
      border: TerminalColors.border,
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

    final circularProgressStyles = FCircularProgressSizeStyles(
      FVariants(
        FCircularProgressStyle(
          iconStyle: const IconThemeData(color: TerminalColors.primary, size: 20),
        ),
        variants: {
          [.xs]: FCircularProgressStyle(
            iconStyle: const IconThemeData(color: TerminalColors.primary, size: 12),
          ),
          [.sm]: FCircularProgressStyle(
            iconStyle: const IconThemeData(color: TerminalColors.primary, size: 16),
          ),
          [.md]: FCircularProgressStyle(
            iconStyle: const IconThemeData(color: TerminalColors.primary, size: 20),
          ),
          [.lg]: FCircularProgressStyle(
            iconStyle: const IconThemeData(color: TerminalColors.primary, size: 28),
          ),
          [.xl]: FCircularProgressStyle(
            iconStyle: const IconThemeData(color: TerminalColors.primary, size: 36),
          ),
        },
      ),
    );

    return FThemeData(
      colors: colors,
      typography: typography,
      circularProgressStyles: circularProgressStyles,
      style: baseTheme.style,
      touch: touch,
    );
  }
}
