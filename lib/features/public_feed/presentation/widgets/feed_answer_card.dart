import 'package:flutter/material.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';

/// İçerisindeki cevapların standart bir şekilde çizilmesini sağlayan paylaşılan bileşen (DRY).
class FeedAnswerCard extends StatelessWidget {
  final AnswerEntity answer;
  final bool isSnippet; // 'Son Cevap' badge'i göstermek için

  const FeedAnswerCard({
    super.key,
    required this.answer,
    this.isSnippet = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isSnippet
            ? AppColors.accentCyan.withValues(alpha: 0.05)
            : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSnippet
              ? AppColors.accentCyan.withValues(alpha: 0.15)
              : theme.dividerColor.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sol Taraftaki Yazar (veya Snippet başlığı)
              if (isSnippet)
                Row(
                  children: [
                    Icon(Icons.reply, size: 14, color: AppColors.accentCyan),
                    const SizedBox(width: 6),
                    Text(
                      'Son Cevap - ${answer.author?.fullName ?? "Bilinmiyor"}',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accentCyan,
                      ),
                    ),
                  ],
                )
              else
                Text(
                  answer.author?.fullName ?? 'Bilinmiyor',
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.accentCyan,
                  ),
                ),

              // Sağ Taraftaki Tarih
              if (answer.createdAt != null)
                Text(
                  _formatAnsDate(answer.createdAt!),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.textMutedDark,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            answer.content,
            maxLines: isSnippet ? 2 : null,
            overflow: isSnippet ? TextOverflow.ellipsis : null,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }

  String _formatAnsDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.${date.month.toString().padLeft(2, '0')}.${date.year}';
  }
}
