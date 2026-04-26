import 'package:flutter/material.dart';

import '../utils/role_labels.dart';

/// "Yeni Rol Ata" bölümündeki ChoiceChip listesi.
///
/// Kullanıcının sahip olduğu roller pasif (gri) gösterilir; sahip olmadıkları
/// seçilebilir ChoiceChip olur.
class RoleSelectorChips extends StatelessWidget {
  final List<String> ownedRoles;
  final String? selectedRole;
  final ValueChanged<String?> onSelect;

  const RoleSelectorChips({
    super.key,
    required this.ownedRoles,
    required this.selectedRole,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: kAllAssignableRoles.map((role) {
        final isOwned = ownedRoles.contains(role);
        final isSelected = selectedRole == role;

        if (isOwned) {
          return Chip(
            label: Text(
              mapRoleToTR(role),
              style: TextStyle(
                color: theme.colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
            ),
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            side: BorderSide.none,
          );
        }

        return ChoiceChip(
          selected: isSelected,
          label: Text(
            mapRoleToTR(role),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            ),
          ),
          selectedColor: theme.colorScheme.primary,
          backgroundColor: theme.colorScheme.surface,
          onSelected: (val) => onSelect(val ? role : null),
        );
      }).toList(),
    );
  }
}
