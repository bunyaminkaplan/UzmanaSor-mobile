import 'package:mobile/core/data/models/simple_user_model.dart';
import 'package:mobile/features/courses/domain/entities/course_entity.dart';

/// Backend JSON → Domain Entity mapper'ları.

class CourseModel {
  final int id;
  final String? courseCode;
  final String? title;
  final String? description;
  final List<SimpleUserModel> teachers;

  const CourseModel({
    required this.id,
    this.courseCode,
    this.title,
    this.description,
    this.teachers = const [],
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int,
      courseCode: json['course_code'] as String?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      teachers:
          (json['teachers'] as List<dynamic>?)
              ?.map((t) => SimpleUserModel.fromJson(t as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  CourseEntity toEntity() => CourseEntity(
    id: id,
    courseCode: courseCode,
    title: title,
    description: description,
    teachers: teachers.map((t) => t.toEntity()).toList(),
  );
}
