import 'package:fpdart/fpdart.dart';

import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';

/// Questions repository kontratı.
abstract class QuestionRepository {
  /// Soru listesinin ilk sayfasını getirir.
  /// Backend: GET core/questions/
  Future<Either<Failure, PaginatedQuestions>> getQuestions({
    Map<String, dynamic>? queryParams,
  });

  /// Sayfalanmış sonuçların `next` alanından gelen yolu çağırır.
  /// `path` örn: `core/questions/?page=2&mode=public_feed`
  Future<Either<Failure, PaginatedQuestions>> getQuestionsNextPage(String path);

  /// Tekil soru detayı.
  /// Backend: GET core/questions/{id}/
  Future<Either<Failure, QuestionEntity>> getQuestionDetail(int id);

  /// Yeni soru oluşturur.
  /// Backend: POST core/questions/
  Future<Either<Failure, QuestionEntity>> createQuestion({
    required String title,
    required String content,
    required int courseId,
    required int targetTeacherId,
    bool isPublic,
  });

  /// Soruyu başka hocaya yönlendirir.
  /// Backend: POST core/questions/{id}/forward/
  Future<Either<Failure, void>> forwardQuestion(
    int questionId,
    int recipientId,
  );

  /// Temsilci soruyu onaylar.
  /// Backend: POST core/questions/{id}/rep-approve/
  Future<Either<Failure, QuestionEntity>> repApprove(int questionId);

  /// Temsilci soruyu reddeder.
  /// Backend: POST core/questions/{id}/rep-reject/
  Future<Either<Failure, QuestionEntity>> repReject(
    int questionId,
    String reason,
  );

  /// Reddedilen soruyu tekrar gönderir.
  /// Backend: POST core/questions/{id}/resubmit/
  Future<Either<Failure, QuestionEntity>> resubmit(
    int questionId,
    Map<String, dynamic> data,
  );

  /// Cevap oluşturur.
  /// Backend: POST core/answers/
  Future<Either<Failure, AnswerEntity>> createAnswer({
    required int questionId,
    required String content,
  });
}
