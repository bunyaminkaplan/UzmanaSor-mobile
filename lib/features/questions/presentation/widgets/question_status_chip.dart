import 'package:flutter/material.dart';

import 'package:mobile/features/questions/domain/entities/question_status.dart';

/// Tekleştirilmiş durum badge'i — hem liste kartında hem detay sayfasında kullanılır.
class QuestionStatusChip extends StatelessWidget {
  final QuestionStatus status;
  final double fontSize;

  const QuestionStatusChip({
    super.key,
    required this.status,
    this.fontSize = 11,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final (Color bg, Color fg) = switch (status) {
      QuestionStatus.reviewing || QuestionStatus.repPending => (
        cs.tertiaryContainer,
        cs.onTertiaryContainer,
      ),
      QuestionStatus.repApproved || QuestionStatus.repBypassed => (
        cs.primaryContainer,
        cs.onPrimaryContainer,
      ),
      QuestionStatus.answered => (
        cs.secondaryContainer,
        cs.onSecondaryContainer,
      ),
      QuestionStatus.forwarded || QuestionStatus.closed => (
        cs.surfaceContainerHighest,
        cs.onSurfaceVariant,
      ),
      QuestionStatus.repRejected => (cs.errorContainer, cs.onErrorContainer),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status.displayName,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
