import 'package:flutter/material.dart';

/// ChartCard — grafik container widget'ı.
///
/// Web: DeanDashboard / RectorDashboard → başlık + chart alanı.
/// Mobil: Chart kütüphanesi (fl_chart vb.) olmadan, sadece container sağlar.
/// İçerisine herhangi bir widget (chart) yerleştirilebilir.
class ChartCard extends StatelessWidget {
  final String title;
  final Widget child;
  final double? height;

  const ChartCard({
    super.key,
    required this.title,
    required this.child,
    this.height = 250,
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
          // Chart Alanı
          SizedBox(
            height: height,
            child: Padding(padding: const EdgeInsets.all(16), child: child),
          ),
        ],
      ),
    );
  }
}
