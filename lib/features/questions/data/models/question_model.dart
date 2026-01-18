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

    @JsonKey(name: 'question_priority') int? priority,

    @JsonKey(name: 'question_author') UserModel? author,
    @JsonKey(name: 'question_current_handler') UserModel? currentHandler,
    @JsonKey(name: 'question_old_handler') UserModel? oldHandler,
    @JsonKey(name: 'course_details') CourseDetails? courseDetails,
    @JsonKey(name: 'class_term_details') ClassTermDetails? classTermDetails,

    @Default([]) List<AnswerModel> answers,
  }) = _QuestionModel;

  const QuestionModel._();
  bool get isSolved => answers.isNotEmpty;

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    // 🛡️ Defensive Copy & Check
    // The backend might send an ID (int) instead of a User Object (Map)
    // for handlers when they are updated via PATCH. This prevents the crash.
    final sanitizedJson = Map<String, dynamic>.from(json);

    if (sanitizedJson['question_old_handler'] != null &&
        sanitizedJson['question_old_handler'] is! Map) {
      print(
        "⚠️ [DEBUG] QuestionModel: 'question_old_handler' was not a Map. Value: ${sanitizedJson['question_old_handler']}. Setting to null.",
      );
      sanitizedJson['question_old_handler'] = null;
    }

    if (sanitizedJson['question_current_handler'] != null &&
        sanitizedJson['question_current_handler'] is! Map) {
      print(
        "⚠️ [DEBUG] QuestionModel: 'question_current_handler' was not a Map. Value: ${sanitizedJson['question_current_handler']}. Setting to null.",
      );
      sanitizedJson['question_current_handler'] = null;
    }

    return _$QuestionModelFromJson(sanitizedJson);
  }
}

@freezed
abstract class AnswerModel with _$AnswerModel {
  const factory AnswerModel({
    required int id,
    required String content,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    required UserModel author,
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
    @Default([]) List<UserModel> teachers,
  }) = _CourseDetails;

  factory CourseDetails.fromJson(Map<String, dynamic> json) =>
      _$CourseDetailsFromJson(json);
}

@freezed
abstract class ClassTermDetails with _$ClassTermDetails {
  const factory ClassTermDetails({
    @JsonKey(name: 'department_name') String? departmentName,
    @JsonKey(name: 'term_display') String? termDisplay,
  }) = _ClassTermDetails;

  factory ClassTermDetails.fromJson(Map<String, dynamic> json) =>
      _$ClassTermDetailsFromJson(json);
}
