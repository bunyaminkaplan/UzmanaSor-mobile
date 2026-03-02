import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/academic_units/data/models/academic_unit_models.dart';

/// Academic Units remote data source.
///
/// Backend: GET core/academic-units/
/// Yanıt: [{id, name, departments: [{id, name}]}]
abstract class AcademicUnitsRemoteDataSource {
  Future<List<FacultyModel>> getFaculties();
}

class AcademicUnitsRemoteDataSourceImpl
    implements AcademicUnitsRemoteDataSource {
  final ApiClient _apiClient;

  AcademicUnitsRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<FacultyModel>> getFaculties() async {
    final response = await _apiClient.get(ApiEndpoints.academicUnits);
    final data = response.data as List<dynamic>;
    return data
        .map((json) => FacultyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}

/// Riverpod provider
final academicUnitsRemoteDataSourceProvider =
    Provider<AcademicUnitsRemoteDataSource>((ref) {
      return AcademicUnitsRemoteDataSourceImpl(ref.watch(apiClientProvider));
    });
