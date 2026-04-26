import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/features/questions/presentation/widgets/question_status_chip.dart';
import 'package:mobile/shared/widgets/confirm_dialog.dart';

/// DashboardQuestionCard — expandable soru kartı (animasyonlu).
///
/// Web: DashboardQuestionCard.jsx karşılığı.
/// Expand state'i parent tarafından yönetilir.
class DashboardQuestionCard extends StatefulWidget {
  final QuestionEntity question;
  final bool isExpanded;
  final VoidCallback? onToggle;
  final VoidCallback? onDelete;
  final VoidCallback? onRefresh;

  const DashboardQuestionCard({
    super.key,
    required this.question,
    this.isExpanded = false,
    this.onToggle,
    this.onDelete,
    this.onRefresh,
  });

  @override
  State<DashboardQuestionCard> createState() => _DashboardQuestionCardState();
}

class _DashboardQuestionCardState extends State<DashboardQuestionCard> {
  bool _isTextExpanded = false;

  @override
  void didUpdateWidget(DashboardQuestionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Kart kapandığında metin genişlemesini de sıfırla
    if (oldWidget.isExpanded && !widget.isExpanded) {
      _isTextExpanded = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.question;
    final isExpanded = widget.isExpanded;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      elevation: isExpanded ? 2 : 0.5,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── HEADER ──
              InkWell(
                onTap: widget.onToggle,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
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
                            color: isExpanded
                                ? theme.colorScheme.primary
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      QuestionStatusChip(status: question.status),
                      const SizedBox(width: 4),
                      Icon(
                        isExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: theme.colorScheme.outline,
                      ),
                    ],
                  ),
                ),
              ),

              // ── EXPANDED CONTENT ──
              if (isExpanded) ...[
                Divider(height: 1, color: theme.dividerColor),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meta
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
                              text: question.author!.fullName,
                            ),
                          if (question.courseDetails?.title != null)
                            _MetaItem(
                              icon: Icons.book,
                              text: question.courseDetails!.title!,
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // İçerik snippet (Truncation)
                      _buildTruncatedContent(theme, question),
                      const SizedBox(height: 16),

                      // Aksiyonlar
                      Wrap(
                        alignment: WrapAlignment.end,
                        spacing: 8,
                        children: [
                          if (widget.onDelete != null)
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
                          OutlinedButton(
                            onPressed: () async {
                              final shouldRefresh = await GoRouter.of(
                                context,
                              ).push<bool?>('/questions/${question.id}');
                              if (shouldRefresh == true) {
                                if (widget.onRefresh != null) {
                                  widget.onRefresh!();
                                }
                              }
                            },
                            child: const Text(
                              'Detayları Gör',
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTruncatedContent(ThemeData theme, QuestionEntity question) {
    const int wordLimit = 15;
    final words = question.content.split(' ');

    if (words.length <= wordLimit) {
      return Text(
        question.content,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.outline,
          height: 1.5,
        ),
      );
    }

    if (_isTextExpanded) {
      return GestureDetector(
        onTap: () => setState(() => _isTextExpanded = false),
        child: RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
              height: 1.5,
            ),
            children: [
              TextSpan(text: '${question.content}\n'),
              TextSpan(
                text: 'daha az göster',
                style: TextStyle(
                  color: AppColors.textMutedDark,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final truncatedText = words.take(wordLimit).join(' ');
    return GestureDetector(
      onTap: () => setState(() => _isTextExpanded = true),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.outline,
            height: 1.5,
          ),
          children: [
            TextSpan(text: '$truncatedText... '),
            TextSpan(
              text: 'devamını göster',
              style: TextStyle(
                color: AppColors.textMutedDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await ConfirmDialog.show(
      context: context,
      title: 'Soruyu Sil',
      message: 'Bu soruyu silmek istediğinize emin misiniz?\nBu işlem geri alınamaz.',
      confirmLabel: 'Sil',
      confirmColor: Theme.of(context).colorScheme.error,
    );
    if (confirmed) widget.onDelete?.call();
  }

  static String _formatDate(DateTime date) {
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
