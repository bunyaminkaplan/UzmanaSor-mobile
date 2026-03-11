import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../entities/dashboard_stats_entity.dart';

abstract class StatsRepository {
  Future<Either<Failure, DashboardStatsEntity>> getDeanStats();
  Future<Either<Failure, DashboardStatsEntity>> getRectorStats({
    int? facultyId,
  });
}
