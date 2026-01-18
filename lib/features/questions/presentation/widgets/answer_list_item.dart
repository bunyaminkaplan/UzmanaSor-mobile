import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/date_formatter.dart';
import 'package:mobile/features/questions/data/models/question_model.dart';

class AnswerListItem extends StatelessWidget {
  final AnswerModel answer;

  const AnswerListItem({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    final isAuthorTeacher = answer.author.userType == 'teacher';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isAuthorTeacher
            ? AppColors.cyan.withValues(alpha: 0.05)
            : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isAuthorTeacher
              ? AppColors.cyan.withValues(alpha: 0.3)
              : AppColors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                answer.author.username,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isAuthorTeacher ? AppColors.cyan : AppColors.navy,
                ),
              ),
              if (isAuthorTeacher) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.cyan,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'Eğitmen',
                    style: TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                DateFormatter.formatTimeAgo(answer.createdAt),
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textMuted,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(answer.content),
        ],
      ),
    );
  }
}
