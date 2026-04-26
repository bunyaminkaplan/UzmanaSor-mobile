import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'manage_user_roles_provider.dart';

const _unset = Object();

/// Tek bir kullanıcının rol düzenleme panelindeki form + UI durumu.
class RoleEditorState {
  final List<String> recentlyRemoved;
  final String? confirmingRemoveRole;
  final String? selectedRoleToLink;
  final bool isSubmitting;
  final int? facultyId;
  final int? departmentId;
  final String? studentTerm;

  const RoleEditorState({
    this.recentlyRemoved = const [],
    this.confirmingRemoveRole,
    this.selectedRoleToLink,
    this.isSubmitting = false,
    this.facultyId,
    this.departmentId,
    this.studentTerm,
  });

  RoleEditorState copyWith({
    List<String>? recentlyRemoved,
    Object? confirmingRemoveRole = _unset,
    Object? selectedRoleToLink = _unset,
    bool? isSubmitting,
    Object? facultyId = _unset,
    Object? departmentId = _unset,
    Object? studentTerm = _unset,
  }) {
    return RoleEditorState(
      recentlyRemoved: recentlyRemoved ?? this.recentlyRemoved,
      confirmingRemoveRole: identical(confirmingRemoveRole, _unset)
          ? this.confirmingRemoveRole
          : confirmingRemoveRole as String?,
      selectedRoleToLink: identical(selectedRoleToLink, _unset)
          ? this.selectedRoleToLink
          : selectedRoleToLink as String?,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      facultyId: identical(facultyId, _unset)
          ? this.facultyId
          : facultyId as int?,
      departmentId: identical(departmentId, _unset)
          ? this.departmentId
          : departmentId as int?,
      studentTerm: identical(studentTerm, _unset)
          ? this.studentTerm
          : studentTerm as String?,
    );
  }
}

class RoleEditorNotifier
    extends AutoDisposeFamilyNotifier<RoleEditorState, int> {
  @override
  RoleEditorState build(int userId) => const RoleEditorState();

  /// Orchestrator widget'tan ilk açılışta kullanıcının mevcut
  /// akademik verileriyle form default'larını doldurur.
  void prefillDefaults({
    required int? facultyId,
    required int? departmentId,
    required String? studentTerm,
  }) {
    state = state.copyWith(
      facultyId: facultyId,
      departmentId: departmentId,
      studentTerm: studentTerm,
    );
  }

  void toggleConfirmRemove(String role) {
    state = state.copyWith(
      confirmingRemoveRole: state.confirmingRemoveRole == role ? null : role,
    );
  }

  void cancelConfirm() {
    state = state.copyWith(confirmingRemoveRole: null);
  }

  void selectRoleToLink(String? role) {
    state = state.copyWith(selectedRoleToLink: role);
  }

  void setFacultyId(int? id) {
    // Fakülte değişirse bölüm resetlenir
    state = state.copyWith(facultyId: id, departmentId: null);
  }

  void setDepartmentId(int? id) {
    state = state.copyWith(departmentId: id);
  }

  void setStudentTerm(String? term) {
    state = state.copyWith(studentTerm: term);
  }

  Future<void> removeRole(String role) async {
    state = state.copyWith(confirmingRemoveRole: null);
    final repo = ref.read(manageUserRolesRepositoryProvider);
    await repo.removeRole(arg, role);
    state = state.copyWith(recentlyRemoved: [...state.recentlyRemoved, role]);
  }

  Future<void> assignRole(String role) async {
    state = state.copyWith(isSubmitting: true);
    try {
      final repo = ref.read(manageUserRolesRepositoryProvider);
      await repo.assignRole(
        arg,
        role,
        facultyId: state.facultyId,
        deptId: state.departmentId,
        termId: int.tryParse(state.studentTerm ?? ''),
      );
      state = state.copyWith(
        recentlyRemoved: [...state.recentlyRemoved]..remove(role),
        selectedRoleToLink: null,
        isSubmitting: false,
      );
      ref.invalidate(usersListProvider);
    } catch (_) {
      state = state.copyWith(isSubmitting: false);
      rethrow;
    }
  }
}

final roleEditorNotifierProvider = NotifierProvider.autoDispose
    .family<RoleEditorNotifier, RoleEditorState, int>(RoleEditorNotifier.new);
