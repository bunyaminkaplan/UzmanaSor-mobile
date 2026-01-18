import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/questions/data/models/question_model.dart';
import 'package:mobile/features/questions/data/repositories/question_repository.dart';

import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

final questionFeedProvider =
    AsyncNotifierProvider.autoDispose<
      QuestionFeedNotifier,
      List<QuestionModel>
    >(() {
      return QuestionFeedNotifier();
    });

class QuestionFeedNotifier
    extends AutoDisposeAsyncNotifier<List<QuestionModel>> {
  late QuestionRepository _repository;

  @override
  FutureOr<List<QuestionModel>> build() async {
    // Watch Auth Provider to force refresh when user changes (Login/Logout)
    ref.watch(authProvider);

    _repository = ref.watch(questionRepositoryProvider);
    return _fetchQuestions();
  }

  Future<List<QuestionModel>> _fetchQuestions() async {
    final result = await _repository.getQuestions();
    return result.fold(
      (failure) => throw failure, // AsyncValue handles exceptions
      (questions) => questions,
    );
  }

  Future<void> loadQuestions({bool refresh = false}) async {
    if (refresh) {
      state = const AsyncValue.loading();
      state = await AsyncValue.guard(() => _fetchQuestions());
    }
    // Initial load handled by build()
  }
}
