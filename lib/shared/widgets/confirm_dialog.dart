import 'package:flutter/material.dart';

/// Destructive / önemli işlemler öncesi onay diyalogu.
///
/// Kullanım:
/// ```dart
/// final confirmed = await ConfirmDialog.show(
///   context: context,
///   title: 'Dönem Silinecek',
///   message: 'Bu işlem geri alınamaz.',
///   confirmLabel: 'Sil',
///   confirmColor: Colors.red,
/// );
/// if (confirmed) { ... }
/// ```
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Color? confirmColor;

  const ConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Onayla',
    this.cancelLabel = 'İptal',
    this.confirmColor,
  });

  /// Diyalogu gösterip sonucu döndürür. `true` = onaylandı.
  static Future<bool> show({
    required BuildContext context,
    required String title,
    required String message,
    String confirmLabel = 'Onayla',
    String cancelLabel = 'İptal',
    Color? confirmColor,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        confirmColor: confirmColor,
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveColor = confirmColor ?? theme.colorScheme.error;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: FilledButton.styleFrom(backgroundColor: effectiveColor),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
