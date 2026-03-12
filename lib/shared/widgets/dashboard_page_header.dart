import 'package:flutter/material.dart';

/// Dashboard Page Header — tüm dashboard'larda ortak başlık bileşeni.
///
/// Web: PageHeader.jsx → başlık, açıklama, sol border rengi, sağ içerik.
///
/// Kullanıcı/rol bilgisi göstermek için [userName] ve [roleName] parametreleri
/// kullanılır. Daha özel bir sağ içerik gerektiğinde ise [trailing] widget'ı
/// tercih edilir. [trailing] verildiğinde userName/roleName göz ardı edilir.
class DashboardPageHeader extends StatelessWidget {
  final String title;
  final String? description;
  final Color borderColor;

  /// Özel sağ taraf widget'ı — verilirse userName/roleName gösterilmez.
  final Widget? trailing;

  /// Standart kullanıcı adı (sağ üst köşede gösterilir).
  final String? userName;

  /// Standart rol etiketi (kullanıcı adının altında gösterilir).
  final String? roleName;

  /// Kullanıcı adı rengi (varsayılan: accentOrange).
  final Color? userNameColor;

  const DashboardPageHeader({
    super.key,
    required this.title,
    this.description,
    this.borderColor = Colors.indigo,
    this.trailing,
    this.userName,
    this.roleName,
    this.userNameColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // trailing verilmemişse ve userName/roleName varsa standart trailing üret
    final effectiveTrailing = trailing ?? _buildDefaultTrailing(theme);

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
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (description != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    description!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (effectiveTrailing != null) effectiveTrailing,
        ],
      ),
    );
  }

  /// userName/roleName verilmişse standart trailing Column döndürür.
  Widget? _buildDefaultTrailing(ThemeData theme) {
    if (userName == null && roleName == null) return null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (userName != null)
          Text(
            userName!,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: userNameColor ?? Colors.orange,
            ),
          ),
        if (roleName != null)
          Text(
            roleName!,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
      ],
    );
  }
}
