import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/admin/data/models/class_term_model.dart';
import 'package:mobile/features/admin/data/models/faculty_model.dart';
import 'package:mobile/features/admin/domain/repositories/assignment_repository.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

class AssignmentRepositoryImpl implements AssignmentRepository {
  final Dio _dio;

  AssignmentRepositoryImpl(this._dio);

  // --- DEAN ---
  // --- DEAN ---
  @override
  Future<Either<Failure, List<FacultyModel>>> getFaculties() async {
    try {
      final response = await _dio.get(ApiEndpoints.academicUnits);
      final list = (response.data as List)
          .map((e) => FacultyModel.fromJson(e))
          .toList();
      return right(list);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getPotentialHeads({
    required int departmentId,
  }) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.teachers,
        queryParameters: {'department': departmentId},
      );

      final list = (response.data as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
      return right(list);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> toggleDeptHead({required int teacherId}) async {
    try {
      final path = ApiEndpoints.toggleDeptHead.replaceFirst(
        '{id}',
        teacherId.toString(),
      );
      await _dio.post(path);
      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  // --- DEPT HEAD ---
  @override
  Future<Either<Failure, List<ClassTermModel>>>
  getDepartmentClassTerms() async {
    try {
      final response = await _dio.get(ApiEndpoints.deptHeadClassTerms);
      final list = (response.data as List)
          .map((e) => ClassTermModel.fromJson(e))
          .toList();
      return right(list);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getDepartmentTeachers() async {
    try {
      final response = await _dio.get(ApiEndpoints.deptHeadTeachers);
      final list = (response.data as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
      return right(list);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> assignAdvisor({
    required int classTermId,
    required int teacherId,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.assignAdvisor,
        data: {'class_term_id': classTermId, 'advisor_id': teacherId},
      );
      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  // --- ADVISOR ---
  @override
  Future<Either<Failure, List<UserModel>>> getMyClassStudents() async {
    try {
      final response = await _dio.get(ApiEndpoints.advisorStudents);
      final list = (response.data as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
      return right(list);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }

  @override
  Future<Either<Failure, void>> setClassRepresentative({
    required int studentId,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.setRepresentative,
        data: {'student_id': studentId},
      );
      return right(null);
    } on DioException catch (e) {
      return left(ServerFailure.fromDioError(e));
    }
  }
}
