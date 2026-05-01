import 'package:mobile/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/features/questions/data/repositories/question_repository_impl.dart';

/// Temsilci Onay / Red Aksiyonları Widget'ı
///
/// Web: RepQuestionCard.jsx → Onayla + Reddet butonları + inline red sebebi modal.
/// Mobil uyarlama: BottomSheet ile red sebebi alınır (mobile-native pattern).
class RepActionButtons extends ConsumerStatefulWidget {
  final int questionId;

  const RepActionButtons({super.key, required this.questionId});

  @override
  ConsumerState<RepActionButtons> createState() => _RepActionButtonsState();
}

class _RepActionButtonsState extends ConsumerState<RepActionButtons> {
  bool _isSubmitting = false;

  // ─── ONAY ───
  Future<void> _handleApprove() async {
    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(questionRepositoryProvider);
      final result = await repo.repApprove(widget.questionId);

      result.fold(
        (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Onay başarısız: ${failure.message}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Soru onaylandı ve akademisyene iletildi.'),
              backgroundColor: AppColors.success,
            ),
          );
          // Onaylandıktan sonra bu soruya erişim kesileceği için
          // detail provider'ını GÜNCELLEMİYORUZ, direkt listeye dönüyoruz.
          // Ve döndüğümüzde listenin yenilenmesi (invalidate) için parametre ekliyoruz.
          if (context.canPop()) {
            context.pop(true); // true = refresh et beni
          } else {
            context.go('/dashboard?refresh=true');
          }
        },
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // ─── RED ───
  Future<void> _showRejectSheet() async {
    final reason = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => const _RejectReasonSheet(),
    );

    if (reason == null || !mounted) return; // İptal ettiyse çık

    setState(() => _isSubmitting = true);
    try {
      final repo = ref.read(questionRepositoryProvider);
      final result = await repo.repReject(widget.questionId, reason);

      result.fold(
        (failure) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Red başarısız: ${failure.message}'),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        },
        (_) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Soru reddedildi. Öğrenci bilgilendirilecek.'),
              backgroundColor: AppColors.accentOrange,
            ),
          );
          // Listeye dön
          if (context.canPop()) {
            context.pop(true);
          } else {
            context.go('/dashboard?refresh=true');
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

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: BorderSide(color: theme.colorScheme.tertiary, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.how_to_vote,
                  size: 20,
                  color: theme.colorScheme.tertiary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Temsilci İşlemleri',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // Reddet Butonu
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSubmitting ? null : _showRejectSheet,
                    icon: const Icon(Icons.close),
                    label: const Text('Reddet'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: theme.colorScheme.error,
                      side: BorderSide(color: theme.colorScheme.error),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Onayla Butonu
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _isSubmitting ? null : _handleApprove,
                    icon: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.check),
                    label: const Text('Onayla'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
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

// ─── Red Sebebi BottomSheet (mobile-native) ───
class _RejectReasonSheet extends StatefulWidget {
  const _RejectReasonSheet();

  @override
  State<_RejectReasonSheet> createState() => _RejectReasonSheetState();
}

class _RejectReasonSheetState extends State<_RejectReasonSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Red Sebebi',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sorunun neden reddedildiğini açıklayabilirsiniz (opsiyonel).',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.outline,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 4,
            minLines: 3,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Örn: Soru anlaşılır değil, lütfen daha detaylı yazın.',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context), // null = iptal
                  child: const Text('İptal'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: FilledButton.icon(
                  onPressed: () =>
                      Navigator.pop(context, _controller.text.trim()),
                  icon: const Icon(Icons.close),
                  label: const Text('Reddet'),
                  style: FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
