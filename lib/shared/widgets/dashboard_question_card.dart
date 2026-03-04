import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/features/questions/presentation/widgets/question_status_chip.dart';

/// DashboardQuestionCard — accordion (expandable) soru kartı.
///
/// Web: DashboardQuestionCard.jsx → başlık + status badge + expand → detay + aksiyon.
/// Student ve Teacher dashboard'larında soru listesinde kullanılır.
class DashboardQuestionCard extends StatelessWidget {
  final QuestionEntity question;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;

  const DashboardQuestionCard({
    super.key,
    required this.question,
    this.isExpanded = false,
    this.onToggle,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: isExpanded ? 2 : 0.5,
      child: Column(
        children: [
          // Header — tıklanınca aç/kapa
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: Radius.circular(isExpanded ? 0 : 12),
              bottomRight: Radius.circular(isExpanded ? 0 : 12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  Icon(
                    Icons.help_outline,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      question.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isExpanded ? theme.colorScheme.primary : null,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  QuestionStatusChip(status: question.status),
                ],
              ),
            ),
          ),

          // Expanded Detail
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: _ExpandedContent(
              question: question,
              onDelete: onDelete,
            ),
            crossFadeState: isExpanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _ExpandedContent extends StatelessWidget {
  final QuestionEntity question;
  final VoidCallback? onDelete;

  const _ExpandedContent({required this.question, this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Meta bilgiler
          Wrap(
            spacing: 16,
            runSpacing: 4,
            children: [
              _MetaItem(
                icon: Icons.calendar_today,
                text: _formatDate(question.createdAt),
              ),
              if (question.author != null)
                _MetaItem(
                  icon: Icons.person,
                  text:
                      '${question.author!.firstName ?? ''} ${question.author!.lastName ?? ''}'
                          .trim(),
                ),
              if (question.courseDetails?.title != null)
                _MetaItem(
                  icon: Icons.book,
                  text: question.courseDetails!.title!,
                ),
            ],
          ),
          const SizedBox(height: 12),

          // İçerik snippet
          Text(
            question.content.length > 150
                ? '${question.content.substring(0, 150)}...'
                : question.content,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 16),

          // Aksiyonlar
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              if (onDelete != null)
                TextButton(
                  onPressed: () => _confirmDelete(context),
                  child: Text(
                    'Sil',
                    style: TextStyle(
                      color: theme.colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
                ),
              const Spacer(),
              OutlinedButton.icon(
                onPressed: () =>
                    GoRouter.of(context).push('/questions/${question.id}'),
                icon: const Icon(Icons.arrow_forward, size: 16),
                label: const Text('Detayları Gör'),
                style: OutlinedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Soruyu Sil'),
        content: const Text(
          'Bu soruyu silmek istediğinize emin misiniz?\nBu işlem geri alınamaz.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete?.call();
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }
}

class _MetaItem extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MetaItem({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: theme.colorScheme.outline),
        const SizedBox(width: 4),
        Text(
          text,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.outline,
          ),
        ),
      ],
    );
  }
}
