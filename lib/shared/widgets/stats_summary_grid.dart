import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../features/stats/domain/entities/dashboard_stats_entity.dart';

/// İstatistik Dashboard'larında (Dean, Rector) ortak kullanılan
/// 2x2 özet kart grid'i.
///
/// [DashboardStatsEntity] alır ve 4 temel metriği kart olarak gösterir:
/// Toplam Soru, Cevaplanan, Bekleyen, Yönlendirilen.
class StatsSummaryGrid extends StatelessWidget {
  final DashboardStatsEntity stats;

  const StatsSummaryGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 2.0,
      children: [
        _StatCard(
          title: 'Toplam Soru',
          value: stats.totalQuestions.toString(),
          icon: Icons.question_answer_rounded,
          color: AppColors.accentNavy,
        ),
        _StatCard(
          title: 'Cevaplanan',
          value: stats.answeredQuestions.toString(),
          icon: Icons.check_circle_rounded,
          color: AppColors.accentCyan,
        ),
        _StatCard(
          title: 'Bekleyen',
          value: stats.pendingQuestions.toString(),
          icon: Icons.hourglass_empty_rounded,
          color: AppColors.accentOrange,
        ),
        _StatCard(
          title: 'Yönlendirilen',
          value: stats.forwardedQuestions.toString(),
          icon: Icons.share_rounded,
          color: AppColors.textMuted,
        ),
      ],
    );
  }
}

/// Tek bir istatistik kartı. Sadece [StatsSummaryGrid] içinden kullanılır.
class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          // Sayı + başlık
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: theme.colorScheme.onSurface,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          // İkon
          Icon(icon, color: color.withValues(alpha: 0.5), size: 20),
        ],
      ),
    );
  }
}
