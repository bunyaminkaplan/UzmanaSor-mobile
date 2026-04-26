import 'package:flutter/material.dart';

/// Tam sayfa AsyncValue hata durumu için standart widget.
///
/// Kullanım:
/// ```dart
/// error: (e, _) => AsyncErrorWidget(message: 'Veriler yüklenemedi'),
/// error: (e, _) => AsyncErrorWidget(
///   message: 'Soru yüklenemedi',
///   onRetry: () => ref.invalidate(myProvider),
/// ),
/// ```
class AsyncErrorWidget extends StatelessWidget {
  const AsyncErrorWidget({super.key, required this.message, this.onRetry});

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
