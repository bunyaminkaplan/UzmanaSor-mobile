import 'package:fpdart/fpdart.dart';

import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/courses/domain/entities/course_entity.dart';

/// Courses repository kontratı.
abstract class CourseRepository {
  /// Tüm dersleri getirir.
  /// Backend: GET core/courses/
  Future<Either<Failure, List<CourseEntity>>> getCourses();

  /// Giriş yapmış kullanıcının derslerini getirir.
  /// Backend: GET core/courses/my-courses/
  Future<Either<Failure, List<CourseEntity>>> getMyCourses();
}
