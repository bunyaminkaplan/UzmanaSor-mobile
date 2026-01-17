import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(dioProvider));
});

class AuthRepositoryImpl implements AuthRepository {
  final Dio _dio;

  AuthRepositoryImpl(this._dio);

  @override
  Future<Either<Failure, UserModel>> login({
    required String username,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        ApiEndpoints.authLogin,
        data: {'username': username, 'password': password},
      );

      final user = UserModel.fromJson(response.data);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserModel>> checkAuth() async {
    try {
      final response = await _dio.get(ApiEndpoints.authMe);
      final user = UserModel.fromJson(response.data);
      return Right(user);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _dio.post(ApiEndpoints.authLogout);
      return const Right(null);
    } on DioException catch (e) {
      return Left(_handleDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  Failure _handleDioError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return const NetworkFailure('Connection timed out');
    }

    if (e.response != null) {
      // Backend'den gelen hata mesajini yakalamaya calis
      if (e.response?.data is Map) {
        final data = e.response?.data as Map;
        if (data.containsKey('detail')) {
          return ServerFailure(data['detail'].toString());
        }
        // Django validation errors usually come as field: [errors]
        if (data.isNotEmpty) {
          return ServerFailure(data.values.first.toString());
        }
      }
      return ServerFailure('Server error: ${e.response?.statusCode}');
    }

    return const NetworkFailure('No internet connection');
  }
}
