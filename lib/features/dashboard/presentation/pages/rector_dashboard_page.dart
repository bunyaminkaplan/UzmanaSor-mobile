import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/async_stats_builder.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/department_performance_list.dart';
import '../../../../shared/widgets/stats_summary_grid.dart';
import '../../../academic_units/presentation/providers/academic_units_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../stats/domain/entities/dashboard_stats_entity.dart';
import '../../../stats/presentation/providers/stats_provider.dart';

class RectorDashboardPage extends ConsumerStatefulWidget {
  const RectorDashboardPage({super.key});

  @override
  ConsumerState<RectorDashboardPage> createState() =>
      _RectorDashboardPageState();
}

class _RectorDashboardPageState extends ConsumerState<RectorDashboardPage> {
  int? _selectedFacultyId;

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(rectorStatsProvider(_selectedFacultyId));
    final facultiesAsync = ref.watch(facultiesProvider);
    final theme = Theme.of(context);

    return DashboardScaffold(
      title: 'Rektör Paneli',
      onRefresh: () => ref.invalidate(rectorStatsProvider(_selectedFacultyId)),
      onLogout: () => ref.read(authProvider.notifier).logout(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardPageHeader(
              title: 'Rektörlük Genel Bakış',
              description: 'Üniversite geneli soru ve cevaplanma performansı',
              borderColor: AppColors.accentNavy,
              roleName: 'Rektör Hesabı',
            ),

            // --- Fakülte Filtresi ---
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: facultiesAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (e, s) => const SizedBox.shrink(),
                data: (faculties) => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: theme.colorScheme.outlineVariant),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int?>(
                      value: _selectedFacultyId,
                      isExpanded: true,
                      hint: const Text('Tüm Fakülteler'),
                      icon: const Icon(Icons.filter_list_rounded),
                      borderRadius: BorderRadius.circular(12),
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('Tüm Fakülteler'),
                        ),
                        ...faculties.map(
                          (f) => DropdownMenuItem<int?>(
                            value: f.id,
                            child: Text(f.name),
                          ),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() => _selectedFacultyId = value);
                      },
                    ),
                  ),
                ),
              ),
            ),

            // --- Stats ---
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
