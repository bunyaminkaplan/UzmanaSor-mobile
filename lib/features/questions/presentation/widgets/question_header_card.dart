import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/utils/date_formatter.dart';
import 'package:mobile/features/questions/data/models/question_model.dart';
import 'package:mobile/features/questions/presentation/widgets/question_metadata_panel.dart';

class QuestionHeaderCard extends StatefulWidget {
  final QuestionModel question;

  const QuestionHeaderCard({super.key, required this.question});

  @override
  State<QuestionHeaderCard> createState() => _QuestionHeaderCardState();
}

class _QuestionHeaderCardState extends State<QuestionHeaderCard> {
  bool _isExpanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // 1. TOP HEADER (Always Visible) - Avatar, Name, Badges, ExpandToggle
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Avatar
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppColors.cyan.withValues(alpha: 0.1),
                    child: Text(
                      widget.question.author?.username[0].toUpperCase() ?? "A",
                      style: const TextStyle(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Name & Time
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${widget.question.author?.firstName ?? 'Anonim'} ${widget.question.author?.lastName ?? ''}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.navy,
                          ),
                        ),
                        Text(
                          DateFormatter.formatTimeAgo(
                            widget.question.createdAt,
                          ),
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status Icons
                  if (widget.question.isSolved)
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 20,
                      ),
                    ),
                  if (widget.question.oldHandler != null)
                    const Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(
                        Icons.forward_to_inbox,
                        color: AppColors.orange,
                        size: 20,
                      ),
                    ),

                  // Toggle Icon
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),

          // 2. CONTENT AREA (Collapsible)
          // Using plain if since AnimatedCrossFade might be overkill/complex for text resizing
          if (_isExpanded) ...[
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    widget.question.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.navy,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Content
                  Text(
                    widget.question.content,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // 3. RICH METADATA PANEL
                  QuestionMetadataPanel(question: widget.question),
                ],
              ),
            ),
          ] else ...[
            // Collapsed Summary (Title Truncated)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Text(
                widget.question.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
