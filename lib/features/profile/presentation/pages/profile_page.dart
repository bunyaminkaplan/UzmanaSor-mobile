import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/courses/presentation/providers/course_provider.dart';
import 'package:mobile/features/profile/data/busy_term_data_source.dart';
import 'package:mobile/features/profile/presentation/widgets/academic_info_card.dart';
import 'package:mobile/features/profile/presentation/widgets/advisor_card.dart';
import 'package:mobile/features/profile/presentation/widgets/busy_mode_section.dart';
import 'package:mobile/features/profile/presentation/widgets/courses_section.dart';
import 'package:mobile/features/profile/presentation/widgets/personal_info_card.dart';
import 'package:mobile/features/profile/presentation/widgets/profile_header.dart';
import 'package:mobile/shared/widgets/dashboard_scaffold.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.value;

    if (user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final isStudent =
        user.userType == 'student' || user.userType == 'r_student';
    final isTeacher = user.userType == 'teacher';

    return DashboardScaffold(
      onRefresh: () async {
        ref.invalidate(myCoursesProvider);
        ref.invalidate(busyTermsProvider);
        ref.invalidate(classTermsProvider);
      },
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header Kartı
            ProfileHeader(user: user),
            const SizedBox(height: 24),

            // Kişisel Bilgiler
            PersonalInfoCard(user: user),
            const SizedBox(height: 24),

            // Akademik Bilgiler
            AcademicInfoCard(user: user),
            const SizedBox(height: 24),

            // Öğrencisi ise Danışman Kartı
            if (isStudent && user.advisor != null) ...[
              AdvisorCard(advisor: user.advisor),
              const SizedBox(height: 24),
            ],

            // Akademisyen ise Derslerim
            if (isTeacher) ...[
              const CoursesSection(),
              const SizedBox(height: 24),
            ],
            // Akademisyen ise Meşgul Mod
            if (isTeacher) ...[
              const BusyModeSection(),
              const SizedBox(height: 24),
            ],
          ],
        ),
      ),
    );
  }
}
