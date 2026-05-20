import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/inline_confirm_button.dart';
import '../../../../shared/widgets/manage_list_tile.dart';
import '../../../courses/domain/entities/course_entity.dart';
import '../../../courses/presentation/providers/course_provider.dart';
import 'course_form_sheet.dart';

class CourseTile extends ConsumerWidget {
  final CourseEntity course;

  const CourseTile({super.key, required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ManageListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.accentOrange.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.menu_book, color: AppColors.accentOrange, size: 22),
        ),
      ),
      title: course.title ?? 'İsimsiz Ders',
      badge: course.courseCode != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                course.courseCode!,
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                  color: AppColors.accentOrange,
                ),
              ),
            )
          : null,
      subtitle: course.teachers.isNotEmpty
          ? course.teachers
                .map((t) => '${t.firstName} ${t.lastName}')
                .join(', ')
          : '⚠ Hoca atanmamış',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.edit_outlined, size: 20),
            tooltip: 'Düzenle',
            onPressed: () => _edit(context, ref),
            color: AppColors.accentCyan,
          ),
          InlineConfirmButton(
            normalIcon: Icons.delete_outline,
            confirmIcon: Icons.delete_forever,
            normalLabel: 'Sil',
            confirmLabel: 'Onayla',
            onConfirm: () => _delete(context, ref),
          ),
        ],
      ),
    );
  }

  void _edit(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => CourseFormSheet(existing: course, ref: ref),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    try {
      final repo = ref.read(courseRepositoryProvider);
      final result = await repo.deleteCourse(course.id);
      result.fold(
        (failure) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Silinemedi: ${failure.message}'),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        (_) {
          ref.invalidate(departmentCoursesProvider);
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ders silindi.'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
      );
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Silinemedi: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }
}
