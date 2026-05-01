import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/manage_terms/domain/entities/class_term_entity.dart';
import '../providers/manage_advisors_provider.dart';

/// Bölüm başkanı için danışman atama sayfası.
///
/// Bölüme ait tüm dönemleri (sınıfları) listeler ve her biri için
/// bölümdeki hocalardan danışman seçme imkanı sunar.
class ManageAdvisorsPage extends ConsumerWidget {
  const ManageAdvisorsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final termsAsync = ref.watch(deptHeadClassTermsProvider);
    final teachersAsync = ref.watch(deptHeadTeachersProvider);

    return DashboardScaffold(
      onRefresh: () async {
        ref.invalidate(deptHeadClassTermsProvider);
        ref.invalidate(deptHeadTeachersProvider);
      },
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardPageHeader(
              title: 'Sınıf Danışmanlığı Yönetimi',
              description:
                  'Bölümünüze ait sınıflara (dönemlere) danışman hoca atayın.',
              borderColor: AppColors.accentCyan,
              userName: user?.username ?? 'Kullanıcı',
              roleName: 'BÖLÜM BAŞKANI',
              userNameColor: AppColors.accentCyan,
            ),
            termsAsync.when(
              loading: () => const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (e, _) => Padding(
                padding: const EdgeInsets.all(32),
                child: Center(child: Text('Dönemler yüklenemedi: $e')),
              ),
              data: (terms) {
                if (terms.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.event_busy_outlined,
                    title: 'Dönem bulunamadı',
                    description:
                        'Bölümünüze ait sınıf/dönem kaydı bulunmamaktadır.',
                  );
                }

                // Hocalar yüklendiyse formları göster
                return teachersAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: CircularProgressIndicator()),
                  ),
                  error: (e, _) => Padding(
                    padding: const EdgeInsets.all(32),
                    child: Center(child: Text('Hocalar yüklenemedi: $e')),
                  ),
                  data: (teachers) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...terms.map(
                          (term) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _AdvisorAssignmentCard(
                              term: term,
                              teachers: teachers,
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
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

/// Tek bir sınıf (dönem) için danışman atama kartı.
class _AdvisorAssignmentCard extends ConsumerStatefulWidget {
  final ClassTermEntity term;
  final List<dynamic> teachers;

  const _AdvisorAssignmentCard({required this.term, required this.teachers});

  @override
  ConsumerState<_AdvisorAssignmentCard> createState() =>
      _AdvisorAssignmentCardState();
}

class _AdvisorAssignmentCardState
    extends ConsumerState<_AdvisorAssignmentCard> {
  int? _selectedAdvisor;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _selectedAdvisor = widget.term.advisorId;
  }

  Future<void> _handleAssign(int? advisorId) async {
    setState(() {
      _selectedAdvisor = advisorId;
      _isLoading = true;
    });

    try {
      final ds = ref.read(manageAdvisorsDataSourceProvider);
      final message = await ds.assignAdvisor(widget.term.id, advisorId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: AppColors.success,
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      // Başarılı olursa listeyi de yenileyelim ki state güncel kalsın
      ref.invalidate(deptHeadClassTermsProvider);
    } catch (e) {
      // Hata durumunda rollback
      setState(() => _selectedAdvisor = widget.term.advisorId);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Atama başarısız: $e'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.term.departmentName,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (_selectedAdvisor != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppColors.success.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 14,
                        color: AppColors.success,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'AKTİF',
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            widget.term.termDisplay,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.accentOrange,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'DANIŞMAN SEÇİMİ',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.outline,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 8),
          Stack(
            alignment: Alignment.centerRight,
            children: [
              DropdownButtonFormField<int?>(
                initialValue:
                    _selectedAdvisor != null &&
                        widget.teachers.any((t) => t.id == _selectedAdvisor)
                    ? _selectedAdvisor
                    : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  fillColor: theme.colorScheme.surface,
                  filled: true,
                ),
                hint: const Text('Atanmamış'),
                items: [
                  const DropdownMenuItem<int?>(
                    value: null,
                    child: Text('-- Atanmamış --'),
                  ),
                  ...widget.teachers.map(
                    (t) => DropdownMenuItem<int?>(
                      value: t.id,
                      child: Text(
                        '${t.firstName} ${t.lastName} (@${t.username})',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
                onChanged: _isLoading ? null : _handleAssign,
              ),
              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.only(right: 32),
                  child: SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
