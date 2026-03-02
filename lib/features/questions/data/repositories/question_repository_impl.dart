import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/features/questions/data/datasources/question_remote_data_source.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/features/questions/domain/repositories/question_repository.dart';

class QuestionRepositoryImpl implements QuestionRepository {
  final QuestionRemoteDataSource _dataSource;

  QuestionRepositoryImpl(this._dataSource);

  @override
  Future<Either<Failure, List<QuestionEntity>>> getQuestions({
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final models = await _dataSource.getQuestions(queryParams: queryParams);
      return Right(models.map((m) => m.toEntity()).toList());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, QuestionEntity>> getQuestionDetail(int id) async {
    try {
      final model = await _dataSource.getQuestionDetail(id);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, QuestionEntity>> createQuestion({
    required String title,
    required String content,
    required int courseId,
    required int targetTeacherId,
    bool isPublic = false,
  }) async {
    try {
      final model = await _dataSource.createQuestion({
        'title': title,
        'content': content,
        'course': courseId,
        'target_teacher_id': targetTeacherId,
        'is_public': isPublic,
      });
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> forwardQuestion(
    int questionId,
    int recipientId,
  ) async {
    try {
      await _dataSource.forwardQuestion(questionId, recipientId);
      return const Right(null);
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, QuestionEntity>> repApprove(int questionId) async {
    try {
      final model = await _dataSource.repApprove(questionId);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, QuestionEntity>> repReject(
    int questionId,
    String reason,
  ) async {
    try {
      final model = await _dataSource.repReject(questionId, reason);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, QuestionEntity>> resubmit(
    int questionId,
    Map<String, dynamic> data,
  ) async {
    try {
      final model = await _dataSource.resubmit(questionId, data);
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }

  @override
  Future<Either<Failure, AnswerEntity>> createAnswer({
    required int questionId,
    required String content,
  }) async {
    try {
      final model = await _dataSource.createAnswer({
        'question': questionId,
        'content': content,
      });
      return Right(model.toEntity());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure('Beklenmeyen hata: $e'));
    }
  }
}

/// Riverpod provider
final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepositoryImpl(ref.watch(questionRemoteDataSourceProvider));
});
