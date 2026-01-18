import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/questions/presentation/providers/question_feed_provider.dart';
import 'package:mobile/features/questions/presentation/widgets/question_card.dart';

class FeedView extends ConsumerWidget {
  const FeedView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(questionFeedProvider);

    return feedState.when(
      data: (questions) {
        if (questions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.feed_outlined,
                  size: 60,
                  color: AppColors.textSecondary,
                ),
                SizedBox(height: 16),
                Text(
                  "Henüz hiç soru sorulmamış.",
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await ref
                .read(questionFeedProvider.notifier)
                .loadQuestions(refresh: true);
          },
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: questions.length,
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final question = questions[index];
              return QuestionCard(question: question);
            },
          ),
        );
      },
      error: (error, stack) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: AppColors.error),
            const SizedBox(height: 16),
            Text("Bir hata oluştu:\n$error", textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                ref
                    .read(questionFeedProvider.notifier)
                    .loadQuestions(refresh: true);
              },
              child: const Text("Tekrar Dene"),
            ),
          ],
        ),
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
}
