import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/async_stats_builder.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/department_performance_list.dart';
import '../../../../shared/widgets/stats_summary_grid.dart';
import '../../../stats/domain/entities/dashboard_stats_entity.dart';
import '../../../stats/presentation/providers/stats_provider.dart';

class SchoolAdminDashboardPage extends ConsumerWidget {
  const SchoolAdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(rectorStatsProvider(null));
    final theme = Theme.of(context);

    return DashboardScaffold(
      onRefresh: () => ref.invalidate(rectorStatsProvider(null)),
      pageTitle: 'Sistem Genel Bakış',
      header: DashboardPageHeader(
        title: 'Sistem Genel Bakış',
        description: 'Sistem istatistikleri ve yönetim araçları',
        borderColor: AppColors.accentOrange,
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.accentNavy,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.accentOrange, width: 1),
          ),
          child: const Text(
            'Yetkili Yönetici',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            AsyncStatsBuilder<DashboardStatsEntity>(
              asyncValue: statsAsync,
              builder: (stats) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    StatsSummaryGrid(stats: stats),
                    const SizedBox(height: 24),
                    DepartmentPerformanceList(
                      departments: stats.departmentPerformance,
                      title: 'Üniversite Geneli Bölüm Performansları',
                    ),
                    const SizedBox(height: 24),

                    // --- Hızlı İşlemler ---
                    Text(
                      'Hızlı İşlemler',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 1.4,
                      children: [
                        _QuickActionCard(
                          icon: Icons.person_add_alt_1_rounded,
                          title: 'Kullanıcı Onayları',
                          description: 'Bekleyen başvuruları incele',
                          color: AppColors.accentNavy,
                          onTap: () => _showComingSoon(context),
                        ),
                        _QuickActionCard(
                          icon: Icons.calendar_month_rounded,
                          title: 'Dönem Yönetimi',
                          description: 'Akademik takvimi güncelle',
                          color: AppColors.accentOrange,
                          onTap: () => _showComingSoon(context),
                        ),
                        _QuickActionCard(
                          icon: Icons.shield_rounded,
                          title: 'İçerik Denetimi',
                          description: 'Raporlanan içerikleri yönet',
                          color: Colors.red,
                          onTap: () => _showComingSoon(context),
                        ),
                        _QuickActionCard(
                          icon: Icons.menu_book_rounded,
                          title: 'Ders Yönetimi',
                          description: 'Ders ekle, düzenle veya sil',
                          color: AppColors.accentCyan,
                          onTap: () => _showComingSoon(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Bu özellik yakında eklenecek.')),
    );
  }
}

/// Quick Action kart widget'ı — sadece SchoolAdmin sayfasında kullanılır.
class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.colorScheme.outlineVariant),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const Spacer(),
              Text(
                title,
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
