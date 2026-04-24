import 'package:dio/dio.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/domain/entities/user_entity.dart';
import 'package:mobile/features/manage_user_roles/data/datasources/manage_user_roles_remote_datasource.dart';
import 'package:mobile/features/manage_user_roles/domain/repositories/manage_user_roles_repository.dart';

class ManageUserRolesRepositoryImpl implements ManageUserRolesRepository {
  final ManageUserRolesRemoteDataSource remoteDataSource;

  ManageUserRolesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<UserEntity>> getUsers({int page = 1, String? search}) async {
    try {
      // DataSource'dan gelen Data (Entity) nesnesi UserModel tipindedir
      final models = await remoteDataSource.getUsers(
        page: page,
        search: search,
      );

      // Her bir UserModel nesnesini Domain katmanının UserEntity tipine dönüştür (Data -> Domain map)
      return models.map((model) => model.toEntity()).toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['detail'] ??
            e.message ??
            'Kullanıcılar getirilirken hata oluştu',
      );
    } catch (e) {
      throw Exception('Kullanıcı listesi okunamadı: $e');
    }
  }

  @override
  Future<void> assignRole(
    int userId,
    String role, {
    int? deptId,
    int? termId,
  }) async {
    try {
      await remoteDataSource.assignRole(
        userId,
        role,
        deptId: deptId,
        termId: termId,
      );
    } on DioException catch (e) {
      final errorMessage =
          e.response?.data?['detail'] ??
          e.response?.data?['error'] ??
          'Rol atanırken hata oluştu';
      throw Exception(errorMessage.toString());
    } catch (e) {
      throw Exception('Bilinmeyen bir hata oluştu: $e');
    }
  }
}
