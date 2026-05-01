import 'package:flutter/material.dart';
import 'app_colors.dart';

extension AppColorsExt on BuildContext {
  bool get _isDark => Theme.of(this).brightness == Brightness.dark;

  Color get scaffoldBg   => _isDark ? AppColors.scaffoldBgDark  : AppColors.scaffoldBg;
  Color get cardBg       => _isDark ? AppColors.cardBgDark       : AppColors.cardBg;
  Color get cardHover    => _isDark ? AppColors.cardHoverDark    : AppColors.cardHover;
  Color get inputBg      => _isDark ? AppColors.inputBgDark      : AppColors.inputBg;
  Color get textHeading  => _isDark ? AppColors.textHeadingDark  : AppColors.textHeading;
  Color get textBody     => _isDark ? AppColors.textBodyDark     : AppColors.textBody;
  Color get textMuted    => _isDark ? AppColors.textMutedDark    : AppColors.textMuted;
  Color get textLight    => _isDark ? AppColors.textLightDark    : AppColors.textLight;
  Color get borderColor  => _isDark ? AppColors.borderColorDark  : AppColors.borderColor;
  Color get borderLight  => _isDark ? AppColors.borderLightDark  : AppColors.borderLight;
}
