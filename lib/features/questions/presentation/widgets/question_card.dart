import 'package:flutter/material.dart';

import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/features/questions/domain/entities/question_status.dart';

/// Soru kartı widget'ı — liste sayfasında kullanılır.
class QuestionCard extends StatelessWidget {
  final QuestionEntity question;
  final VoidCallback? onTap;

  const QuestionCard({super.key, required this.question, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Başlık + Durum badge
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      question.title,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _StatusBadge(status: question.status),
                ],
              ),
              const SizedBox(height: 8),

              // İçerik önizleme
              Text(
                question.content,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),

              // Alt bilgi: yazar, ders, tarih
              Row(
                children: [
                  Icon(
                    Icons.person_outline,
                    size: 14,
                    color: theme.colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    question.author?.fullName ?? 'Bilinmiyor',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: theme.colorScheme.outline,
                    ),
                  ),
                  if (question.courseDetails != null) ...[
                    const SizedBox(width: 12),
                    Icon(
                      Icons.book_outlined,
                      size: 14,
                      color: theme.colorScheme.outline,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        question.courseDetails!.displayName,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                  const Spacer(),
                  if (question.answers.isNotEmpty)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 14,
                          color: theme.colorScheme.outline,
                        ),
                        const SizedBox(width: 2),
                        Text(
                          '${question.answers.length}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Durum badge'i.
class _StatusBadge extends StatelessWidget {
  final QuestionStatus status;

  const _StatusBadge({required this.status});

  Color _backgroundColor(ColorScheme cs) {
    switch (status) {
      case QuestionStatus.reviewing:
      case QuestionStatus.repPending:
        return cs.tertiaryContainer;
      case QuestionStatus.repApproved:
      case QuestionStatus.repBypassed:
        return cs.primaryContainer;
      case QuestionStatus.answered:
        return cs.secondaryContainer;
      case QuestionStatus.forwarded:
        return cs.surfaceContainerHighest;
      case QuestionStatus.repRejected:
        return cs.errorContainer;
      case QuestionStatus.closed:
        return cs.surfaceContainerHighest;
    }
  }

  Color _foregroundColor(ColorScheme cs) {
    switch (status) {
      case QuestionStatus.reviewing:
      case QuestionStatus.repPending:
        return cs.onTertiaryContainer;
      case QuestionStatus.repApproved:
      case QuestionStatus.repBypassed:
        return cs.onPrimaryContainer;
      case QuestionStatus.answered:
        return cs.onSecondaryContainer;
      case QuestionStatus.forwarded:
        return cs.onSurfaceVariant;
      case QuestionStatus.repRejected:
        return cs.onErrorContainer;
      case QuestionStatus.closed:
        return cs.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _backgroundColor(cs),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: _foregroundColor(cs),
        ),
      ),
    );
  }
}
