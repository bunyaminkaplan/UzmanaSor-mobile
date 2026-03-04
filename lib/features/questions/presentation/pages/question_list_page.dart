import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/features/questions/presentation/providers/question_provider.dart';
import 'package:mobile/features/questions/presentation/widgets/question_card.dart';

/// Soru listesi sayfası — dashboard'dan veya direkt route'tan erişilir.
/// Backend'e `author=me` gönderir: sadece kullanıcının kendi sorularını getirir.
class QuestionListPage extends ConsumerWidget {
  const QuestionListPage({super.key});

  static const _queryParams = {'author': 'me'};

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final questionsAsync = ref.watch(questionsProvider(_queryParams));

    return Scaffold(
      appBar: AppBar(title: const Text('Sorularım')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => GoRouter.of(context).push('/ask'),
        icon: const Icon(Icons.add),
        label: const Text('Soru Sor'),
      ),
      body: questionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Sorular yüklenemedi',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => ref.invalidate(questionsProvider(null)),
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
              ),
            ],
          ),
        ),
        data: (questions) {
          if (questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz soru yok',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              ref.invalidate(questionsProvider(_queryParams));
            },
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: questions.length,
              itemBuilder: (context, index) {
                final question = questions[index];
                return QuestionCard(
                  question: question,
                  onTap: () =>
                      GoRouter.of(context).push('/questions/${question.id}'),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
