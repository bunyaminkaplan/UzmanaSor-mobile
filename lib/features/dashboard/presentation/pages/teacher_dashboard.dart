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
    final displayName = user?.firstName ?? user?.lastName ?? 'Eğitmen';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: UzmanAppBar(title: "Eğitmen Paneli", onProfileTap: () {}),
      drawer: const UzmanDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // COMPACT HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Hoşgeldin, Sayın $displayName",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textHeading,
                  ),
                ),
                // Action Chip for Assignments
                ActionChip(
                  avatar: const Icon(
                    Icons.assignment_ind,
                    size: 16,
                    color: AppColors.textBody,
                  ),
                  label: const Text("İşlemler"),
                  backgroundColor: AppColors.surfaceLight,
                  side: BorderSide.none,
                  onPressed: () {
                    context.push('/assignments');
                  },
                ),
              ],
            ),
          ),

          // FEED
          const Expanded(child: FeedView()),
        ],
      ),
    );
  }
}
