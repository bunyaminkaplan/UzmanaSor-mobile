import 'package:mobile/features/manage_approvals/data/datasources/approval_remote_data_source.dart';
import 'package:mobile/features/manage_approvals/domain/entities/pending_user_entity.dart';
import 'package:mobile/features/manage_approvals/domain/repositories/approval_repository.dart';

class ApprovalRepositoryImpl implements ApprovalRepository {
  final ApprovalRemoteDataSource _dataSource;

  ApprovalRepositoryImpl(this._dataSource);

  @override
  Future<List<PendingUserEntity>> getPendingUsers() =>
      _dataSource.getPendingUsers();

  @override
  Future<String> approveUser(int userId, String action) =>
      _dataSource.approveUser(userId, action);
}
