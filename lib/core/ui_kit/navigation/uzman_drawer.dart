import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

class UzmanDrawer extends ConsumerWidget {
  const UzmanDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;

    String dashboardTitle = "Panel";
    IconData dashboardIcon = Icons.dashboard_outlined;

    if (user != null) {
      switch (user.userType) {
        case 'student':
          dashboardTitle = "Öğrenci Paneli";
          dashboardIcon = Icons.school_outlined;
          break;
        case 'teacher':
          dashboardTitle = "Eğitmen Paneli";
          dashboardIcon = Icons.class_outlined;
          break;
        case 'department_head':
        case 'dean':
        case 'rector':
        case 'admin':
          dashboardTitle = "Yönetim Paneli";
          dashboardIcon = Icons.analytics_outlined;
          break;
        default:
          dashboardTitle = "Panel";
      }
    }

    return Drawer(
      backgroundColor: AppColors.bgLight,
      child: Column(
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            color: AppColors.navy,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.orange, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      user?.username.isNotEmpty == true
                          ? user!.username[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        color: AppColors.navy,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  user?.username ?? 'Misafir',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  user?.userType.toUpperCase() ?? 'GUEST',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _buildMenuItem(
                  context,
                  icon: dashboardIcon,
                  title: dashboardTitle,
                  onTap: () {
                    context.pop(); // Close drawer
                    context.go('/dashboard');
                  },
                  isActive: GoRouterState.of(
                    context,
                  ).uri.toString().contains('dashboard'),
                ),
                _buildMenuItem(
                  context,
                  icon: Icons.person_outline,
                  title: 'Profilim',
                  onTap: () {
                    context.pop();
                    context.push('/profile');
                  },
                ),

                // ASSIGNMENTS MENU ITEM
                if (user != null &&
                    (user.userType == 'dean' ||
                        user.userType == 'rector' ||
                        user.userType == 'teacher'))
                  _buildMenuItem(
                    context,
                    icon: Icons.assignment_ind_outlined,
                    title: 'Atamalar',
                    onTap: () {
                      context.pop();
                      context.push('/assignments');
                    },
                    isActive: GoRouterState.of(
                      context,
                    ).uri.toString().contains('assignments'),
                  ),
                // Add more items here as needed
              ],
            ),
          ),

          // Footer (Logout)
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SafeArea(
              top: false,
              child: OutlinedButton.icon(
                onPressed: () {
                  // Logout Logic
                  ref.read(authProvider.notifier).logout();
                  // AuthGuard will handle redirect to login
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.error),
                  foregroundColor: AppColors.error,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text("ÇIKIŞ YAP"),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isActive = false,
  }) {
    // Removed unused theme variable

    return ListTile(
      leading: Icon(
        icon,
        color: isActive ? AppColors.cyan : AppColors.textSecondary,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isActive ? AppColors.cyan : AppColors.textPrimary,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
        ),
      ),
      selected: isActive,
      selectedTileColor: AppColors.cyan.withValues(alpha: 0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      onTap: onTap,
    );
  }
}
