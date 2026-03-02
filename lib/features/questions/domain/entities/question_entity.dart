import 'package:mobile/core/domain/entities/simple_user_entity.dart';
import 'package:mobile/features/questions/domain/entities/question_status.dart';

/// Soru domain entity'si.
///
/// Backend: `core.models.QuestionBinderModel`
/// Serializer: `QuestionSerializer`
class QuestionEntity {
  final int id;
  final String title;
  final String content;
  final DateTime createdAt;
  final int questionPriority;
  final bool isPublic;

  // Kullanıcılar
  final SimpleUserEntity? author;
  final SimpleUserEntity? currentHandler;
  final SimpleUserEntity? intendedTeacher;

  // Durum
  final QuestionStatus status;
  final String? statusDisplay;
  final RepStatus repStatus;
  final String? repStatusDisplay;

  // Ders bilgisi
  final int? courseId;
  final CourseDetailsEntity? courseDetails;

  // Cevaplar
  final List<AnswerEntity> answers;

  // Geçiş tarihçesi
  final List<TransitionEntity> transitions;

  // İletim bilgisi
  final SimpleUserEntity? lastForwardedBy;

  // Düzenleme yetkisi
  final bool canEdit;

  const QuestionEntity({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    this.questionPriority = 0,
    this.isPublic = false,
    this.author,
    this.currentHandler,
    this.intendedTeacher,
    this.status = QuestionStatus.reviewing,
    this.statusDisplay,
    this.repStatus = RepStatus.notRequired,
    this.repStatusDisplay,
    this.courseId,
    this.courseDetails,
    this.answers = const [],
    this.transitions = const [],
    this.lastForwardedBy,
    this.canEdit = false,
  });
}

/// Ders detay bilgisi (soru içinde nested).
class CourseDetailsEntity {
  final int id;
  final String? courseCode;
  final String? title;

  const CourseDetailsEntity({required this.id, this.courseCode, this.title});

  String get displayName {
    if (courseCode != null && title != null) return '$courseCode — $title';
    return title ?? courseCode ?? 'Ders #$id';
  }
}

/// Cevap entity'si.
class AnswerEntity {
  final int id;
  final int questionId;
  final SimpleUserEntity? author;
  final String content;
  final DateTime? createdAt;

  const AnswerEntity({
    required this.id,
    required this.questionId,
    this.author,
    required this.content,
    this.createdAt,
  });
}

/// Soru geçiş tarihçesi entity'si (audit trail).
class TransitionEntity {
  final int id;
  final String action;
  final String? actionDisplay;
  final SimpleUserEntity? fromUser;
  final SimpleUserEntity? toUser;
  final SimpleUserEntity? performedBy;
  final String? note;
  final DateTime? createdAt;

  const TransitionEntity({
    required this.id,
    required this.action,
    this.actionDisplay,
    this.fromUser,
    this.toUser,
    this.performedBy,
    this.note,
    this.createdAt,
  });
}
