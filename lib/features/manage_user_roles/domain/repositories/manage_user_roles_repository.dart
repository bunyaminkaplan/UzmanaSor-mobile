import 'package:mobile/features/auth/domain/entities/user_entity.dart';

abstract class ManageUserRolesRepository {
  Future<List<UserEntity>> getUsers({int page = 1, String? search});
  Future<void> assignRole(int userId, String role, {int? deptId, int? termId});
}
