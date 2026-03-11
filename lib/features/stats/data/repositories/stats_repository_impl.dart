import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import '../../../../core/errors/failure.dart';
import '../../domain/entities/dashboard_stats_entity.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/stats_remote_data_source.dart';

class StatsRepositoryImpl implements StatsRepository {
  final StatsRemoteDataSource remoteDataSource;

  StatsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, DashboardStatsEntity>> getDeanStats() async {
    try {
      final model = await remoteDataSource.getDeanStats();
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return const Left(
          ServerFailure('Bu istatistikleri görüntülemek için yetkiniz yok.'),
        );
      }
      return Left(
        ServerFailure(
          e.response?.data?['error'] ?? 'İstatistikler yüklenemedi.',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen bir hata oluştu: $e'));
    }
  }

  @override
  Future<Either<Failure, DashboardStatsEntity>> getRectorStats({
    int? facultyId,
  }) async {
    try {
      final model = await remoteDataSource.getRectorStats(facultyId: facultyId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        return const Left(
          ServerFailure('Bu istatistikleri görüntülemek için yetkiniz yok.'),
        );
      }
      return Left(
        ServerFailure(
          e.response?.data?['error'] ?? 'İstatistikler yüklenemedi.',
        ),
      );
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen bir hata oluştu: $e'));
    }
  }
}
