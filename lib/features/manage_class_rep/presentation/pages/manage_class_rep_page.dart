import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/async_stats_builder.dart';
import '../../../../shared/widgets/confirm_dialog.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/manage_list_tile.dart';
import '../../data/datasources/advisor_student_remote_data_source.dart';
import '../../domain/entities/advisor_student_entity.dart';
import '../providers/advisor_student_provider.dart';

/// Danışman Hoca — Sınıf Temsilcisi Seçimi Sayfası
///
/// Web: ManageClassRepPage.jsx paritesi.
/// Danışman olunan sınıflardaki öğrencileri listeleyip
/// birini Sınıf Temsilcisi olarak atayabilir.
class ManageClassRepPage extends ConsumerStatefulWidget {
  const ManageClassRepPage({super.key});

  @override
  ConsumerState<ManageClassRepPage> createState() => _ManageClassRepPageState();
}

class _ManageClassRepPageState extends ConsumerState<ManageClassRepPage> {
  String _searchQuery = '';
  int? _processingId;

  List<AdvisorStudentEntity> _filter(List<AdvisorStudentEntity> students) {
    if (_searchQuery.isEmpty) return students;
    final q = _searchQuery.toLowerCase();
    return students.where((s) {
      final name = s.fullName.toLowerCase();
      final number = (s.studentNumber ?? '').toLowerCase();
      return name.contains(q) || number.contains(q);
    }).toList();
  }

  Future<void> _setRepresentative(AdvisorStudentEntity student) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Temsilci Atama',
      message:
          '${student.fullName} isimli öğrenciyi Sınıf Temsilcisi yapmak istiyor musunuz?\n\nMevcut temsilci varsa yetkisi alınacaktır.',
      confirmLabel: 'Temsilci Yap',
      confirmColor: AppColors.accentOrange,
    );
    if (!confirmed) return;

    setState(() => _processingId = student.id);
    try {
      final ds = ref.read(advisorStudentDataSourceProvider);
      await ds.setRepresentative(student.id);
      ref.invalidate(advisorStudentsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${student.fullName} artık Sınıf Temsilcisi.'),
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
      if (mounted) setState(() => _processingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final studentsAsync = ref.watch(advisorStudentsProvider);

    return DashboardScaffold(
      onRefresh: () => ref.invalidate(advisorStudentsProvider),
      pageTitle: 'Sınıf Temsilcisi Seçimi',
      header: const DashboardPageHeader(
        title: 'Sınıf Temsilcisi Seçimi',
        description:
            'Danışmanı olduğunuz sınıfın temsilcisini buradan belirleyebilirsiniz.',
        borderColor: AppColors.accentCyan,
      ),
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
                  hintText: 'Öğrenci ara (İsim veya Numara)...',
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

            // --- Öğrenci Listesi ---
            AsyncStatsBuilder<List<AdvisorStudentEntity>>(
              asyncValue: studentsAsync,
              builder: (students) {
                final filtered = _filter(students);

                if (filtered.isEmpty) {
                  return EmptyStateWidget(
                    icon: Icons.people_outline,
                    title: _searchQuery.isNotEmpty
                        ? 'Aramayla eşleşen öğrenci bulunamadı'
                        : 'Öğrenci bulunamadı',
                    description: _searchQuery.isNotEmpty
                        ? 'Farklı bir arama terimi deneyin.'
                        : 'Danışmanı olduğunuz bir sınıf/dönem olduğundan emin olun.',
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...filtered.map(
                        (student) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _StudentTile(
                            student: student,
                            isProcessing: _processingId == student.id,
                            onSetRep: () => _setRepresentative(student),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
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
}

// ---------------------------------------------------------------------------
// Öğrenci kartı
// ---------------------------------------------------------------------------
class _StudentTile extends StatelessWidget {
  final AdvisorStudentEntity student;
  final bool isProcessing;
  final VoidCallback onSetRep;

  const _StudentTile({
    required this.student,
    required this.isProcessing,
    required this.onSetRep,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isRep = student.isRepresentative;

    return ManageListTile(
      borderColor: isRep ? AppColors.accentOrange : null,
      leading: CircleAvatar(
        radius: 22,
        backgroundColor: isRep
            ? AppColors.accentOrange
            : theme.colorScheme.surfaceContainerHighest,
        child: Text(
          student.initials,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: isRep ? Colors.white : theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      title: student.fullName,
      badge: isRep
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.accentOrange.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                'TEMSİLCİ',
                style: theme.textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.accentOrange,
                ),
              ),
            )
          : null,
      subtitle: [
        if (student.studentNumber != null) student.studentNumber!,
        if (student.departmentName != null) student.departmentName!,
      ].join(' | '),
      trailing: isRep
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accentOrange.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    size: 16,
                    color: AppColors.accentOrange,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Mevcut',
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.accentOrange,
                    ),
                  ),
                ],
              ),
            )
          : FilledButton.icon(
              onPressed: isProcessing ? null : onSetRep,
              icon: isProcessing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.workspace_premium, size: 16),
              label: const Text('Temsilci Yap'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                textStyle: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
    );
  }
}
