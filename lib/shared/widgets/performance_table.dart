import 'package:flutter/material.dart';
import 'package:mobile/shared/widgets/empty_state_widget.dart';

/// PerformanceTable — bölüm performans tablosu.
///
/// Web: DeanDashboard / RectorDashboard → bölüm adı, toplam soru,
/// cevaplanan, başarı oranı (progress bar).
class PerformanceTable extends StatelessWidget {
  final String title;
  final List<DepartmentPerformance> departments;

  const PerformanceTable({
    super.key,
    required this.title,
    required this.departments,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(height: 1),

          // Tablo
          if (departments.isEmpty)
            const EmptyStateWidget(title: 'Henüz veri yok')
          else
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: departments.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final dept = departments[index];
                return _DepartmentRow(dept: dept);
              },
            ),
        ],
      ),
    );
  }
}

class _DepartmentRow extends StatelessWidget {
  final DepartmentPerformance dept;

  const _DepartmentRow({required this.dept});

  Color _getProgressColor(int rate) {
    if (rate >= 80) return Colors.green;
    if (rate >= 50) return Colors.amber;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bölüm adı
          Text(
            dept.name,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          // Sayılar + progress bar
          Row(
            children: [
              // Toplam
              _StatChip(label: 'Toplam', value: dept.total.toString()),
              const SizedBox(width: 12),
              // Cevaplanan
              _StatChip(label: 'Cevaplanan', value: dept.answered.toString()),
              const SizedBox(width: 16),
              // Oran + progress bar
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '%${dept.rate}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: dept.rate / 100,
                        backgroundColor:
                            theme.colorScheme.surfaceContainerHighest,
                        valueColor: AlwaysStoppedAnimation(
                          _getProgressColor(dept.rate),
                        ),
                        minHeight: 6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final String value;

  const _StatChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.outline,
            fontSize: 10,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// Bölüm performans veri modeli.
class DepartmentPerformance {
  final String name;
  final int total;
  final int answered;
  final int rate;

  const DepartmentPerformance({
    required this.name,
    required this.total,
    required this.answered,
    required this.rate,
  });

  factory DepartmentPerformance.fromJson(Map<String, dynamic> json) {
    return DepartmentPerformance(
      name: json['name'] as String? ?? '',
      total: json['total'] as int? ?? 0,
      answered: json['answered'] as int? ?? 0,
      rate: json['rate'] as int? ?? 0,
    );
  }
}
