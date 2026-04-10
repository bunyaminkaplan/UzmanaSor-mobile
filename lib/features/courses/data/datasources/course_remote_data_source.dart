import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/courses/data/models/course_model.dart';

/// Courses remote data source — CRUD.
abstract class CourseRemoteDataSource {
  /// GET core/courses/
  Future<List<CourseModel>> getCourses();

  /// GET core/courses/my-courses/
  Future<List<CourseModel>> getMyCourses();

  /// POST core/courses/
  Future<CourseModel> createCourse(Map<String, dynamic> data);

  /// PATCH core/courses/{id}/
  Future<CourseModel> updateCourse(int id, Map<String, dynamic> data);

  /// DELETE core/courses/{id}/
  Future<void> deleteCourse(int id);
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient _apiClient;

  CourseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CourseModel>> getCourses() async {
    final response = await _apiClient.get(ApiEndpoints.courses);
    final data = _extractList(response.data);
    return data
        .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CourseModel>> getMyCourses() async {
    final response = await _apiClient.get(ApiEndpoints.myCourses);
    final data = _extractList(response.data);
    return data
        .map((json) => CourseModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<CourseModel> createCourse(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiEndpoints.courses, data: data);
    return CourseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<CourseModel> updateCourse(int id, Map<String, dynamic> data) async {
    final response = await _apiClient.patch(
      '${ApiEndpoints.courses}$id/',
      data: data,
    );
    return CourseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteCourse(int id) async {
    await _apiClient.delete('${ApiEndpoints.courses}$id/');
  }

  /// Paginated ({results: [...]}) veya düz ([...]) response'u normalize eder.
  List<dynamic> _extractList(dynamic data) {
    if (data is List) return data;
    if (data is Map && data.containsKey('results')) {
      return data['results'] as List;
    }
    return [];
  }
}

/// Riverpod provider
final courseRemoteDataSourceProvider = Provider<CourseRemoteDataSource>((ref) {
  return CourseRemoteDataSourceImpl(ref.watch(apiClientProvider));
});
