import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/manage_terms/domain/entities/class_term_entity.dart';

/// ClassTerm CRUD remote data source.
abstract class ClassTermRemoteDataSource {
  Future<List<ClassTermEntity>> getAll();
  Future<ClassTermEntity> create(Map<String, dynamic> data);
  Future<ClassTermEntity> update(int id, Map<String, dynamic> data);
  Future<void> delete(int id);
}

class ClassTermRemoteDataSourceImpl implements ClassTermRemoteDataSource {
  final ApiClient _apiClient;

  ClassTermRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<ClassTermEntity>> getAll() async {
    final response = await _apiClient.get(ApiEndpoints.classTerms);
    final data = response.data;

    if (data is List) {
      return data
          .map((e) => ClassTermEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    // Paginated response handle
    if (data is Map<String, dynamic> && data['results'] is List) {
      return (data['results'] as List)
          .map((e) => ClassTermEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  Future<ClassTermEntity> create(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiEndpoints.classTerms, data: data);
    return ClassTermEntity.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<ClassTermEntity> update(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.patch(
      '${ApiEndpoints.classTerms}$id/',
      data: data,
    );
    return ClassTermEntity.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> delete(int id) async {
    await _apiClient.delete('${ApiEndpoints.classTerms}$id/');
  }
}
