import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

/// [DashboardDrawerFooter] — Sadece Çıkış Yap butonu ve aksiyonundan sorumlu widget.
class DashboardDrawerFooter extends ConsumerWidget {
  const DashboardDrawerFooter({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant, width: 1),
        ),
      ),
      child: SafeArea(
        top: false,
        child: OutlinedButton.icon(
          onPressed: () {
            GoRouter.of(context).pop(); // Drawer'ı kapat
            ref.read(authProvider.notifier).logout();
          },
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text(
            'Çıkış Yap',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
          ),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.red, width: 2),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
