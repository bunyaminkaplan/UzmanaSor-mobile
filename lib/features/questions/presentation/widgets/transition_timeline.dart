import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/questions/domain/entities/question_entity.dart';

/// Soru geçiş tarihçesi timeline widget'ı.
///
/// Aksiyon tipine göre özel renk/ikon gösterir ve fromUser/toUser
/// verilerini kullanarak bağlamsal (contextual) cümleler kurar.
class TransitionTimeline extends StatelessWidget {
  final List<TransitionEntity> transitions;

  const TransitionTimeline({super.key, required this.transitions});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('d MMM yyyy, HH:mm', 'tr_TR');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.history, size: 20, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Geçiş Tarihçesi',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            ...transitions.asMap().entries.map((entry) {
              final index = entry.key;
              final t = entry.value;
              final isLast = index == transitions.length - 1;

              final config = _getTimelineConfig(context, t.action);

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Sol Taraf: Timeline İkon ve Çizgisi
                    SizedBox(
                      width: 40,
                      child: Column(
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: config.bgColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: config.iconColor,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              config.icon,
                              size: 16,
                              color: config.iconColor,
                            ),
                          ),
                          if (!isLast)
                            Expanded(
                              child: Container(
                                width: 2,
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                color: theme.colorScheme.outlineVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Sağ Taraf: İçerik Kartı
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isLast ? 0 : 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Aksiyon Başlığı ve Tarih
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    t.actionDisplay ??
                                        _fallbackActionName(t.action),
                                    style: theme.textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: config.iconColor,
                                    ),
                                  ),
                                ),
                                if (t.createdAt != null)
                                  Text(
                                    dateFormat.format(t.createdAt!),
                                    style: theme.textTheme.labelSmall?.copyWith(
                                      color: theme.colorScheme.outline,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            // Bağlamsal Cümle
                            Text(
                              _generateContextualMessage(t),
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                            // Varsa Not (Örn: Red Sebebi, Yönlendirme Notu)
                            if (t.note != null && t.note!.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: theme
                                      .colorScheme
                                      .surfaceContainerHighest
                                      .withValues(alpha: 0.5),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: theme.colorScheme.outlineVariant,
                                  ),
                                ),
                                child: Text(
                                  '"${t.note}"',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  /// Aksiyon tipine göre ikon, arkaplan ve icon rengi döndürür.
  _TimelineConfig _getTimelineConfig(BuildContext context, String action) {
    final cs = Theme.of(context).colorScheme;
    return switch (action) {
      'created' => _TimelineConfig(
        icon: Icons.add,
        iconColor: AppColors.accentCyan,
        bgColor: AppColors.accentCyan.withValues(alpha: 0.1),
      ),
      'forwarded' => _TimelineConfig(
        icon: Icons.double_arrow,
        iconColor: AppColors.info,
        bgColor: AppColors.info.withValues(alpha: 0.1),
      ),
      'rep_approved' => _TimelineConfig(
        icon: Icons.check,
        iconColor: AppColors.success,
        bgColor: AppColors.success.withValues(alpha: 0.1),
      ),
      'rep_rejected' => _TimelineConfig(
        icon: Icons.close,
        iconColor: cs.error,
        bgColor: cs.errorContainer,
      ),
      'resubmitted' => _TimelineConfig(
        icon: Icons.refresh,
        iconColor: AppColors.accentOrange,
        bgColor: AppColors.accentOrange.withValues(alpha: 0.1),
      ),
      'answered' => _TimelineConfig(
        icon: Icons.forum,
        iconColor: AppColors.accentNavy,
        bgColor: AppColors.accentNavy.withValues(alpha: 0.1),
      ),
      _ => _TimelineConfig(
        icon: Icons.info_outline,
        iconColor: cs.outline,
        bgColor: cs.surfaceContainerHighest,
      ),
    };
  }

  /// Backend'den actionDisplay gelmezse (fallback).
  String _fallbackActionName(String action) {
    return switch (action) {
      'created' => 'Oluşturuldu',
      'forwarded' => 'Yönlendirildi',
      'rep_approved' => 'Temsilci Onayladı',
      'rep_rejected' => 'Temsilci Reddetti',
      'resubmitted' => 'Yeniden Gönderildi',
      'answered' => 'Cevaplandı',
      _ => action.toUpperCase(),
    };
  }

  /// from_user ve to_user verilerini kullanarak okunaklı cümle oluşturur.
  String _generateContextualMessage(TransitionEntity t) {
    final performer = t.performedBy?.fullName ?? 'Sistem';
    final from = t.fromUser?.fullName;
    final to = t.toUser?.fullName;

    switch (t.action) {
      case 'created':
        return '$performer tarafından soru oluşturuldu.';

      case 'forwarded':
        if (from != null && to != null) {
          return '$from, soruyu $to kişisine yönlendirdi.';
        } else if (to != null) {
          return '$performer tarafından $to kişisine yönlendirdi.';
        }
        return '$performer tarafından başka bir hocaya yönlendirildi.';

      case 'rep_approved':
        return 'Temsilci $performer tarafından soru onaylanarak yayına/hocaya iletildi.';

      case 'rep_rejected':
        return 'Temsilci $performer tarafından soru uygun bulunmayarak reddedildi.';

      case 'resubmitted':
        return '$performer, reddedilen soruyu düzenleyerek yeniden değerlendirmeye sundu.';

      case 'answered':
        return '$performer tarafından soruya cevap yazıldı.';

      default:
        return '$performer tarafından işlem gerçekleştirildi.';
    }
  }
}

class _TimelineConfig {
  final IconData icon;
  final Color iconColor;
  final Color bgColor;

  _TimelineConfig({
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}
