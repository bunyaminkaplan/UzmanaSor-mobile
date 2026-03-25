import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/data/models/simple_user_model.dart';
import 'package:mobile/core/domain/entities/simple_user_entity.dart';

/// Bölüm başkanı yönetimi remote data source.
///
/// Dekanın fakültesindeki bölümlerin hocalarını listeler
/// ve başkan atama/kaldırma toggle'ı yapar.
abstract class ManageHeadsRemoteDataSource {
  /// Belirli bölümdeki hocaları getirir.
  Future<List<SimpleUserEntity>> getTeachersByDepartment(int departmentId);

  /// Hocanın is_department_head durumunu toggle eder.
  /// Döner: {message: String, is_department_head: bool}
  Future<Map<String, dynamic>> toggleDepartmentHead(int teacherId);
}

class ManageHeadsRemoteDataSourceImpl implements ManageHeadsRemoteDataSource {
  final ApiClient _apiClient;

  ManageHeadsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<SimpleUserEntity>> getTeachersByDepartment(
    int departmentId,
  ) async {
    final response = await _apiClient.get(
      '${ApiEndpoints.teachers}?department=$departmentId',
    );
    final data = response.data;

    final List<dynamic> list;
    if (data is List) {
      list = data;
    } else if (data is Map<String, dynamic> && data['results'] is List) {
      list = data['results'] as List;
    } else {
      list = [];
    }

    return list
        .map(
          (json) =>
              SimpleUserModel.fromJson(json as Map<String, dynamic>).toEntity(),
        )
        .toList();
  }

  @override
  Future<Map<String, dynamic>> toggleDepartmentHead(int teacherId) async {
    final response = await _apiClient.post(
      'core/teachers/$teacherId/toggle-head/',
    );
    return response.data as Map<String, dynamic>;
  }
}
