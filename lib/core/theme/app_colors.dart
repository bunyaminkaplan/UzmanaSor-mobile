import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors
  static const Color primaryNavy = Color(0xFF262F59);
  static const Color primaryCyan = Color(0xFF12A7CD);
  static const Color primaryOrange = Color(0xFFEF7F1A);
  static const Color teal = Color(0xFF17a2b8);

  // Status Colors
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFDC3545);

  // Light Mode Colors
  static const Color scaffoldBackground = Color(0xFFF0F2F5);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color inputBackground = Color(0xFFFAFAFA);

  static const Color textHeading = Color(0xFF0D1B3E);
  static const Color textBody = Color(0xFF262F59);
  static const Color textMuted = Color(0xFF6C757D);
  static const Color border = Color(0xFFE0E0E0);

  // Dark Mode Colors
  static const Color scaffoldBackgroundDark = Color(0xFF0D1117);
  static const Color cardBackgroundDark = Color(0xFF161B22);
  static const Color inputBackgroundDark = Color(0xFF21262D);

  static const Color textHeadingDark = Color(0xFFE6EDF3);
  static const Color textBodyDark = Color(0xFFC9D1D9);
  static const Color textMutedDark = Color(0xFF8B949E);
  static const Color borderDark = Color(0xFF30363D);

  // Aliases for Common Use (Defaulting to Light Mode concept for static access, but Theme should be used for dynamic)
  // DEPRECATED: Use Theme.of(context) where possible, but these kept for direct usage in non-context widgets
  static const Color surfaceLight = cardBackground;
  static const Color textPrimary = textHeading;
  static const Color textSecondary = textBody;
  static const Color bgLight = scaffoldBackground;

  // Specific
  static const Color navy = primaryNavy;
  static const Color orange = primaryOrange;
  static const Color cyan = primaryCyan;
}
