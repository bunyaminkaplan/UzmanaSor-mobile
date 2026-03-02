import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/constants/api_endpoints.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/features/questions/data/models/question_model.dart';

/// Questions & Answers remote data source.
abstract class QuestionRemoteDataSource {
  Future<List<QuestionModel>> getQuestions({Map<String, dynamic>? queryParams});
  Future<QuestionModel> getQuestionDetail(int id);
  Future<QuestionModel> createQuestion(Map<String, dynamic> data);
  Future<void> forwardQuestion(int questionId, int recipientId);
  Future<QuestionModel> repApprove(int questionId);
  Future<QuestionModel> repReject(int questionId, String reason);
  Future<QuestionModel> resubmit(int questionId, Map<String, dynamic> data);
  Future<AnswerModel> createAnswer(Map<String, dynamic> data);
}

class QuestionRemoteDataSourceImpl implements QuestionRemoteDataSource {
  final ApiClient _apiClient;

  QuestionRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<QuestionModel>> getQuestions({
    Map<String, dynamic>? queryParams,
  }) async {
    // Query string oluştur
    String url = ApiEndpoints.questions;
    if (queryParams != null && queryParams.isNotEmpty) {
      final qs = queryParams.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      url = '$url?$qs';
    }

    final response = await _apiClient.get(url);

    // Paginated veya düz liste
    final List<dynamic> list;
    if (response.data is List) {
      list = response.data as List;
    } else if (response.data is Map &&
        (response.data as Map).containsKey('results')) {
      list = response.data['results'] as List;
    } else {
      list = [];
    }

    return list
        .map((json) => QuestionModel(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<QuestionModel> getQuestionDetail(int id) async {
    final response = await _apiClient.get(ApiEndpoints.questionDetail(id));
    return QuestionModel(response.data as Map<String, dynamic>);
  }

  @override
  Future<QuestionModel> createQuestion(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiEndpoints.questions, data: data);
    return QuestionModel(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> forwardQuestion(int questionId, int recipientId) async {
    await _apiClient.post(
      ApiEndpoints.questionForward(questionId),
      data: {'recipient_id': recipientId},
    );
  }

  @override
  Future<QuestionModel> repApprove(int questionId) async {
    final response = await _apiClient.post(
      'core/questions/$questionId/rep-approve/',
    );
    return QuestionModel(response.data as Map<String, dynamic>);
  }

  @override
  Future<QuestionModel> repReject(int questionId, String reason) async {
    final response = await _apiClient.post(
      'core/questions/$questionId/rep-reject/',
      data: {'reason': reason},
    );
    return QuestionModel(response.data as Map<String, dynamic>);
  }

  @override
  Future<QuestionModel> resubmit(
    int questionId,
    Map<String, dynamic> data,
  ) async {
    final response = await _apiClient.post(
      'core/questions/$questionId/resubmit/',
      data: data,
    );
    return QuestionModel(response.data as Map<String, dynamic>);
  }

  @override
  Future<AnswerModel> createAnswer(Map<String, dynamic> data) async {
    final response = await _apiClient.post(ApiEndpoints.answers, data: data);
    return AnswerModel(response.data as Map<String, dynamic>);
  }
}

/// Riverpod provider
final questionRemoteDataSourceProvider = Provider<QuestionRemoteDataSource>((
  ref,
) {
  return QuestionRemoteDataSourceImpl(ref.watch(apiClientProvider));
});
