import 'package:flutter/material.dart';

/// App color palette matching the original ssyok Finance React Native app
class AppColors {
  // Primary brand color — Deep Teal (trustworthy, financial sophistication)
  static const Color primary = Color(0xFF0F766E);
  static const Color primaryLight = Color(0xFF5EEAD4);
  static const Color primaryDark = Color(0xFF0D5E57);

  // Secondary — Warm Amber (warmth and energy)
  static const Color secondary = Color(0xFFF59E0B);

  // Tertiary / accent
  static const Color tertiary = Color(0xFFE0F2FE); // Sky Blue — soft, calming
  static const Color accent = Color(0xFFFEF3C7); // Warm Cream
  static const Color quaternary = Color(
    0xFFF5F5F4,
  ); // Stone — neutral backgrounds

  // Semantic colors
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color successDark = Color(0xFF059669);
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red

  // Light theme
  static const Color backgroundLight = Color(0xFFFAFAF9); // Warm Stone
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color textPrimaryLight = Color(0xFF1C1917); // Rich Charcoal
  static const Color textSecondaryLight = Color(0xFF57534E); // Warm Gray
  static const Color textMutedLight = Color(0xFFA8A29E); // Muted Stone
  static const Color borderLight = Color(0x140F766E); // Subtle teal tint

  // Dark theme
  static const Color backgroundDark = Color(0xFF0F172A); // Deep Navy
  static const Color surfaceDark = Color(0xFF1E293B); // Slate
  static const Color quaternaryDark = Color(0xFF334155);
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Cool White
  static const Color textSecondaryDark = Color(0xFFCBD5E1); // Soft Gray
  static const Color textMutedDark = Color(0xFF64748B); // Muted Slate
  static const Color borderDark = Color(0x1F14B8A6); // Teal tint

  // Glassmorphism overlay
  static const Color glassOverlay = Color(0x1AFFFFFF);
  static const Color glassOverlayDark = Color(0x1A000000);

  // Legacy aliases for backward compat
  static const Color primaryGreen = primary;
  static const Color primaryGreenLight = primaryLight;
  static const Color primaryGreenDark = primaryDark;
  static const Color secondaryBlue = secondary;
  static const Color secondaryOrange = Color(0xFFFF6B35);
  static const Color info = Color(0xFF3B82F6);
}
