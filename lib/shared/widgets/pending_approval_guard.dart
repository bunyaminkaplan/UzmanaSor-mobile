import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_colors.dart';

/// PendingApprovalGuard — kullanıcı henüz onaylanmamışsa engelleme widget'ı.
///
/// Web: PendingApproval.jsx → is_approved==false ise dashboard yerine
/// "Hesabınız onay bekliyor" mesajı gösterilir.
///
/// Kullanım: Dashboard widget'ının en üstünde early-return olarak.
class PendingApprovalGuard extends StatelessWidget {
  const PendingApprovalGuard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.accentOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.hourglass_top_rounded,
                  size: 64,
                  color: AppColors.accentOrange,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Hesap Onayı Bekleniyor',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Hesabınız henüz yetkili tarafından onaylanmamış.\n'
                'Onaylandıktan sonra tüm özelliklere erişebileceksiniz.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.outline,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Icon(
                Icons.info_outline,
                size: 20,
                color: theme.colorScheme.outline,
              ),
              const SizedBox(height: 8),
              Text(
                'Bu işlem genellikle 24 saat içinde tamamlanır.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.outline,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
