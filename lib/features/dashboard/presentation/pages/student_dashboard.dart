import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/ui_kit/navigation/uzman_app_bar.dart';
import 'package:mobile/core/ui_kit/navigation/uzman_drawer.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

import 'package:mobile/features/dashboard/presentation/pages/feed_view.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    return Scaffold(
      appBar: UzmanAppBar(
        title: "Öğrenci Paneli",
        onProfileTap: () {
          // TODO: Navigate to Profile
        },
      ),
      drawer: const UzmanDrawer(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle_outline,
                size: 80,
                color: AppColors.success,
              ),
              const SizedBox(height: 24),
              Text(
                "Hoşgeldin, ${user?.username ?? 'Öğrenci'}",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Rol: ${user?.userType.toUpperCase() ?? 'Unknown'}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 16),
              const Expanded(child: FeedView()),
            ],
          ),
        ),
      ),
    );
  }
}
