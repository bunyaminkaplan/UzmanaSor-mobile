import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/ui_kit/ui_kit.dart';

class AnswerInputArea extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmit;
  final bool isLoading;

  const AnswerInputArea({
    super.key,
    required this.controller,
    required this.onSubmit,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        16 + MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceLight,
        border: Border(top: BorderSide(color: AppColors.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: UzmanTextField(
              label: '', // No label for chat-like input
              controller: controller,
              hint: 'Cevap yaz...',
              maxLines: 1,
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: isLoading ? null : onSubmit,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.send, color: AppColors.cyan),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.bgLight,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }
}
