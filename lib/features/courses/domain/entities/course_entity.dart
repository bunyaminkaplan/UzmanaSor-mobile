import 'package:mobile/core/domain/entities/simple_user_entity.dart';

/// Ders domain entity'si.
///
/// Backend: `core.models.CourseModel`
/// API: GET/POST core/courses/, GET core/courses/my-courses/
class CourseEntity {
  final int id;
  final String? courseCode;
  final String? title;
  final String? description;
  final List<SimpleUserEntity> teachers;

  const CourseEntity({
    required this.id,
    this.courseCode,
    this.title,
    this.description,
    this.teachers = const [],
  });

  /// Gösterim adı: "YAZM101 — Algoritma" veya sadece "Algoritma"
  String get displayName {
    if (courseCode != null && title != null) return '$courseCode — $title';
    return title ?? courseCode ?? 'Ders #$id';
  }
}
