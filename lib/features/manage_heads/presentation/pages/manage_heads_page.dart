import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/manage_list_tile.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../academic_units/presentation/providers/academic_units_provider.dart';
import '../providers/manage_heads_provider.dart';

/// Bölüm Başkanı Yönetimi — Dekan erişimli.
///
/// Dekanın fakültesindeki bölümleri gösterir, bölüme tıklayınca
/// o bölümdeki hocaları listeler ve başkan atama/kaldırma yapar.
class ManageHeadsPage extends ConsumerWidget {
  const ManageHeadsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final facultyName = user?.facultyDetails?['name']?.toString() ?? 'Fakülte';
    final departments = _extractDepartments(user);

    return DashboardScaffold(
      title: 'Bölüm Yönetimi',
      onRefresh: () => ref.invalidate(facultiesProvider),
      onLogout: () => ref.read(authProvider.notifier).logout(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardPageHeader(
              title: 'Bölüm Yönetimi',
              description:
                  'Fakültenizdeki bölümleri seçip Bölüm Başkanlarını atayın.',
              borderColor: AppColors.accentCyan,
              userName: facultyName,
              roleName: 'FAKÜLTE',
              userNameColor: AppColors.accentOrange,
            ),

            if (departments.isEmpty)
              const EmptyStateWidget(
                icon: Icons.domain_disabled_outlined,
                title: 'Bölüm bulunamadı',
                description:
                    'Fakültenize ait bölüm bulunamadı veya yetkiniz yok.',
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    ...departments.map(
                      (dept) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _DepartmentCard(
                          departmentId: dept['id'] as int,
                          departmentName: dept['name'] as String,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Kullanıcının faculty_details → departments listesini çıkarır.
  List<Map<String, dynamic>> _extractDepartments(dynamic user) {
    if (user == null) return [];
    final details = user.facultyDetails;
    if (details == null) return [];
    final depts = details['departments'];
    if (depts is! List) return [];
    return depts
        .map<Map<String, dynamic>>(
          (d) => {'id': d['id'] as int, 'name': d['name'] as String},
        )
        .toList();
  }
}

/// Bölüm kartı — tıklayınca hoca listesi BottomSheet'ini açar.
class _DepartmentCard extends ConsumerWidget {
  final int departmentId;
  final String departmentName;

  const _DepartmentCard({
    required this.departmentId,
    required this.departmentName,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ManageListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.accentCyan.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.account_balance, color: AppColors.accentCyan),
      ),
      title: departmentName,
      subtitle: 'Akademisyenleri yönet →',
      onTap: () => _openTeachersSheet(context, ref),
      trailing: Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: theme.colorScheme.outline,
      ),
    );
  }

  void _openTeachersSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => _TeachersBottomSheet(
        departmentId: departmentId,
        departmentName: departmentName,
        parentRef: ref,
      ),
    );
  }
}

/// Bölümdeki hocalar BottomSheet'i — başkan toggle'ı.
class _TeachersBottomSheet extends ConsumerStatefulWidget {
  final int departmentId;
  final String departmentName;
  final WidgetRef parentRef;

  const _TeachersBottomSheet({
    required this.departmentId,
    required this.departmentName,
    required this.parentRef,
  });

  @override
  ConsumerState<_TeachersBottomSheet> createState() =>
      _TeachersBottomSheetState();
}

class _TeachersBottomSheetState extends ConsumerState<_TeachersBottomSheet> {
  /// Lokal toggle state — API'den dönen is_department_head bilgisi.
  /// Key: teacherId, Value: is_department_head
  final Map<int, bool> _headStatus = {};
  final Set<int> _loadingIds = {};

  Future<void> _toggleHead(int teacherId) async {
    setState(() => _loadingIds.add(teacherId));
    try {
      final ds = ref.read(toggleHeadProvider);
      final result = await ds.toggleDepartmentHead(teacherId);
      final isHead = result['is_department_head'] as bool;
      final message = result['message'] as String? ?? 'İşlem başarılı.';

      setState(() => _headStatus[teacherId] = isHead);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: isHead ? Colors.green : Colors.orange,
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
      if (mounted) setState(() => _loadingIds.remove(teacherId));
    }
  }

  @override
  Widget build(BuildContext context) {
    final teachersAsync = ref.watch(
      departmentTeachersProvider(widget.departmentId),
    );
    final theme = Theme.of(context);

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.4,
      maxChildSize: 0.95,
      expand: false,
      builder: (_, scrollController) => Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.colorScheme.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Başlık
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.departmentName,
                        style: theme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Akademisyen Listesi ve Yetkilendirme',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(),

          // Hoca Listesi
          Expanded(
            child: teachersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hocalar yüklenemedi: $e')),
              data: (teachers) {
                if (teachers.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(32),
                      child: Text(
                        'Bu bölümde kayıtlı akademisyen bulunmamaktadır.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount: teachers.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (_, i) {
                    final teacher = teachers[i];
                    // Lokal state varsa onu kullan, yoksa API'den gelen
                    // is_department_head bilgisini al
                    final isHead =
                        _headStatus[teacher.id] ??
                        _getInitialHeadStatus(teacher);
                    final isLoading = _loadingIds.contains(teacher.id);

                    return ManageListTile(
                      leading: ManageListTile.initialsAvatar(
                        name: teacher.fullName,
                        backgroundColor: isHead
                            ? Colors.green.withValues(alpha: 0.15)
                            : AppColors.accentCyan.withValues(alpha: 0.15),
                        textColor: isHead ? Colors.green : AppColors.accentCyan,
                      ),
                      title: teacher.fullName,
                      subtitle: '@${teacher.username}',
                      badge: isHead
                          ? Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: AppColors.success.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Text(
                                'Bölüm Başkanı',
                                style: theme.textTheme.labelSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.success,
                                ),
                              ),
                            )
                          : null,
                      trailing: isLoading
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : FilledButton.icon(
                              onPressed: () => _toggleHead(teacher.id),
                              icon: Icon(
                                isHead
                                    ? Icons.check_circle
                                    : Icons.star_outline,
                                size: 18,
                              ),
                              label: Text(
                                isHead ? 'Başkan' : 'Başkan Yap',
                                style: const TextStyle(fontSize: 12),
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: isHead
                                    ? Colors.green
                                    : theme.colorScheme.surfaceContainerHighest,
                                foregroundColor: isHead
                                    ? Colors.white
                                    : theme.colorScheme.onSurface,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                ),
                                minimumSize: const Size(0, 36),
                              ),
                            ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// SimpleUserEntity'de isDepartmentHead yok, varsayılan false.
  /// Gerçek değer toggle sonrası _headStatus map'inde tutulur.
  bool _getInitialHeadStatus(dynamic teacher) {
    // SimpleUserEntity isDepartmentHead taşımıyor — ilk yüklemede false.
    // Gerçek bilgi toggle sonrası API response'undan gelir.
    return false;
  }
}
