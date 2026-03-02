import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/courses/data/datasources/course_remote_data_source.dart';
import 'package:mobile/features/courses/domain/entities/course_entity.dart';
import 'package:mobile/features/courses/domain/repositories/course_repository.dart';

class CourseRepositoryImpl implements CourseRepository {
  final CourseRemoteDataSource _dataSource;

  CourseRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<CourseEntity>>> getCourses() async {
    try {
      final models = await _dataSource.getCourses();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, List<CourseEntity>>> getMyCourses() async {
    try {
      final models = await _dataSource.getMyCourses();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }
}

/// Riverpod provider
final courseRepositoryProvider = Provider<CourseRepository>((ref) {
  return CourseRepositoryImpl(ref.watch(courseRemoteDataSourceProvider));
});
