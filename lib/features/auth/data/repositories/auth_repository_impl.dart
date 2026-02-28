import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/domain/entities/user_entity.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';

// ---------------------------------------------------------------------------
// Provider Zinciri:
//   apiClientProvider (Provider<ApiClient>)
//     → authRemoteDataSourceProvider (Provider<AuthRemoteDataSource>)
//       → authRepositoryProvider (Provider<AuthRepository>)
// ---------------------------------------------------------------------------

/// DataSource provider
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return AuthRemoteDataSourceImpl(apiClient);
});

/// Repository provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final dataSource = ref.watch(authRemoteDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
});

// ---------------------------------------------------------------------------
// AuthRepositoryImpl
// ---------------------------------------------------------------------------
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  }) async {
    try {
      final userModel = await _dataSource.loginUser(
        username: username,
        password: password,
      );
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> checkAuth() async {
    try {
      final userModel = await _dataSource.getCurrentUser();
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _dataSource.logoutUser();
      return const Right(null);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String primaryRole,
    String? phone,
    String? studentNumber,
    String? studentTerm,
    int? facultyId,
    int? departmentId,
  }) async {
    try {
      final userModel = await _dataSource.registerUser(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        primaryRole: primaryRole,
        phone: phone,
        studentNumber: studentNumber,
        studentTerm: studentTerm,
        facultyId: facultyId,
        departmentId: departmentId,
      );
      return Right(userModel.toEntity());
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> verifyCode(String code) async {
    try {
      final result = await _dataSource.verifyCode(code);
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>>> resendCode() async {
    try {
      final result = await _dataSource.resendCode();
      return Right(result);
    } on DioException catch (e) {
      return Left(_mapDioException(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  // --------------- Private Helpers ---------------

  Failure _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkFailure('Sunucuya bağlanırken zaman aşımı oluştu');

      case DioExceptionType.connectionError:
        return const NetworkFailure('İnternet bağlantısı bulunamadı');

      case DioExceptionType.badResponse:
        return _mapBadResponse(e.response);

      case DioExceptionType.cancel:
        return const ServerFailure('İstek iptal edildi');

      case DioExceptionType.badCertificate:
        return const NetworkFailure('Güvenlik sertifikası doğrulanamadı');

      case DioExceptionType.unknown:
        if (e.error.toString().contains('SocketException')) {
          return const NetworkFailure('İnternet bağlantısı bulunamadı');
        }
        return const ServerFailure('Beklenmeyen bir hata oluştu');
    }
  }

  Failure _mapBadResponse(Response? response) {
    final statusCode = response?.statusCode;
    final data = response?.data;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('detail')) {
        return ServerFailure(data['detail'].toString());
      }
      if (data.containsKey('error')) {
        return ServerFailure(data['error'].toString());
      }
      if (data.isNotEmpty) {
        final firstKey = data.keys.first;
        final firstValue = data[firstKey];
        if (firstValue is List && firstValue.isNotEmpty) {
          return ServerFailure('$firstKey: ${firstValue.first}');
        }
        return ServerFailure('$firstKey: $firstValue');
      }
    }

    switch (statusCode) {
      case 401:
        return const ServerFailure('Oturum süresi dolmuş veya yetkisiz erişim');
      case 403:
        return const ServerFailure('Bu işlem için yetkiniz bulunmuyor');
      case 404:
        return const ServerFailure('İstenen kaynak bulunamadı');
      case 500:
        return const ServerFailure('Sunucu hatası');
      default:
        return ServerFailure('Sunucu hatası: $statusCode');
    }
  }
}
