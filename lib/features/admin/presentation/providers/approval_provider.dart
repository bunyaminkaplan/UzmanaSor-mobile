import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/admin/data/repositories/admin_repository_impl.dart';
import 'package:mobile/features/admin/domain/repositories/admin_repository.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

// --- DATA PROVIDER ---
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final dio = ref.watch(dioProvider);
  return AdminRepositoryImpl(dio);
});

// --- STATE MANAGER ---
class ApprovalState {
  final bool isLoading;
  final List<UserModel> pendingUsers;
  final String? errorMessage;
  final String? successMessage;

  ApprovalState({
    this.isLoading = false,
    this.pendingUsers = const [],
    this.errorMessage,
    this.successMessage,
  });

  ApprovalState copyWith({
    bool? isLoading,
    List<UserModel>? pendingUsers,
    String? errorMessage,
    String? successMessage,
  }) {
    return ApprovalState(
      isLoading: isLoading ?? this.isLoading,
      pendingUsers: pendingUsers ?? this.pendingUsers,
      errorMessage: errorMessage,
      successMessage: successMessage,
    );
  }
}

class ApprovalNotifier extends Notifier<ApprovalState> {
  late final AdminRepository _repository;

  @override
  ApprovalState build() {
    _repository = ref.watch(adminRepositoryProvider);
    return ApprovalState();
  }

  Future<void> loadPendingUsers() async {
    // Preserve current list while loading? Or generic loader?
    // Let's set isLoading = true
    state = state.copyWith(isLoading: true, errorMessage: null);

    final result = await _repository.fetchPendingUsers();

    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
      ),
      (users) => state = state.copyWith(isLoading: false, pendingUsers: users),
    );
  }

  Future<void> approveUser(int userId) async {
    final result = await _repository.approveUser(
      userId: userId,
      action: 'approved',
    );

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (_) {
        // Remove from list locally
        final updatedList = state.pendingUsers
            .where((u) => u.id != userId)
            .toList();
        state = state.copyWith(
          pendingUsers: updatedList,
          successMessage: "Kullanıcı onaylandı.",
        );
      },
    );
  }

  Future<void> rejectUser(int userId) async {
    final result = await _repository.approveUser(
      userId: userId,
      action: 'rejected',
    );

    result.fold(
      (failure) => state = state.copyWith(errorMessage: failure.message),
      (_) {
        final updatedList = state.pendingUsers
            .where((u) => u.id != userId)
            .toList();
        state = state.copyWith(
          pendingUsers: updatedList,
          successMessage: "Kullanıcı reddedildi.",
        );
      },
    );
  }
}

// Using NotifierProvider instead of StateNotifierProvider
final approvalProvider = NotifierProvider<ApprovalNotifier, ApprovalState>(() {
  return ApprovalNotifier();
});
