import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/ui_kit/navigation/uzman_app_bar.dart';
import 'package:mobile/core/ui_kit/navigation/uzman_drawer.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/dashboard/presentation/pages/feed_view.dart';

class TeacherDashboard extends ConsumerWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    return Scaffold(
      appBar: UzmanAppBar(
        title: "Eğitmen Paneli", // Different title
        onProfileTap: () {
          // TODO: Navigate to Profile
        },
      ),
      drawer:
          const UzmanDrawer(), // Reusing the same drawer for now, logic inside can be conditional later
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.school_outlined, // Different icon for teacher
                size: 80,
                color: AppColors.orange, // Different color for teacher
              ),
              const SizedBox(height: 24),
              Text(
                "Hoşgeldin, Sayın ${user?.lastName ?? 'Eğitmen'}", // Formal greeting
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Rol: ${user?.userType.toUpperCase() ?? 'UNKNOWN'}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              // Only regular teachers (who might be advisors) see this
              // If they are not department heads.
              // Show to ALL teachers (Head or Advisor)
              ActionChip(
                avatar: const Icon(Icons.assignment_ind, size: 16),
                label: Text(
                  user?.isDepartmentHead == true
                      ? "Atamalar & Danışmanlık"
                      : "Sınıf Temsilcisi Seçimi",
                ),
                onPressed: () {
                  context.push('/assignments');
                },
              ),
              const SizedBox(height: 32),
              const SizedBox(height: 24),
              const Expanded(child: FeedView()),
            ],
          ),
        ),
      ),
    );
  }
}
