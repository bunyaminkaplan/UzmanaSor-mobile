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

  @override
  Future<Either<Failure, List<CourseEntity>>> getMyDepartmentCourses() async {
    try {
      final models = await _dataSource.getMyDepartmentCourses();
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, CourseEntity>> createCourse({
    required String title,
    String? description,
    String? courseCode,
    List<int> teacherIds = const [],
    List<int> classTermIds = const [],
  }) async {
    try {
      final data = <String, dynamic>{
        'title': title,
        'description': description ?? '',
        'teacher_ids': teacherIds,
        'class_term_ids': classTermIds,
      };
      if (courseCode != null && courseCode.trim().isNotEmpty) {
        data['course_code'] = courseCode.trim();
      }
      final model = await _dataSource.createCourse(data);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, CourseEntity>> updateCourse({
    required int id,
    required String title,
    String? description,
    String? courseCode,
    List<int> teacherIds = const [],
    List<int> classTermIds = const [],
  }) async {
    try {
      final data = <String, dynamic>{
        'title': title,
        'description': description ?? '',
        'teacher_ids': teacherIds,
        'class_term_ids': classTermIds,
      };
      if (courseCode != null && courseCode.trim().isNotEmpty) {
        data['course_code'] = courseCode.trim();
      }
      final model = await _dataSource.updateCourse(id, data);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteCourse(int id) async {
    try {
      await _dataSource.deleteCourse(id);
      return const Right(null);
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
