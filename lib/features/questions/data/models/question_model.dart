// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

part 'question_model.freezed.dart';
part 'question_model.g.dart';

@freezed
abstract class QuestionModel with _$QuestionModel {
  const factory QuestionModel({
    required int id,
    required String title,
    required String content,

    @JsonKey(name: 'created_at') required DateTime createdAt,

    @JsonKey(name: 'question_priority')
    int? priority, // Backend sends Integer (1, 2, 3)
    // Nested User Object (Author)
    // React: question.question_author.username -> `question_author`
    @JsonKey(name: 'question_author') UserModel? author,

    // Nested User Object (Current Handler - Advisor)
    @JsonKey(name: 'question_current_handler') UserModel? currentHandler,

    // Nested Course Object
    // React: question.course_details.title
    @JsonKey(name: 'course_details') CourseDetails? courseDetails,

    // Nested Class Term Details
    @JsonKey(name: 'class_term_details') ClassTermDetails? classTermDetails,

    // Answers List
    @Default([]) List<AnswerModel> answers,
  }) = _QuestionModel;

  factory QuestionModel.fromJson(Map<String, dynamic> json) =>
      _$QuestionModelFromJson(json);
}

@freezed
abstract class AnswerModel with _$AnswerModel {
  const factory AnswerModel({
    required int id,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required UserModel author, // Cevabı yazan kişi
  }) = _AnswerModel;

  factory AnswerModel.fromJson(Map<String, dynamic> json) =>
      _$AnswerModelFromJson(json);
}

@freezed
abstract class CourseDetails with _$CourseDetails {
  const factory CourseDetails({
    required int id,
    required String title,
    String? code,
  }) = _CourseDetails;

  factory CourseDetails.fromJson(Map<String, dynamic> json) =>
      _$CourseDetailsFromJson(json);
}

@freezed
abstract class ClassTermDetails with _$ClassTermDetails {
  const factory ClassTermDetails({
    // React: department_name, term_display
    @JsonKey(name: 'department_name') String? departmentName,
    @JsonKey(name: 'term_display') String? termDisplay,
  }) = _ClassTermDetails;

  factory ClassTermDetails.fromJson(Map<String, dynamic> json) =>
      _$ClassTermDetailsFromJson(json);
}
