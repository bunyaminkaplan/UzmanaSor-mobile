import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/async_stats_builder.dart';
import '../../../../shared/widgets/inline_confirm_button.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/manage_list_tile.dart';
import '../../../courses/domain/entities/course_entity.dart';
import '../../../courses/presentation/providers/course_provider.dart';
import 'manage_courses_page.dart' show CourseFormSheet;

/// School Admin — Ders Yönetimi Sayfası
///
/// Web: AdminManageCoursesPage.jsx paritesi.
/// Bölüm başkanı versiyonuna ek olarak:
///   - Search bar (ders adı / kodu filtreleme)
///   - Ders kodu alanı (formda)
///   - İstatistik satırı (toplam / hoca atanmış / atanmamış)
class AdminManageCoursesPage extends ConsumerStatefulWidget {
  const AdminManageCoursesPage({super.key});

  @override
  ConsumerState<AdminManageCoursesPage> createState() =>
      _AdminManageCoursesPageState();
}

class _AdminManageCoursesPageState
    extends ConsumerState<AdminManageCoursesPage> {
  String _searchQuery = '';

  List<CourseEntity> _filterCourses(List<CourseEntity> courses) {
    if (_searchQuery.isEmpty) return courses;
    final q = _searchQuery.toLowerCase();
    return courses.where((c) {
      final title = (c.title ?? '').toLowerCase();
      final code = (c.courseCode ?? '').toLowerCase();
      return title.contains(q) || code.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(coursesProvider);

    return DashboardScaffold(
      onRefresh: () => ref.invalidate(coursesProvider),
      pageTitle: 'Ders Yönetimi',
      header: const DashboardPageHeader(
        title: 'Ders Yönetimi',
        description:
            'Sistemdeki tüm dersleri görüntüleyin, ekleyin, düzenleyin veya silin.',
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

            // --- Arama Çubuğu ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Ders adı veya kodu ara...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (v) => setState(() => _searchQuery = v),
              ),
            ),

            const SizedBox(height: 12),

            // --- İstatistikler + Liste ---
            AsyncStatsBuilder<List<CourseEntity>>(
              asyncValue: coursesAsync,
              builder: (courses) {
                final filtered = _filterCourses(courses);
                final assignedCount = courses
                    .where((c) => c.teachers.isNotEmpty)
                    .length;
                final unassignedCount = courses
                    .where((c) => c.teachers.isEmpty)
                    .length;

                return Column(
                  children: [
                    // --- Stats row ---
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          _StatChip(
                            label: 'Toplam Ders',
                            value: '${courses.length}',
                            color: AppColors.accentOrange,
                          ),
                          const SizedBox(width: 8),
                          _StatChip(
                            label: 'Hoca Atanmış',
                            value: '$assignedCount',
                            color: AppColors.accentCyan,
                          ),
                          const SizedBox(width: 8),
                          _StatChip(
                            label: 'Atanmamış',
                            value: '$unassignedCount',
                            color: AppColors.error,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (filtered.isEmpty)
                      EmptyStateWidget(
                        icon: Icons.menu_book_outlined,
                        title: _searchQuery.isNotEmpty
                            ? 'Aramayla eşleşen ders bulunamadı'
                            : 'Henüz ders eklenmemiş',
                        description: _searchQuery.isNotEmpty
                            ? 'Farklı bir arama terimi deneyin.'
                            : 'Yeni ders eklemek için sağ alttaki butonu kullanın.',
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          children: [
                            ...filtered.map(
                              (course) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: _AdminCourseTile(course: course),
                              ),
                            ),
                            const SizedBox(height: 80),
                          ],
                        ),
                      ),
                  ],
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
      builder: (_) =>
          CourseFormSheet(existing: existing, ref: ref, showCourseCode: true),
    );
  }
}

// ---------------------------------------------------------------------------
// İstatistik Chip
// ---------------------------------------------------------------------------
class _StatChip extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatChip({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Admin ders kartı — Edit / Delete
// ---------------------------------------------------------------------------
class _AdminCourseTile extends ConsumerWidget {
  final CourseEntity course;

  const _AdminCourseTile({required this.course});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ManageListTile(
      borderColor: AppColors.accentOrange,
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
      builder: (_) =>
          CourseFormSheet(existing: course, ref: ref, showCourseCode: true),
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
          ref.invalidate(coursesProvider);
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
