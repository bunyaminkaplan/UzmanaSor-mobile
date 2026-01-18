import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/ui_kit/navigation/uzman_app_bar.dart';
import 'package:mobile/core/ui_kit/navigation/uzman_drawer.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

import 'package:mobile/features/dashboard/presentation/pages/feed_view.dart';
import 'package:mobile/features/questions/presentation/pages/ask_question_page.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final displayName = user?.firstName ?? user?.username ?? 'Öğrenci';

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      appBar: UzmanAppBar(
        title: "Öğrenci Paneli",
        onProfileTap: () {
          // handled by router usually or drawer
        },
      ),
      drawer: const UzmanDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // COMPACT HEADER
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
            child: Text(
              "Hoşgeldin, $displayName",
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textHeading,
              ),
            ),
          ),

          // FEED
          const Expanded(child: FeedView()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const AskQuestionPage()),
          );
        },
        backgroundColor: AppColors.primaryCyan,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
