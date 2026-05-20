import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/entities/simple_user_entity.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/manage_form_sheet.dart';
import '../../../courses/domain/entities/course_entity.dart';
import '../../../courses/presentation/providers/course_provider.dart';
import '../../../manage_terms/domain/entities/class_term_entity.dart';
import '../../../manage_advisors/presentation/providers/manage_advisors_provider.dart';

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
  final Set<int> _selectedClassTermIds = {};
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
      _selectedClassTermIds.addAll(widget.existing!.classTerms.map((ct) => ct.id));
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
      final classTermIds = _selectedClassTermIds.toList();

      if (isEditing) {
        final result = await repo.updateCourse(
          id: widget.existing!.id,
          title: title,
          description: description.isNotEmpty ? description : null,
          courseCode: courseCode.isNotEmpty ? courseCode : null,
          teacherIds: teacherIds,
          classTermIds: classTermIds,
        );
        result.fold((f) => throw f, (_) {});
      } else {
        final result = await repo.createCourse(
          title: title,
          description: description.isNotEmpty ? description : null,
          courseCode: courseCode.isNotEmpty ? courseCode : null,
          teacherIds: teacherIds,
          classTermIds: classTermIds,
        );
        result.fold((f) => throw f, (_) {});
      }

      widget.ref.invalidate(departmentCoursesProvider);
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

          // --- Ders Kodu (sadece admin modunda) ---
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

          // --- Hoca Seçimi ---
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            decoration: BoxDecoration(
              color: theme.inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hoca Ataması (Opsiyonel)',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
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
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${_selectedTeacherIds.length} akademisyen seçildi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.accentOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // --- Sınıf Seçimi ---
          Container(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            decoration: BoxDecoration(
              color: theme.inputDecorationTheme.fillColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sınıf Ataması (Opsiyonel)',
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Dersin verildiği sınıfları seçin.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(height: 8),
                ref.watch(deptHeadClassTermsProvider).when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('Sınıflar yüklenemedi: $e'),
                  data: (classTerms) => _ClassTermMultiSelect(
                    classTerms: classTerms,
                    selectedIds: _selectedClassTermIds,
                    onChanged: () => setState(() {}),
                  ),
                ),
                if (_selectedClassTermIds.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      '${_selectedClassTermIds.length} sınıf seçildi',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.accentOrange,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _SelectableItem extends StatelessWidget {
  final bool selected;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  const _SelectableItem({
    required this.selected,
    required this.title,
    this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Material(
        color: selected
            ? AppColors.accentOrange.withValues(alpha: 0.08)
            : theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selected
                    ? AppColors.accentOrange.withValues(alpha: 0.4)
                    : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: selected ? AppColors.accentOrange : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: selected
                          ? AppColors.accentOrange
                          : theme.colorScheme.outline,
                      width: 1.5,
                    ),
                  ),
                  child: selected
                      ? const Icon(Icons.check, size: 14, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

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
    if (teachers.isEmpty) {
      return const Center(child: Text('Sistemde akademisyen bulunamadı.'));
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          final teacher = teachers[index];
          final isSelected = selectedIds.contains(teacher.id);
          return _SelectableItem(
            selected: isSelected,
            title: '${teacher.firstName} ${teacher.lastName}',
            subtitle: teacher.username,
            onTap: () {
              isSelected
                  ? selectedIds.remove(teacher.id)
                  : selectedIds.add(teacher.id);
              onChanged();
            },
          );
        },
      ),
    );
  }
}

class _ClassTermMultiSelect extends StatelessWidget {
  final List<ClassTermEntity> classTerms;
  final Set<int> selectedIds;
  final VoidCallback onChanged;

  const _ClassTermMultiSelect({
    required this.classTerms,
    required this.selectedIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (classTerms.isEmpty) {
      return const Center(child: Text('Sistemde sınıf bulunamadı.'));
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 200),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: classTerms.length,
        itemBuilder: (context, index) {
          final ct = classTerms[index];
          final isSelected = selectedIds.contains(ct.id);
          return _SelectableItem(
            selected: isSelected,
            title: ct.termDisplay,
            onTap: () {
              isSelected
                  ? selectedIds.remove(ct.id)
                  : selectedIds.add(ct.id);
              onChanged();
            },
          );
        },
      ),
    );
  }
}
