import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/features/questions/data/repositories/question_repository_impl.dart';
import 'package:mobile/features/questions/presentation/providers/question_provider.dart';

/// Hoca için Soru Cevaplama Formu
class TeacherAnswerForm extends ConsumerStatefulWidget {
  final int questionId;

  const TeacherAnswerForm({super.key, required this.questionId});

  @override
  ConsumerState<TeacherAnswerForm> createState() => _TeacherAnswerFormState();
}

class _TeacherAnswerFormState extends ConsumerState<TeacherAnswerForm> {
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submitAnswer() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) return;

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(questionRepositoryProvider);
      final result = await repo.createAnswer(
        questionId: widget.questionId,
        content: content,
      );

      result.fold(
        (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cevap gönderilemedi: ${failure.message}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        (_) {
          if (!mounted) return;
          _contentController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cevap başarıyla gönderildi.'),
              backgroundColor: Colors.green,
            ),
          );
          // Sayfa verisini yenile
          ref.invalidate(questionDetailProvider(widget.questionId));
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: theme.colorScheme.primary, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.reply, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Cevap Yaz',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 4,
              minLines: 3,
              readOnly: _isSubmitting,
              decoration: const InputDecoration(
                hintText: 'Cevabınızı buraya yazın...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.icon(
                onPressed: _isSubmitting ? null : _submitAnswer,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.send),
                label: Text(
                  _isSubmitting ? 'Gönderiliyor...' : 'Cevabı Gönder',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
