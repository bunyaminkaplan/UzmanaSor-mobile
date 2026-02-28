import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tipografi token'ları — web projesiyle tutarlı font ağırlıkları.
///
/// Font ailesi: System UI (iOS: SF Pro, Android: Roboto)
/// Bu sınıf TextTheme dışında doğrudan kullanım için optimize edilmiştir.
abstract final class AppTextStyles {
  // --------------- Başlıklar ---------------
  static const headlineLarge = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textHeading,
    height: 1.3,
  );

  static const headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    color: AppColors.textHeading,
    height: 1.3,
  );

  static const headlineSmall = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textHeading,
    height: 1.3,
  );

  // --------------- Gövde ---------------
  static const bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textBody,
    height: 1.5,
  );

  static const bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textBody,
    height: 1.5,
  );

  static const bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  // --------------- Etiketler ---------------
  static const labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textBody,
    letterSpacing: 0.1,
  );

  static const labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.1,
  );

  // --------------- Buton ---------------
  static const button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
  );
}
