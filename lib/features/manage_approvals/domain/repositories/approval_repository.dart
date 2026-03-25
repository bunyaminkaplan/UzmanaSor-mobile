import 'package:mobile/features/manage_approvals/domain/entities/pending_user_entity.dart';

/// Kullanıcı onaylama repository kontratı.
abstract class ApprovalRepository {
  Future<List<PendingUserEntity>> getPendingUsers();
  Future<String> approveUser(int userId, String action);
}
