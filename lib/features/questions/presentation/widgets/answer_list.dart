import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/shared/widgets/empty_state_widget.dart';

/// Cevap listesi widget'ı — soru detay sayfasında kullanılır.
///
/// Web: AnswerList.jsx
class AnswerListWidget extends StatelessWidget {
  final List<AnswerEntity> answers;

  const AnswerListWidget({super.key, required this.answers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 20,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Cevaplar (${answers.length})',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        if (answers.isEmpty)
          const EmptyStateWidget(
            icon: Icons.chat_bubble_outline,
            title: 'Henüz bu soruya bir cevap verilmemiş',
          )
        else
          ...answers.map((answer) => _AnswerCard(answer: answer)),
      ],
    );
  }
}

/// Internal: tekil cevap kartı.
class _AnswerCard extends StatelessWidget {
  final AnswerEntity answer;
  const _AnswerCard({required this.answer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM yyyy, HH:mm', 'tr_TR');

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  answer.author?.fullName ?? 'Anonim',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (answer.createdAt != null)
                  Text(
                    dateFormat.format(answer.createdAt!),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              answer.content,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
