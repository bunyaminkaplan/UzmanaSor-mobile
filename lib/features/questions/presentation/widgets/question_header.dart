import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/features/questions/presentation/widgets/question_status_chip.dart';

/// Soru başlık kartı — başlık, meta (yazar/tarih), içerik, status badge.
///
/// Web: QuestionCard.jsx (read-only modu)
/// Hem StudentQuestionDetail hem TeacherQuestionDetail tarafından kullanılır.
class QuestionHeader extends StatelessWidget {
  final QuestionEntity question;

  const QuestionHeader({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMMM yyyy, HH:mm', 'tr_TR');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status badge
            Align(
              alignment: Alignment.topRight,
              child: QuestionStatusChip(status: question.status, fontSize: 12),
            ),

            // Başlık
            Text(
              question.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),

            // Meta: yazar + tarih
            Row(
              children: [
                Icon(
                  Icons.person_outline,
                  size: 16,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  question.author?.fullName ?? 'Bilinmiyor',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
                const SizedBox(width: 16),
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(width: 4),
                Text(
                  dateFormat.format(question.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // İçerik
            Text(
              question.content,
              style: theme.textTheme.bodyLarge?.copyWith(height: 1.6),
            ),
          ],
        ),
      ),
    );
  }
}
