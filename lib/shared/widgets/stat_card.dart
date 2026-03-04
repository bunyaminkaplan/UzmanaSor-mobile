import 'package:flutter/material.dart';

/// StatCard — istatistik dashboard'larında kullanılan sayı kartı.
///
/// Web: DeanDashboard / RectorDashboard / SchoolAdminDashboard →
///   border-l-8 + CountUp sayı + label + ikon.
///
/// Mobil: Animated counter yerine basit Text (performans).
/// [borderColor] sol kenar rengi, [icon] sağ üst köşe ikonu.
class StatCard extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color borderColor;
  final Color? iconColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.borderColor = Colors.indigo,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveIconColor = iconColor ?? borderColor;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border(left: BorderSide(color: borderColor, width: 6)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value.toString(),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                label.toUpperCase(),
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Icon(
            icon,
            size: 36,
            color: effectiveIconColor.withValues(alpha: 0.2),
          ),
        ],
      ),
    );
  }
}
