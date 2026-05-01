import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_colors_ext.dart';
import 'package:mobile/features/profile/data/busy_term_data_source.dart';

/// Akademisyen Meşgul Mod Tercihleri widget'ı.
///
/// Her ClassTerm için toggle switch gösterir.
/// Toggle ON → POST busy term, Toggle OFF → DELETE busy term.
class BusyModeSection extends ConsumerStatefulWidget {
  const BusyModeSection({super.key});

  @override
  ConsumerState<BusyModeSection> createState() => _BusyModeSectionState();
}

class _BusyModeSectionState extends ConsumerState<BusyModeSection> {
  int? _togglingId; // Hangi class_term toggle ediliyor

  Future<void> _handleToggle(int classTermId, BusyTermEntity? existing) async {
    setState(() => _togglingId = classTermId);
    try {
      final ds = ref.read(busyTermDataSourceProvider);
      if (existing != null) {
        await ds.deleteBusyTerm(existing.id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Meşgul mod kapatıldı'),
              backgroundColor: AppColors.success,
            ),
          );
        }
      } else {
        await ds.createBusyTerm(classTermId);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Meşgul mod açıldı — sorular temsilciye yönlendirilecek',
              ),
              backgroundColor: AppColors.accentOrange,
            ),
          );
        }
      }
      ref.invalidate(busyTermsProvider);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('İşlem başarısız: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _togglingId = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final classTermsAsync = ref.watch(classTermsProvider);
    final busyTermsAsync = ref.watch(busyTermsProvider);

    return Container(
      decoration: BoxDecoration(
        color: context.cardBg,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Başlık
          Row(
            children: [
              const Icon(Icons.nightlight_round, color: AppColors.accentOrange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Meşgul Mod Tercihleri',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: context.textHeading,
                  ),
                ),
              ),
              // Badge sayacı
              busyTermsAsync.whenOrNull(
                    data: (busyTerms) {
                      if (busyTerms.isEmpty) return null;
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentOrange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${busyTerms.length} sınıf meşgul',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentOrange,
                          ),
                        ),
                      );
                    },
                  ) ??
                  const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Meşgul mod açıldığında, o sınıftan gelen sorular önce sınıf temsilcisine yönlendirilir.',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: context.textMuted),
          ),
          const SizedBox(height: 16),

          // İçerik
          classTermsAsync.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (e, _) => Center(
              child: Text(
                'Veriler yüklenemedi',
                style: TextStyle(fontSize: 13, color: context.textMuted),
              ),
            ),
            data: (classTerms) {
              if (classTerms.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Henüz sınıf/dönem tanımı yok.',
                      style: TextStyle(
                        fontSize: 13,
                        color: context.textMuted,
                      ),
                    ),
                  ),
                );
              }

              final busyTerms = busyTermsAsync.valueOrNull ?? [];

              return Column(
                children: classTerms.map((ct) {
                  final existing = busyTerms
                      .where((bt) => bt.classTermId == ct.id)
                      .firstOrNull;
                  final isBusy = existing != null;
                  final isToggling = _togglingId == ct.id;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isBusy
                            ? AppColors.accentOrange.withValues(alpha: 0.06)
                            : context.inputBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isBusy
                              ? AppColors.accentOrange.withValues(alpha: 0.3)
                              : Colors.transparent,
                        ),
                      ),
                      child: Row(
                        children: [
                          // İkon
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isBusy
                                  ? AppColors.accentOrange.withValues(
                                      alpha: 0.2,
                                    )
                                  : AppColors.accentNavy.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            alignment: Alignment.center,
                            child: Icon(
                              isBusy
                                  ? Icons.nightlight_round
                                  : Icons.school_rounded,
                              size: 18,
                              color: isBusy
                                  ? AppColors.accentOrange
                                  : context.textMuted,
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Bilgi
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ct.departmentName,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: context.textHeading,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  ct.termDisplay,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: context.textMuted,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Toggle Switch
                          isToggling
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : Switch.adaptive(
                                  value: isBusy,
                                  activeTrackColor: AppColors.accentOrange,
                                  onChanged: (_) =>
                                      _handleToggle(ct.id, existing),
                                ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
