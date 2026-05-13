import 'package:mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../../../../shared/widgets/inline_confirm_button.dart';
import '../utils/role_labels.dart';

/// Kullanıcının mevcut rollerini + undo edilebilir ghost chip'lerini gösterir.
///
/// Kullanım:
/// ```dart
/// RoleDisplayChips(
///   displayRoles: activeRoles,
///   recentlyRemoved: removed,
///   onRemove: (r) => notifier.removeRole(r),
///   onUndo: (r) => notifier.assignRole(r),
/// )
/// ```
class RoleDisplayChips extends StatelessWidget {
  final List<String> displayRoles;
  final List<String> recentlyRemoved;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onUndo;

  const RoleDisplayChips({
    super.key,
    required this.displayRoles,
    required this.recentlyRemoved,
    required this.onRemove,
    required this.onUndo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (displayRoles.isEmpty && recentlyRemoved.isEmpty) {
      return Text(
        'Kullanıcının atanan bir rolü yok.',
        style: TextStyle(
          fontSize: 12,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      );
    }

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        ...displayRoles.map((role) {
          final color = theme.colorScheme.primary;

          return InlineConfirmButton(
            normalIcon: Icons.check_circle,
            confirmIcon: Icons.delete_forever,
            normalLabel: mapRoleToTR(role),
            confirmLabel: 'Silmeyi Onayla',
            normalColor: color.withValues(alpha: 0.1),
            normalTextColor: color,
            confirmColor: AppColors.error,
            borderRadius: 16.0, // Match ActionChip rounded corners
            onConfirm: () => onRemove(role),
          );
        }),
        ...recentlyRemoved.map((ghostRole) {
          return ActionChip(
            backgroundColor: Colors.transparent,
            side: BorderSide(
              color: theme.colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
            ),
            avatar: Icon(
              Icons.undo,
              size: 14,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            label: Text(
              'Geri Al: ${mapRoleToTR(ghostRole)}',
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                decoration: TextDecoration.lineThrough,
                fontSize: 12,
              ),
            ),
            onPressed: () => onUndo(ghostRole),
          );
        }),
      ],
    );
  }
}
