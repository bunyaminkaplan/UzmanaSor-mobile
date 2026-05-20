import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/async_stats_builder.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../courses/domain/entities/course_entity.dart';
import '../../../courses/presentation/providers/course_provider.dart';
import '../widgets/course_form_sheet.dart';
import '../widgets/course_tile.dart';

/// Bölüm Başkanı — Ders Yönetimi Sayfası
///
/// Web: ManageCourses.jsx paritesi.
/// CRUD: Ders listesi + yeni ders oluştur + düzenle + sil.
class ManageCoursesPage extends ConsumerWidget {
  const ManageCoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(departmentCoursesProvider);

    return DashboardScaffold(
      onRefresh: () => ref.invalidate(departmentCoursesProvider),
      pageTitle: 'Ders Yönetimi',
      header: const DashboardPageHeader(
        title: 'Ders Yönetimi',
        description: 'Bölümünüze ait dersleri yönetin ve hoca atayın.',
        borderColor: AppColors.accentOrange,
      ),
      fabs: [
        FloatingActionButton.extended(
          onPressed: () => _openForm(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Yeni Ders'),
          backgroundColor: AppColors.accentOrange,
          foregroundColor: Colors.white,
        ),
      ],
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AsyncStatsBuilder<List<CourseEntity>>(
              asyncValue: coursesAsync,
              builder: (courses) {
                if (courses.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.menu_book_outlined,
                    title: 'Henüz ders eklenmemiş',
                    description:
                        'Yeni ders eklemek için sağ alttaki butonu kullanın.',
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...courses.map(
                        (course) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: CourseTile(course: course),
                        ),
                      ),
                      const SizedBox(height: 80),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openForm(
    BuildContext context,
    WidgetRef ref, [
    CourseEntity? existing,
  ]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CourseFormSheet(existing: existing, ref: ref),
    );
  }
}
