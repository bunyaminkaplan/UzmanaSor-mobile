import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/questions/data/repositories/question_repository_impl.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';

/// Soru listesi state'i — sayfalama farkında.
///
/// `nextPath == null` ise daha çekilecek sayfa kalmadı demektir.
class QuestionsState {
  final List<QuestionEntity> items;
  final String? nextPath;
  final int totalCount;
  final bool isLoadingMore;
  final Object? loadMoreError;

  const QuestionsState({
    required this.items,
    required this.nextPath,
    required this.totalCount,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  bool get hasMore => nextPath != null;

  QuestionsState copyWith({
    List<QuestionEntity>? items,
    String? nextPath,
    int? totalCount,
    bool? isLoadingMore,
    Object? loadMoreError,
    bool clearLoadMoreError = false,
    bool clearNextPath = false,
  }) {
    return QuestionsState(
      items: items ?? this.items,
      nextPath: clearNextPath ? null : (nextPath ?? this.nextPath),
      totalCount: totalCount ?? this.totalCount,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      loadMoreError:
          clearLoadMoreError ? null : (loadMoreError ?? this.loadMoreError),
    );
  }
}

/// Soru listesi notifier'ı — ilk sayfayı `build()` çeker;
/// `loadMore()` bir sonraki sayfayı listeye ekler; `refresh()` sıfırlar.
///
/// Kullanım: `ref.watch(questionsProvider({'mode': 'public_feed'}))`
///         + `ref.read(questionsProvider(params).notifier).loadMore()`
class QuestionsNotifier
    extends AutoDisposeFamilyAsyncNotifier<
      QuestionsState,
      Map<String, dynamic>?
    > {
  @override
  Future<QuestionsState> build(Map<String, dynamic>? arg) async {
    final repo = ref.watch(questionRepositoryProvider);
    final result = await repo.getQuestions(queryParams: arg);
    return result.fold((f) => throw f, (page) {
      return QuestionsState(
        items: page.items,
        nextPath: page.nextPath,
        totalCount: page.totalCount,
      );
    });
  }

  Future<void> loadMore() async {
    final current = state.valueOrNull;
    if (current == null) return;
    if (current.nextPath == null || current.isLoadingMore) return;

    state = AsyncData(
      current.copyWith(isLoadingMore: true, clearLoadMoreError: true),
    );

    final repo = ref.read(questionRepositoryProvider);
    final result = await repo.getQuestionsNextPage(current.nextPath!);

    result.fold(
      (f) {
        final s = state.valueOrNull ?? current;
        state = AsyncData(s.copyWith(isLoadingMore: false, loadMoreError: f));
      },
      (page) {
        final s = state.valueOrNull ?? current;
        state = AsyncData(
          QuestionsState(
            items: [...s.items, ...page.items],
            nextPath: page.nextPath,
            totalCount: page.totalCount,
            isLoadingMore: false,
          ),
        );
      },
    );
  }

  /// Listeyi sıfırlayıp ilk sayfayı yeniden çeker.
  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => build(arg));
  }
}

/// Soru listesi provider'ı (sayfalanmış).
final questionsProvider = AutoDisposeAsyncNotifierProviderFamily<
  QuestionsNotifier,
  QuestionsState,
  Map<String, dynamic>?
>(QuestionsNotifier.new);

/// Tekil soru detay provider'ı.
final questionDetailProvider = FutureProvider.autoDispose
    .family<QuestionEntity, int>((ref, id) async {
      final repo = ref.watch(questionRepositoryProvider);
      final result = await repo.getQuestionDetail(id);
      return result.fold((f) => throw f, (question) => question);
    });
