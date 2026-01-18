import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

class AppTheme {
  // LIGHT THEME
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto', // Or system default
    scaffoldBackgroundColor: AppColors.scaffoldBackground,
    primaryColor: AppColors.primaryNavy,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryNavy,
      primary: AppColors.primaryNavy,
      secondary: AppColors.primaryCyan,
      error: AppColors.error,
      surface: AppColors.cardBackground,
      onSurface: AppColors.textHeading,
    ),

    // APP BAR
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.scaffoldBackground,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textHeading),
      actionsIconTheme: IconThemeData(color: AppColors.primaryCyan),
      titleTextStyle: TextStyle(
        color: AppColors.textHeading,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    // CARDS
    cardTheme: CardThemeData(
      color: AppColors.cardBackground,
      elevation: 0, // Using manual shadows usually, or set low
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15), // MATCH TOKEN
      ),
    ),

    // INPUTS
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10), // MATCH TOKEN
        borderSide: const BorderSide(color: AppColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryCyan, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    ),

    // ELEVATED BUTTONS
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryNavy,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // MATCH TOKEN
        ),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );

  // DARK THEME (Optional/Future Proofing)
  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.scaffoldBackgroundDark,
    primaryColor: AppColors.primaryNavy,

    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryNavy,
      brightness: Brightness.dark,
      primary: AppColors
          .primaryNavy, // Or lighter in dark mode? Usually Primary stays or shifts.
      secondary: AppColors.primaryCyan,
      error: AppColors.error,
      surface: AppColors.cardBackgroundDark,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.scaffoldBackgroundDark,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.textHeadingDark),
      titleTextStyle: TextStyle(
        color: AppColors.textHeadingDark,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),

    cardTheme: CardThemeData(
      color: AppColors.cardBackgroundDark,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.inputBackgroundDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.borderDark),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: AppColors.primaryCyan, width: 2),
      ),
    ),
  );
}
