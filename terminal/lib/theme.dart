import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

final terminalLightTheme = ShadThemeData(
  brightness: Brightness.light,
  colorScheme: const ShadZincColorScheme.light(
    background: Color(0xFFF8FAFC),
    foreground: Color(0xFF0F172A),
    card: Color(0xFFFFFFFF),
    cardForeground: Color(0xFF0F172A),
    popover: Color(0xFFFFFFFF),
    popoverForeground: Color(0xFF0F172A),
    primary: Color(0xFF191645),
    primaryForeground: Color(0xFFFFFFFF),
    secondary: Color(0xFFF1F5F9),
    secondaryForeground: Color(0xFF0F172A),
    muted: Color(0xFFF8FAFC),
    mutedForeground: Color(0xFF64748B),
    accent: Color(0xFF43C6AC),
    accentForeground: Color(0xFF191645),
    destructive: Color(0xFFDC2626),
    destructiveForeground: Color(0xFFFFFFFF),
    border: Color(0xFFCBD5E1),
    input: Color(0xFFCBD5E1),
    ring: Color(0xFF43C6AC),
  ),
  textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.manrope),
);

final terminalDarkTheme = ShadThemeData(
  brightness: Brightness.dark,
  colorScheme: const ShadZincColorScheme.dark(),
  textTheme: ShadTextTheme.fromGoogleFont(GoogleFonts.manrope),
);
