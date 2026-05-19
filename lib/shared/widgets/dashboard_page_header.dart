import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

/// Dashboard Page Header — tüm dashboard'larda ortak başlık bileşeni.
///
/// Web: PageHeader.jsx → başlık, açıklama, sol border rengi, sağ içerik.
class DashboardPageHeader extends StatelessWidget {
  final String title;
  final String? description;
  final Color borderColor;

  /// Özel sağ taraf widget'ı.
  final Widget? trailing;

  const DashboardPageHeader({
    super.key,
    required this.title,
    this.description,
    this.borderColor = AppColors.accentNavy,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border(left: BorderSide(color: borderColor, width: 5)),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    description!,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
