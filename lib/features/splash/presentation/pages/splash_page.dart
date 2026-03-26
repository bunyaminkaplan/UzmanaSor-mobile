import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

/// Faz 5-Extra: Custom Flutter Splash Screen
///
/// Native splash biter bitmez devreye girer. Logo animasyonunu oynatır.
/// Mimari kural: En az 1.5 saniye ekranda kalır (markalama için).
/// Bu süre zarfında AuthProvider durumunu kontrol eder ve süresi
/// dolduğunda ilgili rotaya (login veya dashboard) yönlendirir.
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    // Animasyon tanımları
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _controller.forward();

    // Minimum 2 saniye Splash ekranını göster ve yönlendir
    _navigateWithDelay();
  }

  Future<void> _navigateWithDelay() async {
    // Animasyonu izlemesi için min 2 saniye bekle
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // authProvider sonucunu dinle
    final authState = ref.read(authProvider);

    // Eğer hala yükleniyorsa biraz daha bekle (secure_storage genelde hızlıdır)
    if (authState.isLoading) {
      ref.listenManual(authProvider, (previous, next) {
        if (!next.isLoading && mounted) {
          _handleRouting(next);
        }
      });
    } else {
      _handleRouting(authState);
    }
  }

  void _handleRouting(AsyncValue authState) {
    if (!mounted) return;

    final user = authState.value;
    if (user != null) {
      if (!user.isEmailVerified) {
        context.go('/verify');
      } else {
        context.go('/dashboard');
      }
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF12141C), // Native splash rengiyle uyumlu
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png',
                  width: 140,
                  height: 140,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                // Marka İsmi
                const Text(
                  'UzmanaSor',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Akademik İşbirliği Ekosistemi',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withValues(alpha: 0.7),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 48),
                const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.accentCyan,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
