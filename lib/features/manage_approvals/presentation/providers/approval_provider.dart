import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/manage_approvals/data/datasources/approval_remote_data_source.dart';
import 'package:mobile/features/manage_approvals/data/repositories/approval_repository_impl.dart';
import 'package:mobile/features/manage_approvals/domain/entities/pending_user_entity.dart';
import 'package:mobile/features/manage_approvals/domain/repositories/approval_repository.dart';

/// Data source provider.
final _approvalDataSourceProvider = Provider<ApprovalRemoteDataSource>((ref) {
  return ApprovalRemoteDataSourceImpl(ref.watch(apiClientProvider));
});

/// Repository provider.
final approvalRepositoryProvider = Provider<ApprovalRepository>((ref) {
  return ApprovalRepositoryImpl(ref.watch(_approvalDataSourceProvider));
});

/// Onay bekleyen kullanıcı listesi provider'ı.
/// `ref.invalidate(pendingUsersProvider)` ile yenilenebilir.
final pendingUsersProvider =
    FutureProvider.autoDispose<List<PendingUserEntity>>((ref) async {
      final repo = ref.watch(approvalRepositoryProvider);
      return repo.getPendingUsers();
    });
