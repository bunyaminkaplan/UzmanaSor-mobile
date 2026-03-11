import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_client.dart';
import '../models/dashboard_stats_model.dart';

abstract class StatsRemoteDataSource {
  Future<DashboardStatsModel> getDeanStats();
}

class StatsRemoteDataSourceImpl implements StatsRemoteDataSource {
  final ApiClient apiClient;

  StatsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<DashboardStatsModel> getDeanStats() async {
    final response = await apiClient.get(ApiEndpoints.statsDean);
    return DashboardStatsModel.fromJson(response.data);
  }
}
