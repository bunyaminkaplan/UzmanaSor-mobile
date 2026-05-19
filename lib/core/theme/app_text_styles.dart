import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Tipografi token'ları — web projesiyle tutarlı font ağırlıkları.
///
/// Font ailesi: Inter (Google Fonts)
/// Renk yok — tema moduna göre otomatik uyum için Theme.of(context).textTheme kullanılır.
abstract final class AppTextStyles {
  static String get _font => GoogleFonts.inter().fontFamily!;

  // --------------- Başlıklar ---------------
  static TextStyle get headlineLarge => TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle get headlineMedium => TextStyle(
    fontFamily: _font,
    fontSize: 22,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  static TextStyle get headlineSmall => TextStyle(
    fontFamily: _font,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 1.3,
  );

  // --------------- Gövde ---------------
  static TextStyle get bodyLarge => TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodyMedium => TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.5,
  );

  static TextStyle get bodySmall => TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.4,
  );

  // --------------- Etiketler ---------------
  static TextStyle get labelLarge => TextStyle(
    fontFamily: _font,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => TextStyle(
    fontFamily: _font,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // --------------- Buton ---------------
  static TextStyle get button => TextStyle(
    fontFamily: _font,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );

  // --------------- Stat Sayıları (tabular figures) ---------------
  static TextStyle get statNumber => TextStyle(
    fontFamily: _font,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.2,
    fontFeatures: const [FontFeature.tabularFigures()],
  );
}
