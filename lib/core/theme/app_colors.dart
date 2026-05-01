import 'package:flutter/material.dart';

/// Web projesindeki CSS tokenlarla birebir eşleşen renk paleti.
///
/// Kaynak: web/frontend/src/index.css — :root ve .dark CSS değişkenleri
/// Bu sınıf web projesiyle marka tutarlılığını garanti eder.
///
/// Kurallar:
///   - Yeni renk eklenirken web CSS'teki karşılığını yorum olarak belirt.
///   - Hardcoded renk kullanımı yasak — her widget buradan beslenmelidir.
abstract final class AppColors {
  // --------------- Arkaplan ---------------
  // CSS: --bg-primary
  static const scaffoldBg = Color(0xFFF0F2F5);
  static const scaffoldBgDark = Color(0xFF0D1117);

  // CSS: --bg-card
  static const cardBg = Color(0xFFFFFFFF);
  static const cardBgDark = Color(0xFF161B22);

  // CSS: --bg-card-hover
  static const cardHover = Color(0xFFF8F9FA);
  static const cardHoverDark = Color(0xFF1F2937);

  // CSS: --bg-input
  static const inputBg = Color(0xFFFAFAFA);
  static const inputBgDark = Color(0xFF21262D);

  // --------------- Metin ---------------
  // CSS: --text-primary
  static const textHeading = Color(0xFF0D1B3E);
  static const textHeadingDark = Color(0xFFE6EDF3);

  // CSS: --text-secondary
  static const textBody = Color(0xFF262F59);
  static const textBodyDark = Color(0xFFC9D1D9);

  // CSS: --text-muted
  static const textMuted = Color(0xFF6C757D);
  static const textMutedDark = Color(0xFF8B949E);

  // CSS: --text-light
  static const textLight = Color(0xFF999999);
  static const textLightDark = Color(0xFF6E7681);

  // --------------- Vurgu (Accent) ---------------
  // CSS: --accent-orange  (Her iki modda aynı)
  static const accentOrange = Color(0xFFEF7F1A);

  // CSS: --accent-cyan
  static const accentCyan = Color(0xFF12A7CD);

  // CSS: --accent-navy
  static const accentNavy = Color(0xFF262F59);

  // CSS: --accent-navy-dark
  static const accentNavyDark = Color(0xFF1A1F3A);

  // Gradient bitiş renkleri (accent'lerin koyu tonu)
  static const accentOrangeDark = Color(0xFFD66A0F);
  static const accentCyanDark   = Color(0xFF0D8AAB);

  // Native splash arka planıyla uyum
  static const splashBg = Color(0xFF12141C);

  // --------------- Kenarlık (Border) ---------------
  // CSS: --border-color
  static const borderColor = Color(0xFFE0E0E0);
  static const borderColorDark = Color(0xFF30363D);

  // CSS: --border-light
  static const borderLight = Color(0xFFEEEEEE);
  static const borderLightDark = Color(0xFF21262D);

  // --------------- Semantik (Durum Renkleri) ---------------
  static const success = Color(0xFF28A745);
  static const warning = Color(0xFFFFC107);
  static const error = Color(0xFFDC3545);
  static const info = Color(0xFF17A2B8);
}
