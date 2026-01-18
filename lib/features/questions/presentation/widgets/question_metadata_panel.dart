import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/questions/data/models/question_model.dart';

class QuestionMetadataPanel extends StatelessWidget {
  final QuestionModel question;

  const QuestionMetadataPanel({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Class & Term
          if (question.classTermDetails != null)
            _MetadataRow(
              icon: Icons.school_outlined,
              label:
                  "${question.classTermDetails?.departmentName ?? '-'} - ${question.classTermDetails?.termDisplay ?? '-'}",
            ),

          // Row 2: Course
          if (question.courseDetails != null)
            _MetadataRow(
              icon: Icons.book_outlined,
              label: question.courseDetails!.title,
            ),

          // Row 3: Handler / Forwarding Chain
          _buildHandlerInfo(question),

          // Row 4: Priority
          _MetadataRow(
            icon: Icons.flag_outlined,
            label: _getPriorityLabel(question.priority),
            labelColor: _getPriorityColor(question.priority),
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHandlerInfo(QuestionModel question) {
    if (question.oldHandler != null && question.currentHandler != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.transfer_within_a_station,
              size: 18,
              color: AppColors.textSecondary,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(
                    "${question.oldHandler!.firstName} ${question.oldHandler!.lastName}",
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      decoration: TextDecoration.lineThrough,
                      fontSize: 13,
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.0),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppColors.orange,
                    ),
                  ),
                  Text(
                    "${question.currentHandler!.firstName} ${question.currentHandler!.lastName}",
                    style: const TextStyle(
                      color: AppColors.navy,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    } else if (question.currentHandler != null) {
      return _MetadataRow(
        icon: Icons.person_outline,
        label:
            "Sorumlu: ${question.currentHandler!.firstName} ${question.currentHandler!.lastName}",
      );
    }
    return const SizedBox.shrink();
  }

  String _getPriorityLabel(int? priority) {
    switch (priority) {
      case 3:
        return "Yüksek Öncelik";
      case 2:
        return "Orta Öncelik";
      case 1:
      default:
        return "Normal Öncelik";
    }
  }

  Color _getPriorityColor(int? priority) {
    switch (priority) {
      case 3:
        return AppColors.error;
      case 2:
        return AppColors.orange;
      case 1:
      default:
        return AppColors.success;
    }
  }
}

class _MetadataRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? labelColor;
  final bool isBold;

  const _MetadataRow({
    required this.icon,
    required this.label,
    this.labelColor,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                color: labelColor ?? AppColors.textPrimary,
                fontSize: 13,
                fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
