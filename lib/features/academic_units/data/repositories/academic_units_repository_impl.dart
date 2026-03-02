import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/academic_units/data/datasources/academic_units_remote_data_source.dart';
import 'package:mobile/features/academic_units/domain/entities/academic_unit_entities.dart';
import 'package:mobile/features/academic_units/domain/repositories/academic_units_repository.dart';

class AcademicUnitsRepositoryImpl implements AcademicUnitsRepository {
  final AcademicUnitsRemoteDataSource _dataSource;

  AcademicUnitsRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<FacultyEntity>>> getFaculties() async {
    try {
      final models = await _dataSource.getFaculties();
      final entities = models.map((m) => m.toEntity()).toList();
      return Right(entities);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }
}

/// Riverpod provider
final academicUnitsRepositoryProvider = Provider<AcademicUnitsRepository>((
  ref,
) {
  return AcademicUnitsRepositoryImpl(
    ref.watch(academicUnitsRemoteDataSourceProvider),
  );
});
