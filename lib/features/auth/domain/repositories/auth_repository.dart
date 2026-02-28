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

  Future<Either<Failure, void>> logout();
}
