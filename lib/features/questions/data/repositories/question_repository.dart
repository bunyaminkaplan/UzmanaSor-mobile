import 'package:fpdart/fpdart.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/errors/failure.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/questions/data/models/question_model.dart';

final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return QuestionRepositoryImpl(ref.read(dioProvider));
});

abstract class QuestionRepository {
  Future<Either<Failure, List<QuestionModel>>> getQuestions({int page = 1});
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
      print("[QuestionRepository] Parse Error: $e");
      print(stack);
      return Left(ServerFailure("Veri işleme hatası: $e"));
    }
  }
}
