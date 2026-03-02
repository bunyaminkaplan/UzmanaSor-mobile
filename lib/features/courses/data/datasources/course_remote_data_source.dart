import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/courses/data/models/course_model.dart';

/// Courses remote data source.
abstract class CourseRemoteDataSource {
  /// GET core/courses/
  Future<List<CourseModel>> getCourses();

  /// GET core/courses/my-courses/
  Future<List<CourseModel>> getMyCourses();
}

class CourseRemoteDataSourceImpl implements CourseRemoteDataSource {
  final ApiClient _apiClient;

  CourseRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<CourseModel>> getCourses() async {
    final response = await _apiClient.get(ApiEndpoints.courses);
    // Paginated response: {results: [...]} veya direkt [...]
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
