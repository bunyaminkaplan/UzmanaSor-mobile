import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/features/questions/data/repositories/question_repository_impl.dart';
import 'package:mobile/features/teachers/presentation/providers/teachers_provider.dart';

/// Hoca için Soru Yönlendirme (Ata) Formu
class TeacherForwardForm extends ConsumerStatefulWidget {
  final int questionId;

  const TeacherForwardForm({super.key, required this.questionId});

  @override
  ConsumerState<TeacherForwardForm> createState() => _TeacherForwardFormState();
}

class _TeacherForwardFormState extends ConsumerState<TeacherForwardForm> {
  int? _selectedTeacherId;
  bool _isSubmitting = false;

  Future<void> _submitForward() async {
    if (_selectedTeacherId == null) return;

    setState(() => _isSubmitting = true);

    try {
      final repo = ref.read(questionRepositoryProvider);
      final result = await repo.forwardQuestion(
        widget.questionId,
        _selectedTeacherId!,
      );

      result.fold(
        (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Yönlendirme başarısız: ${failure.message}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Soru başarıyla yönlendirildi.'),
              backgroundColor: Colors.green,
            ),
          );
          // Yönlendirme sonrası hocanın üzerinden düşer, listeye dön.
          if (context.canPop()) {
            context.pop();
          } else {
            context.go('/dashboard');
          }
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
    final teachersAsync = ref.watch(teachersProvider(null));

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: theme.colorScheme.outlineVariant, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.share, size: 20, color: theme.colorScheme.secondary),
                const SizedBox(width: 8),
                Text(
                  'Başka Hocaya Ata',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Hoca Seçin:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            teachersAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text(
                'Hocalar yüklenemedi.',
                style: TextStyle(color: theme.colorScheme.error),
              ),
              data: (teachers) {
                return InputDecorator(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      isExpanded: true,
                      value: _selectedTeacherId,
                      hint: const Text('Seçiniz'),
                      items: teachers.map((t) {
                        return DropdownMenuItem(
                          value: t.id,
                          child: Text(t.fullName),
                        );
                      }).toList(),
                      onChanged: _isSubmitting
                          ? null
                          : (val) {
                              setState(() {
                                _selectedTeacherId = val;
                              });
                            },
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: FilledButton.tonalIcon(
                onPressed: (_isSubmitting || _selectedTeacherId == null)
                    ? null
                    : _submitForward,
                icon: _isSubmitting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.share),
                label: const Text('Yönlendir'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
