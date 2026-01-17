import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

enum ButtonVariant { primary, secondary, danger, outline }

/// [UzmanButton] - Proje standart butonu.
///
/// ASLA Color parametresi almaz. Rengini [variant] belirler.
///
/// Kullanım:
/// ```dart
/// UzmanButton(
///   label: "Kaydet",
///   variant: ButtonVariant.primary,
///   isLoading: _loading,
///   onPressed: () => save(),
/// )
/// ```
class UzmanButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final ButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  const UzmanButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = ButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // 1. Variant'a göre stil belirle
    final Color backgroundColor = _getBackgroundColor();
    final Color foregroundColor = _getForegroundColor();
    final BorderSide? borderSide = _getBorderSide();

    // 2. Buton stili
    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      disabledBackgroundColor: backgroundColor.withValues(alpha: 0.5),
      disabledForegroundColor: foregroundColor.withValues(alpha: 0.5),
      elevation: variant == ButtonVariant.outline ? 0 : 2,
      shadowColor: variant == ButtonVariant.outline ? null : Colors.black26,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: borderSide ?? BorderSide.none,
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    );

    // 3. İçerik (Loading veya Text+Icon)
    Widget content = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: foregroundColor,
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(label),
            ],
          );

    return SizedBox(
      height: 56, // CSS --btn-height: 56px
      child: ElevatedButton(
        style: buttonStyle,
        onPressed: isLoading ? null : onPressed, // Loading iken tıklanamaz
        child: content,
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
        return AppColors.cyan;
      case ButtonVariant.secondary:
        return AppColors.navy;
      case ButtonVariant.danger:
        return AppColors.error;
      case ButtonVariant.outline:
        return Colors.transparent;
    }
  }

  Color _getForegroundColor() {
    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.secondary:
      case ButtonVariant.danger:
        return Colors.white;
      case ButtonVariant.outline:
        return AppColors.textSecondary; // Navy text for outline
    }
  }

  BorderSide? _getBorderSide() {
    if (variant == ButtonVariant.outline) {
      return const BorderSide(color: AppColors.border, width: 2);
    }
    return null;
  }
}
