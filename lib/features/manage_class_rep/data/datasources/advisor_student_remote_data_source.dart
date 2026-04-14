import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/manage_class_rep/domain/entities/advisor_student_entity.dart';

/// Advisor Students remote data source.
///
/// API:
///   GET  core/advisor/students/              → öğrenci listesi
///   POST core/advisor/students/set-representative/ → temsilci atama
abstract class AdvisorStudentRemoteDataSource {
  Future<List<AdvisorStudentEntity>> getStudents();
  Future<void> setRepresentative(int studentId);
}

class AdvisorStudentRemoteDataSourceImpl
    implements AdvisorStudentRemoteDataSource {
  final ApiClient _apiClient;

  AdvisorStudentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<AdvisorStudentEntity>> getStudents() async {
    final response = await _apiClient.get(ApiEndpoints.advisorStudents);
    final data = response.data;

    // Backend doğrudan liste döner (paginated değil)
    if (data is List) {
      return data
          .map(
            (json) =>
                AdvisorStudentEntity.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }
    // Paginated response fallback
    if (data is Map<String, dynamic> && data['results'] is List) {
      return (data['results'] as List)
          .map(
            (json) =>
                AdvisorStudentEntity.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    }
    return [];
  }

  @override
  Future<void> setRepresentative(int studentId) async {
    await _apiClient.post(
      ApiEndpoints.setRepresentative,
      data: {'student_id': studentId},
    );
  }
}

/// Riverpod provider
final advisorStudentDataSourceProvider =
    Provider<AdvisorStudentRemoteDataSource>((ref) {
      return AdvisorStudentRemoteDataSourceImpl(ref.watch(apiClientProvider));
    });
