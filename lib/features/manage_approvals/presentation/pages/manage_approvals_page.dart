import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/async_stats_builder.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/manage_list_tile.dart';
import '../../domain/entities/pending_user_entity.dart';
import '../providers/approval_provider.dart';

/// Kullanıcı Onaylama Sayfası — Bölüm başkanı / Dekan / SchoolAdmin
///
/// Bekleyen başvuruları listeler, onaylama/reddetme aksiyonları sunar.
class ManageApprovalsPage extends ConsumerWidget {
  const ManageApprovalsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingUsersProvider);

    return DashboardScaffold(
      onRefresh: () => ref.invalidate(pendingUsersProvider),
      pageTitle: 'Onay İşlemleri',
      header: const DashboardPageHeader(
        title: 'Onay İşlemleri',
        description: 'Bölümünüze kayıt olan akademisyenleri onaylayın.',
        borderColor: AppColors.accentOrange,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AsyncStatsBuilder<List<PendingUserEntity>>(
              asyncValue: pendingAsync,
              builder: (users) {
                if (users.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.inbox_outlined,
                    title: 'Bekleyen başvuru yok',
                    description:
                        'Tüm onay süreçleri tamamlanmış durumda. Yeni başvurular geldiğinde burada listelenecektir.',
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Sayaç
                      Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(
                            context,
                          ).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Toplam: ${users.length} bekleyen',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                      // Kullanıcı Listesi
                      ...users.map(
                        (user) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _UserApprovalTile(user: user),
                        ),
                      ),
                      const SizedBox(height: 32),
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

/// Tek bir onay bekleyen kullanıcı kartı.
class _UserApprovalTile extends ConsumerStatefulWidget {
  final PendingUserEntity user;

  const _UserApprovalTile({required this.user});

  @override
  ConsumerState<_UserApprovalTile> createState() => _UserApprovalTileState();
}

class _UserApprovalTileState extends ConsumerState<_UserApprovalTile> {
  bool _isLoading = false;

  Future<void> _handleAction(String action) async {
    setState(() => _isLoading = true);
    try {
      final repo = ref.read(approvalRepositoryProvider);
      final message = await repo.approveUser(widget.user.id, action);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            backgroundColor: action == 'approved'
                ? Colors.green
                : Colors.red.shade700,
          ),
        );
      }
      // Listeyi yenile
      ref.invalidate(pendingUsersProvider);
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
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final theme = Theme.of(context);

    return ManageListTile(
      leading: ManageListTile.initialsAvatar(
        name: user.fullName,
        backgroundColor: AppColors.accentCyan.withValues(alpha: 0.15),
        textColor: AppColors.accentCyan,
      ),
      title: user.fullName,
      subtitle: user.email,
      badge: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.accentCyan.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: AppColors.accentCyan.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          user.userTypeDisplay,
          style: theme.textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.accentCyan,
          ),
        ),
      ),
      trailing: _isLoading
          ? const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Reddet
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  color: AppColors.error,
                  tooltip: 'Reddet',
                  onPressed: () => _handleAction('rejected'),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.error.withValues(alpha: 0.08),
                  ),
                ),
                const SizedBox(width: 6),
                // Onayla
                IconButton(
                  icon: const Icon(Icons.check_rounded),
                  color: AppColors.success,
                  tooltip: 'Onayla',
                  onPressed: () => _handleAction('approved'),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.success.withValues(alpha: 0.1),
                  ),
                ),
              ],
            ),
    );
  }
}
