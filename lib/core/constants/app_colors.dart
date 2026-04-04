import 'package:flutter/material.dart';

/// Halo App Color Palette - Dark Theme with Neon Accents
class AppColors {
  AppColors._();

  // Primary colors
  static const Color primary = Color(0xFF00E5FF);
  static const Color primaryDark = Color(0xFF00B8D4);
  static const Color primaryLight = Color(0xFF80F0FF);

  // Secondary / Accent
  static const Color secondary = Color(0xFF7C4DFF);
  static const Color secondaryDark = Color(0xFF651FFF);
  static const Color secondaryLight = Color(0xFFB388FF);

  // Gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardGradient = LinearGradient(
    colors: [Color(0xFF1E1E2E), Color(0xFF2A2A3E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient shimmerGradient = LinearGradient(
    colors: [Color(0xFF2A2A3E), Color(0xFF3A3A4E), Color(0xFF2A2A3E)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background
  static const Color background = Color(0xFF0D0D1A);
  static const Color surface = Color(0xFF1A1A2E);
  static const Color surfaceLight = Color(0xFF25253A);
  static const Color card = Color(0xFF1E1E30);
  static const Color bottomNav = Color(0xFF141425);

  // Text
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFFB0B0C0);
  static const Color textTertiary = Color(0xFF6E6E80);
  static const Color textOnPrimary = Color(0xFF000000);

  // Status
  static const Color online = Color(0xFF00E676);
  static const Color offline = Color(0xFF757575);
  static const Color error = Color(0xFFFF5252);
  static const Color warning = Color(0xFFFFAB40);
  static const Color success = Color(0xFF69F0AE);
  static const Color info = Color(0xFF40C4FF);

  // Chat
  static const Color myMessage = Color(0xFF00E5FF);
  static const Color otherMessage = Color(0xFF2A2A3E);
  static const Color myMessageText = Color(0xFF000000);
  static const Color otherMessageText = Color(0xFFFFFFFF);

  // Map
  static const Color mapMarkerBorder = Color(0xFF00E5FF);
  static const Color mapMarkerSelf = Color(0xFF7C4DFF);

  // Divider & Border
  static const Color divider = Color(0xFF2A2A3E);
  static const Color border = Color(0xFF3A3A4E);
  static const Color inputFill = Color(0xFF1E1E30);
}
