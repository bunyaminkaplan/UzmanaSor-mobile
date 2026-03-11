import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_stats_model.dart';

abstract class StatsRemoteDataSource {
  Future<DashboardStatsModel> getDeanStats();
  Future<DashboardStatsModel> getRectorStats({int? facultyId});
}

class StatsRemoteDataSourceImpl implements StatsRemoteDataSource {
  final ApiClient apiClient;

  StatsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DashboardStatsModel> getDeanStats() async {
    final response = await apiClient.get(ApiEndpoints.statsDean);
    return DashboardStatsModel.fromJson(response.data);
  }

  @override
  Future<DashboardStatsModel> getRectorStats({int? facultyId}) async {
    final queryParams = <String, dynamic>{};
    if (facultyId != null) {
      queryParams['faculty'] = facultyId;
    }
    final response = await apiClient.get(
      ApiEndpoints.statsRector,
      queryParameters: queryParams,
    );
    return DashboardStatsModel.fromJson(response.data);
  }
}
