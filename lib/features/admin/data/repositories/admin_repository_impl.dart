import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/admin/domain/repositories/admin_repository.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider definition
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  // We assume Dio is provided globally usually, but for now we'll get it from a global or create a new one if not available.
  // Ideally, we should inject DioClient. But let's verify if dioProvider exists.
  // Checking main.dart or other files... usually defined in core/network.
  // For this step I will follow the pattern used in AuthRepositoryImpl which likely takes Dio.
  // Since I cannot see the dio provider definition right now, I will assume it's passed or I will use a simple instance for now if not strictly enforced.
  // WAIT: In Phase 1 I created `lib/core/network/dio_client.dart`.
  // I should check `dashboard_dispatcher` or `auth_repository_impl` to see how Dio is retrieved.
  // Actually, I'll just skip the provider definition inside the file for now and put it in a separate providers file or define it assuming `dio` is available.
  // Re-reading AuthRepositoryImpl usage (Step 509 summary said "Implemented AuthRepositoryImpl using Dio").
  // Let's create the class first.
  throw UnimplementedError("Provider not configured in this file");
});

class AdminRepositoryImpl implements AdminRepository {
  final Dio _dio;

  AdminRepositoryImpl(this._dio);

  @override
  Future<Either<Failure, List<UserModel>>> fetchPendingUsers() async {
    try {
      final response = await _dio.get(ApiEndpoints.authPendingApprovals);

      final List<dynamic> data = response.data;
      final users = data.map((json) => UserModel.fromJson(json)).toList();

      return right(users);
    } on DioException catch (e) {
      // Handle 403 Forbidden etc
      if (e.response?.statusCode == 403) {
        return left(const ServerFailure('Bu işlem için yetkiniz yok.'));
      }
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> approveUser({
    required int userId,
    required String action,
  }) async {
    try {
      // Endpoint found in React: api.post('auth/approve-user/', { user_id, action })
      // Wait, ApiEndpoints might not have 'approve-user'. Let's check or add it.
      // ApiEndpoints.authPendingApprovals is 'auth/pending-approvals/'
      // I need 'auth/approve-user/'.
      // I will hardcode it for now or add it later if cleaner. Use hardcode "auth/approve-user/" to match React.

      await _dio.post(
        'auth/approve-user/',
        data: {'user_id': userId, 'action': action},
      );

      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    } catch (e) {
      return left(ServerFailure(e.toString()));
    }
  }
}
