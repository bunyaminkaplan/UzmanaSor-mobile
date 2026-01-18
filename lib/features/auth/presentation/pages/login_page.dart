import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_shadows.dart';
import 'package:mobile/core/ui_kit/uzman_button.dart';
import 'package:mobile/core/ui_kit/uzman_text_field.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLogin() {
    if (_formKey.currentState?.validate() ?? false) {
      ref
          .read(authProvider.notifier)
          .login(_usernameController.text.trim(), _passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    // Listen for errors to show snackbar
    ref.listen(authProvider, (previous, next) {
      if (next.isLoading) return;

      if (next.hasError) {
        // Extract failure message if it's our Failure type
        // The provider wraps Failure in AsyncError, so we check the error property
        final error = next.error;
        String message = "Bir hata oluştu";

        if (error.toString().isNotEmpty) {
          // In a real app we'd cast to Failure, but simple toString works for now
          // since Failure.toString() can be overriden or we access .message genericly
          // Actually provider logic: AsyncValue.error(failure, ...)
          // So error object IS the failure object.
          try {
            // accessing dynamic property 'message' if it exists
            message = (error as dynamic).message;
          } catch (_) {
            message = error.toString();
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: AppColors.error),
        );
      } else if (next.value != null) {
        // Success Navigation could happen here, or in main wrapper.
        // For now, we just confirm login success visually or console.
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Giriş Başarılı! Yönlendiriliyor..."),
            backgroundColor: AppColors.success,
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            constraints: const BoxConstraints(
              maxWidth: 450,
            ), // Web-like max width
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppShadows.medium,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo Area
                  const Icon(
                    Icons.school, // Representative icon
                    size: 80,
                    color: AppColors.primaryNavy,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "MALATYA\nTURGUT ÖZAL\nÜNİVERSİTESİ",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.textHeading,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Inputs
                  UzmanTextField(
                    label: "Kullanıcı Adı",
                    controller: _usernameController,
                    prefixIcon: Icons.person_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Kullanıcı adı gerekli";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  UzmanTextField(
                    label: "Şifre",
                    controller: _passwordController,
                    isPassword: true,
                    prefixIcon: Icons.lock_outline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Şifre gerekli";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 32),

                  // Action Button
                  UzmanButton(
                    label: "Giriş Yap",
                    onPressed: authState.isLoading ? null : _onLogin,
                    isLoading: authState.isLoading,
                    variant: ButtonVariant.primary,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
