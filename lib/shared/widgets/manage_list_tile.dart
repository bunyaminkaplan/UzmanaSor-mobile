import 'package:flutter/material.dart';

/// Yönetim listelerindeki standart satır kartı.
///
/// Sol kısımda avatar/ikon, orta kısımda başlık + alt başlık + opsiyonel badge,
/// sağ kısımda aksiyon widget'ı içerir.
///
/// Kullanım:
/// ```dart
/// ManageListTile(
///   leading: CircleAvatar(child: Text('MK')),
///   title: 'Mehmet Kaya',
///   subtitle: 'mehmet@email.com',
///   badge: Text('Akademisyen'),
///   trailing: IconButton(icon: Icon(Icons.check), onPressed: onApprove),
/// )
/// ```
class ManageListTile extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? badge;
  final Widget? trailing;

  /// Sol kenar border rengi — vurgu için.
  final Color? borderColor;

  /// Kart'a tıklama handler'ı.
  final VoidCallback? onTap;

  const ManageListTile({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.badge,
    this.trailing,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: theme.colorScheme.outlineVariant),
            // Sol kenar vurgu
            gradient: borderColor != null
                ? LinearGradient(
                    stops: const [0.0, 0.02, 0.02, 1.0],
                    colors: [
                      borderColor!,
                      borderColor!,
                      Colors.transparent,
                      Colors.transparent,
                    ],
                  )
                : null,
          ),
          child: Row(
            children: [
              // --- Leading (Avatar / İkon) ---
              if (leading != null) ...[leading!, const SizedBox(width: 14)],

              // --- Orta Alan (Başlık → Badge → Alt Başlık) ---
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Başlık
                    Text(
                      title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Badge (kendi satırında)
                    if (badge != null) ...[const SizedBox(height: 4), badge!],
                    // Alt başlık
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),

              // --- Trailing (Aksiyon Butonları) ---
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      ),
    );
  }

  /// İnisiyallerden CircleAvatar oluşturan yardımcı factory.
  static Widget initialsAvatar({
    required String name,
    Color? backgroundColor,
    Color? textColor,
  }) {
    final initials = name
        .split(' ')
        .where((w) => w.isNotEmpty)
        .take(2)
        .map((w) => w[0].toUpperCase())
        .join();

    return CircleAvatar(
      radius: 22,
      backgroundColor: backgroundColor ?? Colors.blueGrey.shade100,
      child: Text(
        initials,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: textColor ?? Colors.blueGrey.shade800,
        ),
      ),
    );
  }
}
