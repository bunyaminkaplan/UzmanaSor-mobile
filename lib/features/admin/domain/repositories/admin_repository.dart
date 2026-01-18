import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

abstract interface class AdminRepository {
  Future<Either<Failure, List<UserModel>>> fetchPendingUsers();

  /// [action] should be 'approved' or 'rejected'
  Future<Either<Failure, void>> approveUser({
    required int userId,
    required String action,
  });
}
