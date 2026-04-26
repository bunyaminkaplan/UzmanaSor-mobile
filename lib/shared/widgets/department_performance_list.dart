import 'package:flutter/material.dart';
import '../../../features/stats/domain/entities/dashboard_stats_entity.dart';
import 'package:mobile/shared/widgets/empty_state_widget.dart';

/// İstatistik Dashboard'larında (Dean, Rector) ortak kullanılan
/// bölüm performans listesi widget'ı.
///
/// Her bölümün adını, toplam/cevaplanan soru sayısını ve
/// yüzdesel başarı oranını progress bar ile gösterir.
class DepartmentPerformanceList extends StatelessWidget {
  final List<DepartmentPerformanceEntity> departments;
  final String title;

  const DepartmentPerformanceList({
    super.key,
    required this.departments,
    this.title = 'Bölüm Performans Detayları',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        if (departments.isEmpty)
          const EmptyStateWidget(
            icon: Icons.bar_chart_outlined,
            title: 'Henüz bölüm istatistiği bulunmuyor',
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: departments.length,
            separatorBuilder: (context, index) => const SizedBox(height: 8),
            itemBuilder: (context, index) {
              final dept = departments[index];
              final progressColor = dept.rate >= 80
                  ? Colors.green
                  : (dept.rate >= 50 ? Colors.orange : Colors.red);

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outlineVariant),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dept.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Toplam: ${dept.total}',
                          style: theme.textTheme.bodySmall,
                        ),
                        Text(
                          'Cevaplanan: ${dept.answered}',
                          style: theme.textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: dept.total > 0
                                ? dept.answered / dept.total
                                : 0,
                            backgroundColor: progressColor.withValues(
                              alpha: 0.2,
                            ),
                            color: progressColor,
                            minHeight: 8,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(width: 12),
                        SizedBox(
                          width: 45,
                          child: Text(
                            '%${dept.rate}',
                            textAlign: TextAlign.end,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: progressColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
      ],
    );
  }
}
