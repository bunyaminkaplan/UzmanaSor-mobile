import 'package:flutter/material.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_colors_ext.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/features/questions/presentation/widgets/question_status_chip.dart';
import 'package:mobile/features/public_feed/presentation/widgets/answers_bottom_sheet.dart';
import 'package:mobile/features/public_feed/presentation/widgets/feed_answer_card.dart';

/// FeedQuestionCard — Public Feed (Genel Akış) için özel tasarlanmış accordion soru kartı.
/// Sosyal medya feed'lerinde olduğu gibi metin kısaltması (devamını göster)
/// ve cevapların detaylı okunabilmesi için BottomSheet mekanizması barındırır.
class FeedQuestionCard extends StatefulWidget {
  final QuestionEntity question;

  const FeedQuestionCard({super.key, required this.question});

  @override
  State<FeedQuestionCard> createState() => _FeedQuestionCardState();
}

class _FeedQuestionCardState extends State<FeedQuestionCard> {
  bool _isCardExpanded = false;
  bool _isTextExpanded = false;

  void _toggleCard() {
    setState(() {
      _isCardExpanded = !_isCardExpanded;
      // Kart kapandığında metin genişlemesini de sıfırla
      if (!_isCardExpanded) {
        _isTextExpanded = false;
      }
    });
  }

  void _showAnswersSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) =>
          AnswersBottomSheet(answers: widget.question.answers),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final q = widget.question;

    return Card(
      margin: const EdgeInsets.only(bottom: 8, left: 16, right: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      elevation: _isCardExpanded ? 2 : 0.5,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        alignment: Alignment.topCenter,
        child: IntrinsicWidth(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── HEADER (KAPALI DURUM) ──
              InkWell(
                onTap: _toggleCard,
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
                        color: _isCardExpanded
                            ? AppColors.accentCyan
                            : theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          q.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: _isCardExpanded
                                ? AppColors.accentCyan
                                : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      QuestionStatusChip(status: q.status),
                      const SizedBox(width: 4),
                      Icon(
                        _isCardExpanded ? Icons.expand_less : Icons.expand_more,
                        size: 20,
                        color: theme.colorScheme.outline,
                      ),
                    ],
                  ),
                ),
              ),

              // ── EXPANDED CONTENT ──
              if (_isCardExpanded) ...[
                Divider(height: 1, color: theme.dividerColor),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 1. Meta Bigiler
                      Wrap(
                        spacing: 16,
                        runSpacing: 4,
                        children: [
                          _buildMetaItem(
                            Icons.calendar_today,
                            _formatDate(q.createdAt),
                          ),
                          if (q.author != null)
                            _buildMetaItem(Icons.person, q.author!.fullName),
                          if (q.courseDetails?.title != null)
                            _buildMetaItem(Icons.book, q.courseDetails!.title!),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // 2. Soru İçeriği (Truncation Mantığı)
                      _buildTruncatedContent(theme),
                      const SizedBox(height: 20),

                      // 3. Son Cevap (Eğer varsa)
                      if (q.answers.isNotEmpty) ...[
                        FeedAnswerCard(answer: q.answers.last, isSnippet: true),
                        const SizedBox(height: 16),
                      ],

                      // 4. Tüm Cevapları Göster Butonu
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.tonal(
                          onPressed: () => _showAnswersSheet(context),
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            foregroundColor: theme.colorScheme.onSurfaceVariant,
                          ),
                          child: Text(
                            q.answers.isNotEmpty
                                ? 'Tüm Cevapları Göster (${q.answers.length})'
                                : 'Cevapları Gör / Soru Detayına Git',
                          ),
                        ),
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

  Widget _buildTruncatedContent(ThemeData theme) {
    const int wordLimit = 15; // " ~10 kelime" esnekliği
    final words = widget.question.content.split(' ');

    if (words.length <= wordLimit) {
      // Metin zaten kısa, toggle'a gerek yok
      return Text(
        widget.question.content,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.outline,
          height: 1.5,
        ),
      );
    }

    if (_isTextExpanded) {
      // Tamexpanded hali, ama sonuna 'daha az göster' eklenmeli
      return GestureDetector(
        onTap: () => setState(() => _isTextExpanded = false),
        child: RichText(
          text: TextSpan(
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.outline,
              height: 1.5,
            ),
            children: [
              TextSpan(text: '${widget.question.content}\n'),
              TextSpan(
                text: 'daha az göster',
                style: TextStyle(
                  color: context.textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Truncated (Kısaltılmış) metin
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
                color: context.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: context.textMuted),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(fontSize: 12, color: context.textMuted),
        ),
      ],
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
