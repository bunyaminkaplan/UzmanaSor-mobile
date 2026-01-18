import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/admin/data/models/class_term_model.dart';
import 'package:mobile/features/admin/data/models/faculty_model.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

abstract interface class AssignmentRepository {
  // DEAN Functions
  Future<Either<Failure, List<FacultyModel>>> getFaculties();
  Future<Either<Failure, List<UserModel>>> getPotentialHeads({
    required int departmentId,
  });
  Future<Either<Failure, void>> toggleDeptHead({required int teacherId});

  // DEPT HEAD Functions
  Future<Either<Failure, List<ClassTermModel>>> getDepartmentClassTerms();
  Future<Either<Failure, List<UserModel>>> getDepartmentTeachers();
  Future<Either<Failure, void>> assignAdvisor({
    required int classTermId,
    required int teacherId,
  });

  // ADVISOR Functions
  Future<Either<Failure, List<UserModel>>> getMyClassStudents();
  Future<Either<Failure, void>> setClassRepresentative({
    required int studentId,
  });
}
