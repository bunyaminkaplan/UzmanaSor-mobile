import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'drawer_routes.dart';

/// [DrawerLinkItem] — Drawer'da souncu görebileceği tekil menü öğesinin çizimi.
/// UI ve Navigasyon işlemini yönetir ama HANGİ sayfaların yükleneceğini bilmez.
class DrawerLinkItem extends StatelessWidget {
  final DrawerRouteItem route;
  final bool isApproved;

  const DrawerLinkItem({
    super.key,
    required this.route,
    required this.isApproved,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentPath = GoRouterState.of(context).uri.path;
    final isActive = currentPath == route.path;

    // Rolü gereği görebiliyor ancak onaylı değilse (ve route her zaman izne tabi değilse) kilitlenir.
    final bool isEnabled = isApproved || route.isAlwaysAllowed;

    return ListTile(
      leading: Icon(
        route.icon,
        color: isEnabled
            ? (isActive ? theme.colorScheme.primary : theme.colorScheme.outline)
            : theme.colorScheme.outline.withValues(alpha: 0.3),
      ),
      title: Text(
        route.title,
        style: TextStyle(
          color: isEnabled
              ? (isActive
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface)
              : theme.colorScheme.onSurface.withValues(alpha: 0.3),
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      trailing: !isEnabled
          ? Icon(
              Icons.lock,
              size: 16,
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
            )
          : null,
      selected: isActive,
      selectedTileColor: theme.colorScheme.primary.withValues(alpha: 0.05),
      enabled: isEnabled,
      onTap: () {
        if (!isEnabled) return;
        GoRouter.of(context).pop(); // Menüyü kapat

        // Hazır olmayan yollar için try-catch
        try {
          GoRouter.of(context).push(route.path);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sayfa henüz hazır değil: ${route.path}')),
          );
        }
      },
    );
  }
}
