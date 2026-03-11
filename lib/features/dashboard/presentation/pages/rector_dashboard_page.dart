import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../shared/widgets/dashboard_drawer.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/department_performance_list.dart';
import '../../../../shared/widgets/stats_summary_grid.dart';
import '../../../academic_units/presentation/providers/academic_units_provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
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
    final user = ref.watch(authProvider).value;
    final statsAsync = ref.watch(rectorStatsProvider(_selectedFacultyId));
    final facultiesAsync = ref.watch(facultiesProvider);
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Rektör Paneli'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                ref.invalidate(rectorStatsProvider(_selectedFacultyId)),
            tooltip: 'Yenile',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authProvider.notifier).logout(),
            tooltip: 'Çıkış',
          ),
        ],
      ),
      drawer: const DashboardDrawer(),
      body: RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(rectorStatsProvider(_selectedFacultyId)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // --- Page Header ---
              DashboardPageHeader(
                title: 'Rektörlük Genel Bakış',
                description: 'Üniversite geneli soru ve cevaplanma performansı',
                borderColor: AppColors.accentNavy,
                trailing: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (user?.userType == 'school_admin')
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'Admin',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      Text(
                        'Rektör Hesabı',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                  ],
                ),
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
                      border: Border.all(
                        color: theme.colorScheme.outlineVariant,
                      ),
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
                          setState(() {
                            _selectedFacultyId = value;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ),

              // --- Stats Content ---
              statsAsync.when(
                loading: () => const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                ),
                error: (error, stack) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          size: 48,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'İstatistikler yüklenemedi:\n$error',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                data: (stats) => Padding(
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
      ),
    );
  }
}
