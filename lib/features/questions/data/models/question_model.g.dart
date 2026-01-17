// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QuestionModel _$QuestionModelFromJson(Map<String, dynamic> json) =>
    _QuestionModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      priority: json['question_priority'] as String?,
      author: json['question_author'] == null
          ? null
          : UserModel.fromJson(json['question_author'] as Map<String, dynamic>),
      currentHandler: json['question_current_handler'] == null
          ? null
          : UserModel.fromJson(
              json['question_current_handler'] as Map<String, dynamic>,
            ),
      courseDetails: json['course_details'] == null
          ? null
          : CourseDetails.fromJson(
              json['course_details'] as Map<String, dynamic>,
            ),
      classTermDetails: json['class_term_details'] == null
          ? null
          : ClassTermDetails.fromJson(
              json['class_term_details'] as Map<String, dynamic>,
            ),
      answers:
          (json['answers'] as List<dynamic>?)
              ?.map((e) => AnswerModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$QuestionModelToJson(_QuestionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'question_priority': instance.priority,
      'question_author': instance.author,
      'question_current_handler': instance.currentHandler,
      'course_details': instance.courseDetails,
      'class_term_details': instance.classTermDetails,
      'answers': instance.answers,
    };

_AnswerModel _$AnswerModelFromJson(Map<String, dynamic> json) => _AnswerModel(
  id: (json['id'] as num).toInt(),
  content: json['content'] as String,
  createdAt: DateTime.parse(json['created_at'] as String),
  author: UserModel.fromJson(json['author'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AnswerModelToJson(_AnswerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'author': instance.author,
    };

_CourseDetails _$CourseDetailsFromJson(Map<String, dynamic> json) =>
    _CourseDetails(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      code: json['code'] as String?,
    );

Map<String, dynamic> _$CourseDetailsToJson(_CourseDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'code': instance.code,
    };

_ClassTermDetails _$ClassTermDetailsFromJson(Map<String, dynamic> json) =>
    _ClassTermDetails(
      departmentName: json['department_name'] as String?,
      termDisplay: json['term_display'] as String?,
    );

Map<String, dynamic> _$ClassTermDetailsToJson(_ClassTermDetails instance) =>
    <String, dynamic>{
      'department_name': instance.departmentName,
      'term_display': instance.termDisplay,
    };
