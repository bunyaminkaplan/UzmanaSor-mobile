import 'package:mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

import '../utils/role_labels.dart';

/// Kullanıcının mevcut rollerini + undo edilebilir ghost chip'lerini gösterir.
///
/// Kullanım:
/// ```dart
/// RoleDisplayChips(
///   displayRoles: activeRoles,
///   recentlyRemoved: removed,
///   confirmingRemoveRole: confirmingRole,
///   onRemove: (r) => notifier.removeRole(r),
///   onUndo: (r) => notifier.assignRole(r),
/// )
/// ```
class RoleDisplayChips extends StatelessWidget {
  final List<String> displayRoles;
  final List<String> recentlyRemoved;
  final String? confirmingRemoveRole;
  final ValueChanged<String> onRemove;
  final ValueChanged<String> onUndo;
  final VoidCallback onCancel;

  const RoleDisplayChips({
    super.key,
    required this.displayRoles,
    required this.recentlyRemoved,
    required this.confirmingRemoveRole,
    required this.onRemove,
    required this.onUndo,
    required this.onCancel,
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
          final isConfirming = confirmingRemoveRole == role;
          final color = isConfirming
              ? AppColors.error
              : theme.colorScheme.primary;

          final mainChip = ActionChip(
            backgroundColor: color.withValues(alpha: 0.1),
            side: BorderSide(color: color, width: 0.5),
            avatar: Icon(
              isConfirming ? Icons.delete_outline : Icons.check_circle,
              size: 14,
              color: color,
            ),
            label: Text(
              isConfirming ? 'Silmeyi Onayla' : mapRoleToTR(role),
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            onPressed: () => onRemove(role),
          );

          if (isConfirming) {
            return Wrap(
              spacing: 4,
              children: [
                mainChip,
                ActionChip(
                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                  side: BorderSide(
                    color: theme.colorScheme.onSurfaceVariant.withValues(
                      alpha: 0.5,
                    ),
                    width: 0.5,
                  ),
                  labelPadding: EdgeInsets.zero,
                  label: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Icon(
                      Icons.close,
                      size: 16,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  onPressed: onCancel,
                ),
              ],
            );
          }

          return mainChip;
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
