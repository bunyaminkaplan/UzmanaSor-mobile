import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/async_stats_builder.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/department_performance_list.dart';
import '../../../../shared/widgets/stats_summary_grid.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../stats/domain/entities/dashboard_stats_entity.dart';
import '../../../stats/presentation/providers/stats_provider.dart';

class DeanDashboardPage extends ConsumerWidget {
  const DeanDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final statsAsync = ref.watch(deanStatsProvider);

    return DashboardScaffold(
      onRefresh: () => ref.invalidate(deanStatsProvider),
      pageTitle: 'Fakülte Genel Bakış',
      header: DashboardPageHeader(
        title: 'Fakülte Genel Bakış',
        description: 'Bölümlerin soru ve cevaplanma performansı',
        borderColor: AppColors.accentNavy,
        userName: user?.facultyDetails?['name'] ?? 'Fakülte Bilgisi Yok',
        userNameColor: AppColors.accentOrange,
        roleName: 'Dekan Hesabı',
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
                      title: 'Bölüm Performans Detayları',
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
}
