import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/simple_user_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/async_stats_builder.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/manage_form_sheet.dart';
import '../../../../shared/widgets/manage_list_tile.dart';
import '../../../courses/domain/entities/course_entity.dart';
import '../../../courses/presentation/providers/course_provider.dart';

/// Bölüm Başkanı — Ders Yönetimi Sayfası
///
/// Web: ManageCourses.jsx paritesi.
/// CRUD: Ders listesi + yeni ders oluştur + düzenle + sil.
class ManageCoursesPage extends ConsumerWidget {
  const ManageCoursesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final coursesAsync = ref.watch(coursesProvider);

    return DashboardScaffold(
      onRefresh: () => ref.invalidate(coursesProvider),
      pageTitle: 'Ders Yönetimi',
      header: const DashboardPageHeader(
        title: 'Ders Yönetimi',
        description: 'Bölümünüze ait dersleri yönetin ve hoca atayın.',
        borderColor: AppColors.accentOrange,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Yeni Ders'),
        backgroundColor: AppColors.accentOrange,
        foregroundColor: Colors.white,
      ),
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
                          child: _CourseTile(course: course),
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

// ---------------------------------------------------------------------------
// Tek bir ders kartı
// ---------------------------------------------------------------------------
class _CourseTile extends ConsumerWidget {
  final CourseEntity course;

  const _CourseTile({required this.course});

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
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 20),
            tooltip: 'Sil',
            onPressed: () => _delete(context, ref),
            color: AppColors.error,
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
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Ders Silinecek',
      message:
          '"${course.displayName}" silinecek.\nBu derse bağlı sorular etkilenebilir.',
      confirmLabel: 'Sil',
      confirmColor: AppColors.error,
    );
    if (!confirmed) return;

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

// ---------------------------------------------------------------------------
// Ders oluştur/düzenle BottomSheet formu
// ---------------------------------------------------------------------------
class CourseFormSheet extends ConsumerStatefulWidget {
  final CourseEntity? existing;
  final WidgetRef ref;

  /// Admin modu — course_code alanı gösterilir.
  final bool showCourseCode;

  const CourseFormSheet({
    super.key,
    this.existing,
    required this.ref,
    this.showCourseCode = false,
  });

  @override
  ConsumerState<CourseFormSheet> createState() => _CourseFormSheetState();
}

class _CourseFormSheetState extends ConsumerState<CourseFormSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _codeCtrl;
  final Set<int> _selectedTeacherIds = {};
  bool _isSubmitting = false;

  bool get isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.existing?.title ?? '');
    _descCtrl = TextEditingController(text: widget.existing?.description ?? '');
    _codeCtrl = TextEditingController(text: widget.existing?.courseCode ?? '');
    if (widget.existing != null) {
      _selectedTeacherIds.addAll(widget.existing!.teachers.map((t) => t.id));
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _codeCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Ders adı boş bırakılamaz.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final repo = widget.ref.read(courseRepositoryProvider);
      final description = _descCtrl.text.trim();
      final courseCode = _codeCtrl.text.trim();
      final teacherIds = _selectedTeacherIds.toList();

      if (isEditing) {
        final result = await repo.updateCourse(
          id: widget.existing!.id,
          title: title,
          description: description.isNotEmpty ? description : null,
          courseCode: courseCode.isNotEmpty ? courseCode : null,
          teacherIds: teacherIds,
        );
        result.fold((f) => throw f, (_) {});
      } else {
        final result = await repo.createCourse(
          title: title,
          description: description.isNotEmpty ? description : null,
          courseCode: courseCode.isNotEmpty ? courseCode : null,
          teacherIds: teacherIds,
        );
        result.fold((f) => throw f, (_) {});
      }

      widget.ref.invalidate(coursesProvider);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Ders güncellendi.' : 'Yeni ders oluşturuldu.',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İşlem başarısız: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final teachersAsync = ref.watch(allTeachersForCoursesProvider);
    final theme = Theme.of(context);

    return ManageFormSheet(
      title: isEditing ? 'Dersi Düzenle' : 'Yeni Ders Oluştur',
      submitLabel: isEditing ? 'Güncelle' : 'Oluştur',
      isLoading: _isSubmitting,
      onSubmit: _submit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Ders Adı ---
          Text(
            'Ders Adı *',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _titleCtrl,
            decoration: const InputDecoration(
              hintText: 'örn. Veri Yapıları ve Algoritmalar',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- Ders Kodu (sadece admin modunda veya düzenleme) ---
          if (widget.showCourseCode) ...[
            Text(
              'Ders Kodu',
              style: theme.textTheme.labelLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Boş bırakırsanız otomatik üretilir.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _codeCtrl,
              decoration: const InputDecoration(
                hintText: 'örn. CS101',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              style: const TextStyle(fontFamily: 'monospace'),
            ),
            const SizedBox(height: 20),
          ],

          // --- Açıklama ---
          Text(
            'Açıklama (Opsiyonel)',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _descCtrl,
            maxLines: 3,
            decoration: const InputDecoration(
              hintText: 'Dersin kısa açıklaması...',
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // --- Hoca Seçimi (Multi-select) ---
          Text(
            'Hoca Ataması (Opsiyonel)',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Sonradan da atanabilir.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          teachersAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Hocalar yüklenemedi: $e'),
            data: (teachers) => _TeacherMultiSelect(
              teachers: teachers,
              selectedIds: _selectedTeacherIds,
              onChanged: () => setState(() {}),
            ),
          ),
          if (_selectedTeacherIds.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '${_selectedTeacherIds.length} akademisyen seçildi',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.accentOrange,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hoca Multi-Select checkbox listesi
// ---------------------------------------------------------------------------
class _TeacherMultiSelect extends StatelessWidget {
  final List<SimpleUserEntity> teachers;
  final Set<int> selectedIds;
  final VoidCallback onChanged;

  const _TeacherMultiSelect({
    required this.teachers,
    required this.selectedIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (teachers.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: theme.colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(child: Text('Sistemde akademisyen bulunamadı.')),
      );
    }

    return Container(
      constraints: const BoxConstraints(maxHeight: 180),
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: teachers.length,
        separatorBuilder: (_, _) =>
            Divider(height: 1, color: theme.colorScheme.outlineVariant),
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          final isSelected = selectedIds.contains(teacher.id);

          return CheckboxListTile(
            value: isSelected,
            dense: true,
            controlAffinity: ListTileControlAffinity.leading,
            activeColor: AppColors.accentOrange,
            title: Text(
              '${teacher.firstName} ${teacher.lastName}',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              teacher.username,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.outline,
              ),
            ),
            onChanged: (checked) {
              if (checked == true) {
                selectedIds.add(teacher.id);
              } else {
                selectedIds.remove(teacher.id);
              }
              onChanged();
            },
          );
        },
      ),
    );
  }
}
