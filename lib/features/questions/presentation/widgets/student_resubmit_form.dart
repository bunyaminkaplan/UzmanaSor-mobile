import 'package:mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/features/questions/data/repositories/question_repository_impl.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';

/// Öğrenci Soruyu Düzenle & Tekrar Gönder Widget'ı
///
/// Web: StudentQuestionDetail.jsx → Rejected banner + edit mode + POST resubmit.
/// Mobil uyarlama: Inline düzenleme alanları (TextField) + Gönder/İptal butonları.
class StudentResubmitForm extends ConsumerStatefulWidget {
  final QuestionEntity question;

  const StudentResubmitForm({super.key, required this.question});

  @override
  ConsumerState<StudentResubmitForm> createState() =>
      _StudentResubmitFormState();
}

class _StudentResubmitFormState extends ConsumerState<StudentResubmitForm> {
  bool _isEditing = false;
  bool _isSubmitting = false;
  late TextEditingController _titleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.question.title);
    _contentController = TextEditingController(text: widget.question.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _titleController.text = widget.question.title;
      _contentController.text = widget.question.content;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
      _titleController.text = widget.question.title;
      _contentController.text = widget.question.content;
    });
  }

  Future<void> _submitResubmit() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Başlık ve içerik boş olamaz.'),
          backgroundColor: AppColors.accentOrange,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(questionRepositoryProvider);
      final result = await repo.resubmit(widget.question.id, {
        'title': title,
        'content': content,
      });

      result.fold(
        (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Tekrar gönderme başarısız: ${failure.message}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Soru düzenlendi ve tekrar gönderildi.'),
              backgroundColor: AppColors.success,
            ),
          );
          // Listeye dön
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/questions');
          }
        },
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Düzenleme modunda değilse: uyarı banner'ı + düzenle butonu
    if (!_isEditing) {
      return Card(
        color: theme.colorScheme.errorContainer.withValues(alpha: 0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: BorderSide(
            color: theme.colorScheme.error.withValues(alpha: 0.5),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: theme.colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Bu soru sınıf temsilcisi tarafından reddedildi.',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'Düzenleyip tekrar gönderebilirsiniz.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _startEditing,
                  icon: const Icon(Icons.edit),
                  label: const Text('Düzenle & Tekrar Gönder'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Düzenleme modundayken: başlık + içerik TextField + Gönder/İptal
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
                Icon(
                  Icons.edit_note,
                  size: 20,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Soruyu Düzenle',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              readOnly: _isSubmitting,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              readOnly: _isSubmitting,
              maxLines: 5,
              minLines: 3,
              decoration: const InputDecoration(
                labelText: 'İçerik',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSubmitting ? null : _cancelEditing,
                    child: const Text('İptal'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _submitResubmit,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.send),
                    label: Text(
                      _isSubmitting ? 'Gönderiliyor...' : 'Tekrar Gönder',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
