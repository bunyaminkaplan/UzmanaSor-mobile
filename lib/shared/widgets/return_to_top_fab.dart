import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

/// Scroll listelerinde "başa dön" FAB'ı.
///
/// Kullanım: Liste widget'ı kendi ScrollController'ını yönetir,
/// `visible` ve `onPressed` parametrelerini buraya iletir.
/// Eşik değeri: [kReturnToTopThreshold] piksel scroll sonrası görünür.
class ReturnToTopFab extends StatelessWidget {
  final bool visible;
  final VoidCallback onPressed;

  const ReturnToTopFab({
    super.key,
    required this.visible,
    required this.onPressed,
  });

  /// FAB'ın görünür hale geldiği scroll offset eşiği.
  static const double kReturnToTopThreshold = 400.0;

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      offset: visible ? Offset.zero : const Offset(1.5, 0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: visible ? 1 : 0,
        child: FloatingActionButton(
          heroTag: 'returnToTopFab',
          backgroundColor: AppColors.accentNavy,
          foregroundColor: Colors.white,
          onPressed: visible ? onPressed : null,
          child: const Icon(Icons.arrow_upward),
        ),
      ),
    );
  }
}
