import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/async_stats_builder.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/manage_form_sheet.dart';
import '../../../../shared/widgets/manage_list_tile.dart';
import '../../domain/entities/class_term_entity.dart';
import '../providers/class_term_provider.dart';

/// Dönem Yönetimi Sayfası — SchoolAdmin
///
/// Sınıf/dönem CRUD işlemlerini yönetir.
class ManageTermsPage extends ConsumerWidget {
  const ManageTermsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final termsAsync = ref.watch(classTermsProvider);

    return DashboardScaffold(
      onRefresh: () => ref.invalidate(classTermsProvider),
      pageTitle: 'Dönem ve Sınıf Yönetimi',
      header: const DashboardPageHeader(
        title: 'Dönem ve Sınıf Yönetimi',
        description:
            'Bölümlerin aktif dönemlerini ve sınıf danışmanlarını yönetin.',
        borderColor: AppColors.accentOrange,
      ),
      fabs: [
        FloatingActionButton.extended(
          onPressed: () => _openForm(context, ref),
          icon: const Icon(Icons.add),
          label: const Text('Yeni Dönem'),
          backgroundColor: AppColors.accentOrange,
          foregroundColor: Colors.white,
        ),
      ],
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AsyncStatsBuilder<List<ClassTermEntity>>(
              asyncValue: termsAsync,
              builder: (terms) {
                if (terms.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.event_note_outlined,
                    title: 'Henüz dönem tanımlanmamış',
                    description:
                        'Yeni dönem eklemek için sağ alttaki butonu kullanın.',
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...terms.map(
                        (term) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _TermTile(term: term),
                        ),
                      ),
                      const SizedBox(height: 80), // FAB için boşluk
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
    ClassTermEntity? existing,
  ]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TermFormSheet(existing: existing, ref: ref),
    );
  }
}

/// Tek bir dönem kartı — Düzenle/Sil aksiyonları.
class _TermTile extends ConsumerWidget {
  final ClassTermEntity term;

  const _TermTile({required this.term});

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
        child: Center(
          child: Text(
            '${term.term}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.accentOrange,
            ),
          ),
        ),
      ),
      title: term.departmentName,
      badge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.accentOrange.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          term.termDisplay,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.accentOrange,
          ),
        ),
      ),
      subtitle: term.hasAdvisor
          ? '👤 ${term.advisorName}'
          : '⚠ Danışman atanmamış',
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
      builder: (_) => _TermFormSheet(existing: term, ref: ref),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Dönem Silinecek',
      message:
          '${term.departmentName} — ${term.termDisplay} silinecek. Bu işlem geri alınamaz.',
      confirmLabel: 'Sil',
      confirmColor: AppColors.error,
    );
    if (!confirmed) return;

    try {
      final repo = ref.read(classTermRepositoryProvider);
      await repo.delete(term.id);
      ref.invalidate(classTermsProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dönem silindi.'),
            backgroundColor: AppColors.success,
          ),
        );
      }
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

/// Dönem oluştur/düzenle BottomSheet formu.
class _TermFormSheet extends ConsumerStatefulWidget {
  final ClassTermEntity? existing;
  final WidgetRef ref;

  const _TermFormSheet({this.existing, required this.ref});

  @override
  ConsumerState<_TermFormSheet> createState() => _TermFormSheetState();
}

class _TermFormSheetState extends ConsumerState<_TermFormSheet> {
  int? _selectedDepartment;
  int _selectedTerm = 1;
  int? _selectedAdvisor;
  bool _isSubmitting = false;

  bool get isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _selectedDepartment = widget.existing!.departmentId;
      _selectedTerm = widget.existing!.term;
      _selectedAdvisor = widget.existing!.advisorId;
    }
  }

  Future<void> _submit() async {
    if (_selectedDepartment == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Lütfen bir bölüm seçin.')));
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final repo = widget.ref.read(classTermRepositoryProvider);
      if (isEditing) {
        await repo.update(
          id: widget.existing!.id,
          departmentId: _selectedDepartment!,
          term: _selectedTerm,
          advisorId: _selectedAdvisor,
        );
      } else {
        await repo.create(
          departmentId: _selectedDepartment!,
          term: _selectedTerm,
          advisorId: _selectedAdvisor,
        );
      }
      widget.ref.invalidate(classTermsProvider);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isEditing ? 'Dönem güncellendi.' : 'Yeni dönem oluşturuldu.',
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
    final deptsAsync = ref.watch(flatDepartmentsProvider);
    final teachersAsync = ref.watch(allTeachersProvider);
    final theme = Theme.of(context);

    return ManageFormSheet(
      title: isEditing ? 'Dönemi Düzenle' : 'Yeni Dönem Oluştur',
      submitLabel: isEditing ? 'Güncelle' : 'Oluştur',
      isLoading: _isSubmitting,
      onSubmit: _submit,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Bölüm Seçimi ---
          Text(
            'Bölüm',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          deptsAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Bölümler yüklenemedi: $e'),
            data: (depts) => DropdownButtonFormField<int>(
              initialValue: _selectedDepartment,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              hint: const Text('Bölüm seçiniz...'),
              items: depts
                  .map(
                    (d) => DropdownMenuItem<int>(
                      value: d['id'] as int,
                      child: Text(
                        d['name'] as String,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedDepartment = v),
            ),
          ),
          const SizedBox(height: 20),

          // --- Dönem / Sınıf Seçimi ---
          Text(
            'Dönem / Sınıf',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<int>(
            initialValue: _selectedTerm,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 14,
              ),
            ),
            items: List.generate(
              4,
              (i) => DropdownMenuItem(
                value: i + 1,
                child: Text('${i + 1}. Sınıf'),
              ),
            ),
            onChanged: (v) => setState(() => _selectedTerm = v ?? 1),
          ),
          const SizedBox(height: 20),

          // --- Danışman Seçimi (Opsiyonel) ---
          Text(
            'Sınıf Danışmanı (Opsiyonel)',
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Sadece 'Akademisyen' rolündeki kullanıcılar listelenir.",
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 8),
          teachersAsync.when(
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Hocalar yüklenemedi: $e'),
            data: (teachers) => DropdownButtonFormField<int?>(
              initialValue: _selectedAdvisor,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 14,
                ),
              ),
              hint: const Text('Atanmamış'),
              items: [
                const DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Atanmamış'),
                ),
                ...teachers.map(
                  (t) => DropdownMenuItem<int?>(
                    value: t.id,
                    child: Text(
                      '${t.firstName} ${t.lastName}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
              onChanged: (v) => setState(() => _selectedAdvisor = v),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
