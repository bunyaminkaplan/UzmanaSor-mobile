import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/manage_approvals/domain/entities/pending_user_entity.dart';

/// Kullanıcı onaylama işlemleri için remote data source.
abstract class ApprovalRemoteDataSource {
  /// Onay bekleyen kullanıcıları getirir.
  Future<List<PendingUserEntity>> getPendingUsers();

  /// Kullanıcıyı onaylar veya reddeder.
  /// [action]: 'approved' veya 'rejected'
  Future<String> approveUser(int userId, String action);
}

class ApprovalRemoteDataSourceImpl implements ApprovalRemoteDataSource {
  final ApiClient _apiClient;

  ApprovalRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<PendingUserEntity>> getPendingUsers() async {
    final response = await _apiClient.get(ApiEndpoints.authPendingApprovals);
    final data = response.data;

    if (data is List) {
      return data
          .map((e) => PendingUserEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<String> approveUser(int userId, String action) async {
    final response = await _apiClient.post(
      ApiEndpoints.authApproveUser,
      data: {'user_id': userId, 'action': action},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? 'İşlem başarılı.';
    }
    return 'İşlem başarılı.';
  }
}
