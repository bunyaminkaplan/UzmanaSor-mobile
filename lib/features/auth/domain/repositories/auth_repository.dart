import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> login({
    required String username,
    required String password,
  });

  Future<Either<Failure, UserModel>> checkAuth();

  Future<Either<Failure, void>> logout();
}
