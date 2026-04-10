import 'package:fpdart/fpdart.dart';

import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/courses/domain/entities/course_entity.dart';

/// Courses repository kontratı — CRUD.
abstract class CourseRepository {
  /// Tüm dersleri getirir.
  /// Backend: GET core/courses/
  Future<Either<Failure, List<CourseEntity>>> getCourses();

  /// Giriş yapmış kullanıcının derslerini getirir.
  /// Backend: GET core/courses/my-courses/
  Future<Either<Failure, List<CourseEntity>>> getMyCourses();

  /// Yeni ders oluşturur.
  /// Backend: POST core/courses/
  Future<Either<Failure, CourseEntity>> createCourse({
    required String title,
    String? description,
    String? courseCode,
    List<int> teacherIds = const [],
  });

  /// Mevcut dersi günceller.
  /// Backend: PATCH core/courses/{id}/
  Future<Either<Failure, CourseEntity>> updateCourse({
    required int id,
    required String title,
    String? description,
    String? courseCode,
    List<int> teacherIds = const [],
  });

  /// Dersi siler.
  /// Backend: DELETE core/courses/{id}/
  Future<Either<Failure, void>> deleteCourse(int id);
}
