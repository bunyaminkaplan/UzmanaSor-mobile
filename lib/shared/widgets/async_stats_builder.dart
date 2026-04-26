import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// İstatistik tabanlı dashboard'larda (Dean, Rector, SchoolAdmin)
/// loading / error / data durumlarını standart şekilde gösteren builder.
///
/// Her sayfada tekrar eden CircularProgressIndicator (loading) ve
/// Icon + Text (error) bloklarını tek noktada yönetir.
///
/// Kullanım:
/// ```dart
/// AsyncStatsBuilder<DashboardStatsEntity>(
///   asyncValue: statsAsync,
///   builder: (stats) => Column(...),
/// )
/// ```
class AsyncStatsBuilder<T> extends StatelessWidget {
  final AsyncValue<T> asyncValue;
  final Widget Function(T data) builder;

  const AsyncStatsBuilder({
    super.key,
    required this.asyncValue,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      skipLoadingOnReload: true,
      skipLoadingOnRefresh: true,
      loading: () => const Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: CircularProgressIndicator(),
        ),
      ),
      error: (error, stack) => Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Veriler yüklenemedi:\n$error', textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
      data: builder,
    );
  }
}
