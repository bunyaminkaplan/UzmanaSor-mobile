import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/data/models/simple_user_model.dart';
import 'package:mobile/core/domain/entities/simple_user_entity.dart';
import 'package:mobile/features/manage_terms/domain/entities/class_term_entity.dart';

/// Danışman atama işlemleri için remote data source.
///
/// Bölüm başkanının kendi bölümündeki sınıfları (dönemleri) ve hocaları çeker,
/// danışman atama/kaldırma işlemlerini yürütür.
abstract class ManageAdvisorsRemoteDataSource {
  /// Bölüme ait tüm dönem/sınıfları getirir.
  Future<List<ClassTermEntity>> getDeptClassTerms();

  /// Bölüme ait tüm hocaları getirir.
  Future<List<SimpleUserEntity>> getDeptTeachers();

  /// Belirli bir sınıfa (döneme) danışman atar.
  /// [advisorId] null ise atamayı kaldırır.
  Future<String> assignAdvisor(int classTermId, int? advisorId);
}

class ManageAdvisorsRemoteDataSourceImpl
    implements ManageAdvisorsRemoteDataSource {
  final ApiClient _apiClient;

  ManageAdvisorsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ClassTermEntity>> getDeptClassTerms() async {
    final response = await _apiClient.get(ApiEndpoints.deptHeadClassTerms);
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
        .map((json) => ClassTermEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<SimpleUserEntity>> getDeptTeachers() async {
    final response = await _apiClient.get(ApiEndpoints.deptHeadTeachers);
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
  Future<String> assignAdvisor(int classTermId, int? advisorId) async {
    final response = await _apiClient.post(
      ApiEndpoints.assignAdvisor,
      data: {'class_term_id': classTermId, 'advisor_id': advisorId},
    );
    final data = response.data;
    if (data is Map<String, dynamic>) {
      return data['message'] as String? ?? 'İşlem başarılı.';
    }
    return 'İşlem başarılı.';
  }
}
