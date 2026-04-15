import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/courses/domain/entities/course_entity.dart';
import 'package:mobile/features/courses/presentation/providers/course_provider.dart';

/// Akademisyen profilinde gösterilen ders listesi kartı.
class CoursesSection extends ConsumerWidget {
  const CoursesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(myCoursesProvider);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBgDark,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: AppColors.accentCyan),
              const SizedBox(width: 8),
              Text(
                'Derslerim',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textHeadingDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // İçerik
          coursesAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => _buildEmptyState('Dersler yüklenemedi'),
            data: (courses) {
              if (courses.isEmpty) {
                return _buildEmptyState('Henüz atanmış ders bulunmuyor');
              }
              return Column(
                children: courses
                    .map((course) => _buildCourseRow(course))
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCourseRow(CourseEntity course) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.inputBgDark,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accentNavy.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.class_rounded,
                color: AppColors.accentNavy,
                size: 18,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    course.title ?? 'Ders #${course.id}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textHeadingDark,
                    ),
                  ),
                  if (course.courseCode != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      course.courseCode!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMutedDark,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(fontSize: 13, color: AppColors.textMutedDark),
        ),
      ),
    );
  }
}
