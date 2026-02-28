import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

/// E-posta doğrulama sayfası.
///
/// Backend akışı:
///   1. Register sonrası backend otomatik doğrulama kodu gönderir
///   2. Kullanıcı kodu girer → POST auth/verify-code/
///   3. Kod yanlışsa hata, doğruysa hesap aktif olur
///   4. Yeniden gönder → PUT auth/verify-code/
class VerifyPage extends ConsumerStatefulWidget {
  const VerifyPage({super.key});

  @override
  ConsumerState<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends ConsumerState<VerifyPage> {
  final _codeController = TextEditingController();
  bool _isVerifying = false;
  bool _isResending = false;
  String? _message;
  bool _isError = false;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      setState(() {
        _message = 'Doğrulama kodunu girin';
        _isError = true;
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _message = null;
    });

    final result = await ref.read(authProvider.notifier).verifyCode(code);

    if (!mounted) return;

    setState(() {
      _isVerifying = false;
      if (result['success'] == true) {
        _message = result['message']?.toString() ?? 'Doğrulama başarılı!';
        _isError = false;
      } else {
        _message = result['error']?.toString() ?? 'Doğrulama başarısız';
        _isError = true;
      }
    });
  }

  Future<void> _handleResend() async {
    setState(() {
      _isResending = true;
      _message = null;
    });

    final result = await ref.read(authProvider.notifier).resendCode();

    if (!mounted) return;

    setState(() {
      _isResending = false;
      if (result['success'] == true) {
        _message = result['message']?.toString() ?? 'Kod yeniden gönderildi!';
        _isError = false;
      } else {
        _message = result['error']?.toString() ?? 'Kod gönderilemedi';
        _isError = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('E-posta Doğrulama')),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // İkon
                const Icon(
                  Icons.mark_email_read_outlined,
                  size: 72,
                  color: AppColors.accentCyan,
                ),
                const SizedBox(height: 24),

                // Başlık
                Text('Kodunuzu Girin', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 8),
                Text(
                  'E-posta adresinize gönderilen doğrulama kodunu girin.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMuted,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Kod Girişi
                TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelText: 'Doğrulama Kodu',
                    prefixIcon: Icon(Icons.pin_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall,
                  onFieldSubmitted: (_) => _handleVerify(),
                ),
                const SizedBox(height: 16),

                // Mesaj
                if (_message != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _message!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: _isError ? AppColors.error : AppColors.success,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Doğrula Butonu
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _handleVerify,
                    child: _isVerifying
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text('Doğrula'),
                  ),
                ),
                const SizedBox(height: 12),

                // Yeniden Gönder
                TextButton(
                  onPressed: _isResending ? null : _handleResend,
                  child: _isResending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text('Kodu Yeniden Gönder'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
