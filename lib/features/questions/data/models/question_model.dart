import 'package:mobile/core/data/models/simple_user_model.dart';
import 'package:mobile/core/domain/entities/simple_user_entity.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/features/questions/domain/entities/question_status.dart';

/// Question JSON → Entity mapper.
class QuestionModel {
  final Map<String, dynamic> _json;

  QuestionModel(this._json);

  QuestionEntity toEntity() {
    return QuestionEntity(
      id: _json['id'] as int,
      title: _json['title'] as String? ?? '',
      content: _json['content'] as String? ?? '',
      createdAt:
          DateTime.tryParse(_json['created_at'] as String? ?? '') ??
          DateTime.now(),
      questionPriority: _json['question_priority'] as int? ?? 0,
      isPublic: _json['is_public'] as bool? ?? false,
      author: _parseUser(_json['question_author']),
      currentHandler: _parseUser(_json['question_current_handler']),
      intendedTeacher: _parseUser(_json['intended_teacher']),
      status: QuestionStatus.fromValue(
        _json['status'] as String? ?? 'reviewing',
      ),
      statusDisplay: _json['status_display'] as String?,
      repStatus: RepStatus.fromValue(_json['rep_status'] as String?),
      repStatusDisplay: _json['rep_status_display'] as String?,
      courseId: _json['course'] as int?,
      courseDetails: _parseCourseDetails(_json['course_details']),
      answers: _parseAnswers(_json['answers']),
      transitions: _parseTransitions(_json['transitions']),
      lastForwardedBy: _parseUser(_json['last_forwarded_by']),
      canEdit: _json['can_edit'] as bool? ?? false,
    );
  }
}

/// Answer JSON → Entity mapper.
class AnswerModel {
  final Map<String, dynamic> _json;

  AnswerModel(this._json);

  AnswerEntity toEntity() {
    return AnswerEntity(
      id: _json['id'] as int,
      questionId: _json['question'] as int? ?? 0,
      author: _parseUser(_json['author']),
      content: _json['content'] as String? ?? '',
      createdAt: DateTime.tryParse(_json['created_at'] as String? ?? ''),
    );
  }
}

// ---------------------------------------------------------------------------
// Parse Helpers
// ---------------------------------------------------------------------------

SimpleUserModel? _parseUserModel(dynamic json) {
  if (json == null || json is! Map<String, dynamic>) return null;
  return SimpleUserModel.fromJson(json);
}

SimpleUserEntity? _parseUser(dynamic json) {
  return _parseUserModel(json)?.toEntity();
}

CourseDetailsEntity? _parseCourseDetails(dynamic json) {
  if (json == null || json is! Map<String, dynamic>) return null;
  return CourseDetailsEntity(
    id: json['id'] as int,
    courseCode: json['course_code'] as String?,
    title: json['title'] as String?,
  );
}

List<AnswerEntity> _parseAnswers(dynamic json) {
  if (json == null || json is! List) return [];
  return json
      .map((a) => AnswerModel(a as Map<String, dynamic>).toEntity())
      .toList();
}

List<TransitionEntity> _parseTransitions(dynamic json) {
  if (json == null || json is! List) return [];
  return json.map((t) {
    final m = t as Map<String, dynamic>;
    return TransitionEntity(
      id: m['id'] as int,
      action: m['action'] as String? ?? '',
      actionDisplay: m['action_display'] as String?,
      fromUser: _parseUser(m['from_user']),
      toUser: _parseUser(m['to_user']),
      performedBy: _parseUser(m['performed_by']),
      note: m['note'] as String?,
      createdAt: DateTime.tryParse(m['created_at'] as String? ?? ''),
    );
  }).toList();
}
