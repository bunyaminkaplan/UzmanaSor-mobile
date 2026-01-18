import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/ui_kit/navigation/uzman_app_bar.dart';
import 'package:mobile/core/ui_kit/navigation/uzman_drawer.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

class AcademicDashboard extends ConsumerWidget {
  const AcademicDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    return Scaffold(
      appBar: UzmanAppBar(
        title: "Yönetim Paneli",
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
                Icons.analytics_outlined, // Stat icon
                size: 80,
                color: AppColors.cyan, // Cyan for stats
              ),
              const SizedBox(height: 24),
              Text(
                "Yönetici Paneli",
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                "Sayın ${user?.lastName ?? 'Yönetici'}",
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                "Rol: ${user?.userType.toUpperCase() ?? 'ADMIN'}",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 32),

              if (user?.userType == 'rector' || user?.userType == 'dean')
                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/approvals');
                  },
                  icon: const Icon(Icons.notifications_active),
                  label: const Text("Onay Bekleyenler"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    backgroundColor: AppColors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),

              const SizedBox(height: 12),

              if (user?.userType == 'dean' || user?.isDepartmentHead == true)
                ElevatedButton.icon(
                  onPressed: () {
                    context.push('/assignments');
                  },
                  icon: const Icon(Icons.assignment_ind),
                  label: const Text("Atamalar & Yetkilendirme"),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                  ),
                ),

              const SizedBox(height: 16),
              const Text("İstatistikler ve Grafikler yakında eklenecek."),
            ],
          ),
        ),
      ),
    );
  }
}
