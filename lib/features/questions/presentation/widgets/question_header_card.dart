import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/date_formatter.dart';
import 'package:mobile/features/questions/data/models/question_model.dart';

class QuestionHeaderCard extends StatelessWidget {
  final QuestionModel question;

  const QuestionHeaderCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.cyan.withValues(alpha: 0.1),
                child: Text(
                  question.author?.username.substring(0, 1).toUpperCase() ??
                      "A",
                  style: const TextStyle(
                    color: AppColors.cyan,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    question.author?.username ?? "Anonim",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    DateFormatter.formatTimeAgo(question.createdAt),
                    style: const TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              if (question.isSolved)
                const Icon(Icons.check_circle, color: AppColors.success),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            question.title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.navy,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            question.content,
            style: const TextStyle(fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 16),
          if (question.courseDetails != null)
            Chip(
              label: Text(question.courseDetails!.title),
              backgroundColor: AppColors.bgLight,
              labelStyle: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
              side: BorderSide.none,
            ),
        ],
      ),
    );
  }
}
