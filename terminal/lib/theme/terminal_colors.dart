import 'package:flutter/material.dart';

/// Standard monochrome design tokens for POS terminal matching customer aesthetic.
/// Follows the 60/30/10 rule with semantic exceptions for status badges and chips.
abstract final class TerminalColors {
  // 60% Dominant (Surfaces & Backgrounds)
  static const surface = Color(0xFFFFFFFF);
  static const pageBackground = Color(0xFFF8FAFC);
  static const secondaryBackground = Color(0xFFF1F5F9);

  // 30% Secondary (Borders, Typography, Subtle Controls)
  static const border = Color(0xFFE2E8F0);
  static const borderSubtle = Color(0xFFF1F5F9);
  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF64748B);
  static const textMuted = Color(0xFF94A3B8);
  static const textLight = Color(0xFF475569);
  static const textBlack = Color(0xFF000000);
  static const textWhite = Color(0xFFFFFFFF);

  // 10% Accent (Primary CTAs & Hover States - Finch Midnight Navy)
  static const primary = Color(0xFF0B132B);
  static const primaryHover = Color(0xFF1C2541);
  static const controlHover = Color(0xFFE2E8F0);

  // Brand Blue Tokens (Info, QR Scanner, Logo Accent)
  static const brandBlue = Color(0xFF2563EB);
  static const brandBlueBg = Color(0xFFEFF6FF);
  static const brandBlueBorder = Color(0xFFBFDBFE);

  // Semantic Status Badges & Chips
  static const activeBadgeBg = Color(0xFFDCFCE7);
  static const activeBadgeText = Color(0xFF166534);
  static const activeBadgeBorder = Color(0xFFBBF7D0);

  static const inactiveBadgeBg = Color(0xFFFEE2E2);
  static const inactiveBadgeText = Color(0xFF991B1B);
  static const inactiveBadgeBorder = Color(0xFFFECACA);

  static const lowStockBadgeBg = Color(0xFFFEF3C7);
  static const lowStockBadgeText = Color(0xFF92400E);
  static const lowStockBadgeBorder = Color(0xFFFDE68A);

  // Error Tokens
  static const error = Color(0xFFDC2626);

  // Shadow & Overlay Tokens
  static const shadow = Color(0x08000000);
  static const shadowLight = Color(0x06000000);
  static const transparent = Color(0x00000000);
}
