import 'package:dio/dio.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

abstract class ManageUserRolesRemoteDataSource {
  Future<List<UserModel>> getUsers({int page = 1, String? search});
  Future<void> assignRole(int userId, String role, {int? deptId, int? termId});
}

class ManageUserRolesRemoteDataSourceImpl
    implements ManageUserRolesRemoteDataSource {
  final Dio dio;

  ManageUserRolesRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<UserModel>> getUsers({int page = 1, String? search}) async {
    final queryParameters = <String, dynamic>{'page': page};
    if (search != null && search.isNotEmpty) {
      queryParameters['search'] = search;
    }

    // Arama doluysa search endpoint'ine, aksi halde list endpoint'ine atıyoruz
    final endpoint = (search != null && search.isNotEmpty)
        ? '/auth/users-search/'
        : '/auth/users-list/';

    final response = await dio.get(endpoint, queryParameters: queryParameters);

    final data = response.data;
    List<dynamic> items;

    // Django Rest Framework (DRF) pagination handler (results array)
    if (data is Map<String, dynamic> && data.containsKey('results')) {
      items = data['results'] as List;
    } else if (data is List) {
      items = data;
    } else {
      items = [];
    }

    // Gelen ham JSON -> API formatındaki UserModel'e dönüştür
    return items
        .map((json) => UserModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> assignRole(
    int userId,
    String role, {
    int? deptId,
    int? termId,
  }) async {
    final body = <String, dynamic>{'user_id': userId, 'role': role};
    if (deptId != null) body['department_id'] = deptId;
    if (termId != null) body['class_term_id'] = termId;

    await dio.post('/auth/assign-role/', data: body);
  }
}
