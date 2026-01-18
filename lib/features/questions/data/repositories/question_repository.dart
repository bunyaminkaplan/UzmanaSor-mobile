import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/questions/data/models/question_model.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepositoryImpl(ref.read(dioProvider));
});

abstract class QuestionRepository {
  Future<Either<Failure, List<QuestionModel>>> getQuestions({int page = 1});
  Future<Either<Failure, QuestionModel>> getQuestion(int id);
  Future<Either<Failure, List<CourseDetails>>> getCourses();
  Future<Either<Failure, List<UserModel>>> getTeachers();
  Future<Either<Failure, void>> createQuestion({
    required String title,
    required String content,
    required int courseId,
    required int teacherId,
  });
  Future<Either<Failure, void>> forwardQuestion({
    required int questionId,
    required int newHandlerId,
  });
  Future<Either<Failure, void>> postAnswer({
    required int questionId,
    required String content,
  });
}

class QuestionRepositoryImpl implements QuestionRepository {
  final Dio _dio;

  QuestionRepositoryImpl(this._dio);

  @override
  Future<Either<Failure, List<QuestionModel>>> getQuestions({
    int page = 1,
  }) async {
    try {
      final response = await _dio.get(ApiEndpoints.questions);

      final data = response.data;

      List<dynamic> results;
      if (data is Map<String, dynamic> && data.containsKey('results')) {
        results = data['results'];
      } else if (data is List) {
        results = data;
      } else {
        return Left(ServerFailure("Bilinmeyen veri formatı"));
      }

      final questions = results.map((e) => QuestionModel.fromJson(e)).toList();

      return Right(questions);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e, stack) {
      print("🔴 [DEBUG] CRITICAL ERROR in Repository (getQuestions): $e");
      print("🔴 [DEBUG] Stack: $stack");
      return Left(ServerFailure("Veri işleme hatası: $e"));
    }
  }

  @override
  Future<Either<Failure, List<CourseDetails>>> getCourses() async {
    try {
      final response = await _dio.get(ApiEndpoints.courses);
      final data = response.data;

      if (data is List) {
        final courses = data.map((e) => CourseDetails.fromJson(e)).toList();
        return Right(courses);
      } else {
        return Left(
          ServerFailure("Beklenmeyen veri formatı (Liste bekleniyordu)"),
        );
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e, stack) {
      print("🔴 [DEBUG] CRITICAL ERROR in Repository (getCourses): $e");
      print("🔴 [DEBUG] Stack: $stack");
      return Left(ServerFailure("Dersler yüklenirken hata oluştu: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> createQuestion({
    required String title,
    required String content,
    required int courseId,
    required int teacherId,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.questions,
        data: {
          'title': title,
          'content': content,
          'course': courseId,
          'target_teacher_id': teacherId,
        },
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure("Soru oluşturulurken hata oluştu: $e"));
    }
  }

  @override
  Future<Either<Failure, QuestionModel>> getQuestion(int id) async {
    try {
      final response = await _dio.get(ApiEndpoints.questionDetail(id));
      return Right(QuestionModel.fromJson(response.data));
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e, stack) {
      print("🔴 [DEBUG] CRITICAL ERROR in Repository (getQuestion): $e");
      print("🔴 [DEBUG] Stack: $stack");
      return Left(ServerFailure("Soru detayları alınırken hata oluştu: $e"));
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getTeachers() async {
    try {
      final response = await _dio.get(ApiEndpoints.teachers);
      final data = response.data;
      if (data is List) {
        final teachers = data.map((e) => UserModel.fromJson(e)).toList();
        return Right(teachers);
      } else {
        return Left(
          ServerFailure("Beklenmeyen veri formatı (Liste bekleniyordu)"),
        );
      }
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e, stack) {
      print("🔴 [DEBUG] CRITICAL ERROR in Repository (getTeachers): $e");
      print("🔴 [DEBUG] Stack: $stack");
      return Left(ServerFailure("Eğitmenler yüklenirken hata oluştu: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> forwardQuestion({
    required int questionId,
    required int newHandlerId,
  }) async {
    try {
      // Backend expects: POST /core/questions/{id}/forward/
      // Body: { "recipient_id": 123 }
      await _dio.post(
        ApiEndpoints.questionForward(questionId),
        data: {'recipient_id': newHandlerId},
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure("Soru yönlendirilirken hata oluştu: $e"));
    }
  }

  @override
  Future<Either<Failure, void>> postAnswer({
    required int questionId,
    required String content,
  }) async {
    try {
      await _dio.post(
        ApiEndpoints.answers,
        data: {'question': questionId, 'content': content},
      );
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure("Cevap gönderilirken hata oluştu: $e"));
    }
  }
}
