import 'package:mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/async_stats_builder.dart';
import '../../../../shared/widgets/dashboard_page_header.dart';
import '../../../../shared/widgets/dashboard_scaffold.dart';
import '../../../../shared/widgets/empty_state_widget.dart';
import '../../../../shared/widgets/manage_list_tile.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../providers/manage_user_roles_provider.dart';
import '../utils/role_labels.dart';
import '../widgets/role_editor_accordion.dart';

/// Yönetici Rol Atama ve Kullanıcı Yönetimi Sayfası
///
/// Web: ManageUserRolesPage.jsx paritesi.
/// Sistem yöneticilerinin (School Admin, Rektör) kullanıcı rollerini ve yetkilerini
/// gördükleri ve atamalar yapabildikleri ana panodur.
class ManageUserRolesPage extends ConsumerStatefulWidget {
  const ManageUserRolesPage({super.key});

  @override
  ConsumerState<ManageUserRolesPage> createState() =>
      _ManageUserRolesPageState();
}

class _ManageUserRolesPageState extends ConsumerState<ManageUserRolesPage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final usersAsync = ref.watch(usersListProvider);

    return DashboardScaffold(
      onRefresh: () => ref.invalidate(usersListProvider),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DashboardPageHeader(
              title: 'Kullanıcı ve Rol Yönetimi',
              description:
                  'Sistemdeki tüm kullanıcıları sorgulayabilir ve yetki düzeylerini değiştirebilirsiniz.',
              borderColor: theme.colorScheme.primary,
            ),

            // --- Arama Çubuğu ---
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Kullanıcı ara (İsim veya E-posta)...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (v) {
                  // Burada Debounce mekanizması uygulayabiliriz ama şimdilik doğrudan provider'a bağlı
                  ref.read(userSearchQueryProvider.notifier).state = v;
                },
              ),
            ),

            const SizedBox(height: 12),

            // --- Kullanıcı Listesi ---
            AsyncStatsBuilder<List<UserEntity>>(
              asyncValue: usersAsync,
              builder: (users) {
                if (users.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.people_outline,
                    title: 'Kullanıcı Bulunamadı',
                    description:
                        'Arama kriterinize uyan hiçbir kullanıcı sistemde kayıtlı değil.',
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      ...users.map(
                        (user) => Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _UserAccordionTile(
                            key: ValueKey(user.id),
                            user: user,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kullanıcı Liste Elemanı (Genişleyebilir)
// ---------------------------------------------------------------------------
class _UserAccordionTile extends StatefulWidget {
  final UserEntity user;

  const _UserAccordionTile({super.key, required this.user});

  @override
  State<_UserAccordionTile> createState() => _UserAccordionTileState();
}

class _UserAccordionTileState extends State<_UserAccordionTile> {
  bool _isExpanded = false;

  Color _getRoleColor(BuildContext context, String role) {
    final theme = Theme.of(context);
    switch (role) {
      case 'rector':
      case 'school_admin':
        return theme.colorScheme.error;
      case 'dean':
      case 'department_head':
        return theme.colorScheme.secondary;
      case 'teacher':
        return theme.colorScheme.primary;
      case 'student_rep':
        return theme.colorScheme.primary;
      default:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final displayRoles = widget.user.roles;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: _isExpanded ? theme.colorScheme.primary : theme.dividerColor,
        ),
        boxShadow: _isExpanded
            ? [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ]
            : [],
      ),
      child: Column(
        children: [
          // Görünen Yüzey (Tile)
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: BorderRadius.circular(16),
            child: ManageListTile(
              borderColor:
                  Colors.transparent, // dış Container border'ı ile sarmalıyoruz
              leading: CircleAvatar(
                radius: 22,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                child: Text(
                  widget.user.fullName.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              title: widget.user.fullName,
              subtitle: widget.user.email ?? widget.user.username,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    children: displayRoles.map((roleStr) {
                      final color = _getRoleColor(context, roleStr);
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: color.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: color.withValues(alpha: 0.3),
                          ),
                        ),
                        child: Text(
                          mapRoleToTR(roleStr),
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                            fontSize: 10,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),

          // Akordeon İçeriği
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: _isExpanded
                ? RoleEditorAccordion(user: widget.user)
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
