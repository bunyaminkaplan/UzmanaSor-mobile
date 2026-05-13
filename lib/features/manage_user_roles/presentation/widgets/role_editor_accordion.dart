import 'package:mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/user_entity.dart';
import '../providers/role_editor_notifier.dart';
import '../utils/role_labels.dart';
import 'academic_unit_selectors.dart';
import 'role_display_chips.dart';
import 'role_selector_chips.dart';
import 'student_fields_form.dart';

/// Web tarafındaki RoleEditorAccordion.jsx paritesi.
///
/// Rol silme (optimistic undo) + rol-spesifik bağımlılık formu ile
/// yeni rol atama. Form state ve aksiyonlar [roleEditorNotifierProvider]'da.
class RoleEditorAccordion extends ConsumerStatefulWidget {
  final UserEntity user;

  const RoleEditorAccordion({super.key, required this.user});

  @override
  ConsumerState<RoleEditorAccordion> createState() =>
      _RoleEditorAccordionState();
}

class _RoleEditorAccordionState extends ConsumerState<RoleEditorAccordion> {
  late final TextEditingController _studentNumberController;

  @override
  void initState() {
    super.initState();
    _studentNumberController = TextEditingController(
      text: widget.user.studentNumber ?? '',
    );
    // Form default'larını notifier'a post-frame ile iletiyoruz (build sırasında
    // state mutasyonu yapılamaz).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ref
          .read(roleEditorNotifierProvider(widget.user.id).notifier)
          .prefillDefaults(
            facultyId: widget.user.facultyDetails?['id'],
            departmentId: widget.user.departmentDetails?['id'],
            studentTerm: widget.user.studentTerm,
          );
    });
  }

  @override
  void dispose() {
    _studentNumberController.dispose();
    super.dispose();
  }

  void _showError(Object error) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error.toString()), backgroundColor: AppColors.error),
    );
  }

  void _showSuccess(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(roleEditorNotifierProvider(widget.user.id));
    final notifier = ref.read(
      roleEditorNotifierProvider(widget.user.id).notifier,
    );

    // Optimistic undo: backend cevabı gelmeden silinen chip'i listeden düşür.
    final displayRoles = widget.user.roles
        .where((r) => !state.recentlyRemoved.contains(r))
        .toList();

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Mevcut roller
          Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel('Mevcut Roller'),
                  const SizedBox(height: 8),
                  RoleDisplayChips(
                    displayRoles: displayRoles,
                    recentlyRemoved: state.recentlyRemoved,
                    onRemove: (role) => _handleRemove(notifier, role),
                    onUndo: (role) => _handleAssign(notifier, role),
                  ),
                ],
              ),
            ),

            Divider(height: 1, color: theme.dividerColor),

            // 2. Yeni rol ata + dinamik form
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _SectionLabel('Yeni Rol Ata (Tüm Roller)'),
                  const SizedBox(height: 8),
                  RoleSelectorChips(
                    ownedRoles: displayRoles,
                    selectedRole: state.selectedRoleToLink,
                    onSelect: notifier.selectRoleToLink,
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    child: state.selectedRoleToLink != null
                        ? _DependencyForm(
                            role: state.selectedRoleToLink!,
                            state: state,
                            notifier: notifier,
                            studentNumberController: _studentNumberController,
                            onSubmit: () => _handleAssign(
                              notifier,
                              state.selectedRoleToLink!,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _handleRemove(RoleEditorNotifier notifier, String role) async {
    try {
      await notifier.removeRole(role);
      _showSuccess('${mapRoleToTR(role)} rolü başarıyla silindi.');
    } catch (e) {
      _showError(e);
    }
  }

  Future<void> _handleAssign(RoleEditorNotifier notifier, String role) async {
    try {
      await notifier.assignRole(role);
      _showSuccess(
        '${mapRoleToTR(role)} rolü başarıyla eklendi / geri alındı.',
      );
    } catch (e) {
      _showError(e);
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      text,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _DependencyForm extends StatelessWidget {
  final String role;
  final RoleEditorState state;
  final RoleEditorNotifier notifier;
  final TextEditingController studentNumberController;
  final VoidCallback onSubmit;

  const _DependencyForm({
    required this.role,
    required this.state,
    required this.notifier,
    required this.studentNumberController,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final deps = kRoleDependencies[role] ?? const [];

    if (deps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 16),
        child: _SubmitButton(
          isSubmitting: state.isSubmitting,
          onPressed: onSubmit,
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '${mapRoleToTR(role)} Seçimi İçin Zorunlu Bilgiler',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 12),
          if (deps.contains('faculty') || deps.contains('department'))
            AcademicUnitSelectors(
              facultyId: state.facultyId,
              departmentId: state.departmentId,
              showDepartment: deps.contains('department'),
              onFacultyChanged: notifier.setFacultyId,
              onDepartmentChanged: notifier.setDepartmentId,
            ),
          StudentFieldsForm(
            showTerm: deps.contains('student_term'),
            showNumber: deps.contains('student_number'),
            studentTerm: state.studentTerm,
            studentNumberController: studentNumberController,
            onTermChanged: notifier.setStudentTerm,
          ),
          const SizedBox(height: 16),
          _SubmitButton(isSubmitting: state.isSubmitting, onPressed: onSubmit),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isSubmitting;
  final VoidCallback onPressed;

  const _SubmitButton({required this.isSubmitting, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: isSubmitting ? null : onPressed,
      icon: isSubmitting
          ? const SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.save, size: 16),
      label: Text(
        isSubmitting ? 'Kaydediliyor...' : 'Rolü Ekle',
        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
      ),
    );
  }
}
