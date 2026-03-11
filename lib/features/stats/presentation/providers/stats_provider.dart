import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../data/datasources/stats_remote_data_source.dart';
import '../../data/repositories/stats_repository_impl.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/repositories/stats_repository.dart';

// --- DEPENDENCY INJECTION ---
final statsRemoteDataSourceProvider = Provider<StatsRemoteDataSource>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return StatsRemoteDataSourceImpl(apiClient: apiClient);
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  final remoteDataSource = ref.watch(statsRemoteDataSourceProvider);
  return StatsRepositoryImpl(remoteDataSource: remoteDataSource);
});

// --- STATE PROVIDERS ---

/// Dekan (Dean) Dashboard için istatistik çeken FutureProvider
final deanStatsProvider = FutureProvider.autoDispose<DashboardStatsEntity>((
  ref,
) async {
  final repository = ref.watch(statsRepositoryProvider);
  final result = await repository.getDeanStats();

  return result.fold(
    (failure) => Future.error(failure.message),
    (stats) => stats,
  );
});
