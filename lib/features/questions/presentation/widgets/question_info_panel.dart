import 'package:flutter/material.dart';

import 'package:mobile/features/questions/domain/entities/question_entity.dart';
import 'package:mobile/features/questions/domain/entities/question_status.dart';

/// Soru bilgi paneli — sidebar'ın mobil uyarlaması.
///
/// Web: QuestionSidebar.jsx
/// Görünürlük, önem, ders, sorumlu, yönlendirme, sınıf/dönem, temsilci onay.
class QuestionInfoPanel extends StatelessWidget {
  final QuestionEntity question;

  const QuestionInfoPanel({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final showRepInfo = question.repStatus != RepStatus.notRequired;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Soru Detayları',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _InfoRow(
              icon: question.isPublic ? Icons.public : Icons.lock_outline,
              label: 'Görünürlük',
              value: question.isPublic ? 'Herkese Açık' : 'Özel / Gizli',
            ),
            _InfoRow(
              icon: Icons.flag_outlined,
              label: 'Önem Derecesi',
              value: question.questionPriority > 0
                  ? 'Yüksek (${question.questionPriority})'
                  : 'Normal',
            ),
            _InfoRow(
              icon: Icons.book_outlined,
              label: 'İlgili Ders',
              value: question.courseDetails?.displayName ?? 'Genel',
            ),
            _InfoRow(
              icon: Icons.assignment_ind_outlined,
              label: 'Şu Anki Sorumlu',
              value: question.currentHandler?.fullName ?? 'Atanmamış',
            ),

            if (question.status == QuestionStatus.forwarded &&
                question.lastForwardedBy != null)
              _InfoRow(
                icon: Icons.forward_outlined,
                label: 'İletim Bilgisi',
                value:
                    '${question.lastForwardedBy!.fullName} tarafından iletildi',
              ),

            if (question.classTermDetails != null)
              _InfoRow(
                icon: Icons.groups_outlined,
                label: 'Sınıf / Dönem',
                value: question.classTermDetails!.displayName,
              ),

            if (question.intendedTeacher != null)
              _InfoRow(
                icon: Icons.school_outlined,
                label: 'Hedef Akademisyen',
                value: question.intendedTeacher!.fullName,
              ),

            if (showRepInfo) ...[
              const Divider(height: 24),
              _InfoRow(
                icon: _repStatusIcon(question.repStatus),
                label: 'Temsilci Onay',
                value:
                    question.repStatusDisplay ?? question.repStatus.displayName,
                valueColor: _repStatusColor(context, question.repStatus),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _repStatusIcon(RepStatus status) {
    return switch (status) {
      RepStatus.pending => Icons.hourglass_empty,
      RepStatus.approved => Icons.check_circle_outline,
      RepStatus.rejected => Icons.cancel_outlined,
      RepStatus.notRequired => Icons.remove_circle_outline,
    };
  }

  Color _repStatusColor(BuildContext context, RepStatus status) {
    final cs = Theme.of(context).colorScheme;
    return switch (status) {
      RepStatus.pending => Colors.orange,
      RepStatus.approved => Colors.green,
      RepStatus.rejected => cs.error,
      RepStatus.notRequired => cs.outline,
    };
  }
}

/// Internal: bilgi paneli satırı.
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
