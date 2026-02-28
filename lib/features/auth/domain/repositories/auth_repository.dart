import 'package:fpdart/fpdart.dart';

import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/auth/domain/entities/user_entity.dart';

/// Auth domain kontratı — Data katmanı bu interface'i implement eder.
///
/// Domain katmanında yaşar, flutter bağımlılığı yoktur.
/// fpdart (Either) saf Dart paketidir — domain'de kullanılabilir.
abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, UserEntity>> checkAuth();

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
  });

  Future<Either<Failure, Map<String, dynamic>>> verifyCode(String code);

  Future<Either<Failure, Map<String, dynamic>>> resendCode();

  Future<Either<Failure, void>> logout();
}
