import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/questions/data/repositories/question_repository_impl.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';

/// Soru listesi provider'ı.
///
/// Opsiyonel query parametreleri ile filtreleme destekler.
/// Kullanım: `ref.watch(questionsProvider(null))` veya
///           `ref.watch(questionsProvider({'author': 'me'}))`
final questionsProvider = FutureProvider.autoDispose
    .family<List<QuestionEntity>, Map<String, dynamic>?>((
      ref,
      queryParams,
    ) async {
      final repo = ref.watch(questionRepositoryProvider);
      final result = await repo.getQuestions(queryParams: queryParams);
      return result.fold((f) => throw f, (questions) => questions);
    });

/// Tekil soru detay provider'ı.
final questionDetailProvider = FutureProvider.autoDispose
    .family<QuestionEntity, int>((ref, id) async {
      final repo = ref.watch(questionRepositoryProvider);
      final result = await repo.getQuestionDetail(id);
      return result.fold((f) => throw f, (question) => question);
    });
