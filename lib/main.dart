import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/core/ui_kit/uzman_button.dart';
import 'package:mobile/core/ui_kit/uzman_text_field.dart';
import 'package:mobile/features/auth/presentation/pages/login_page.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'UzmanaSor UI Kit',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Change to .dark to test dark mode
      home: const LoginPage(),
    );
  }
}

class UiPlaygroundPage extends StatelessWidget {
  const UiPlaygroundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("UzmanaSor UI Kit Test"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Typography Section
              Text(
                "Tipografi Testi",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Bu bir body text örneğidir. Design system fontları (Montserrat) burada aktif olmalıdır.",
              ),
              const SizedBox(height: 24),

              // Inputs Section
              Text(
                "Input Fields",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              UzmanTextField(
                label: "E-posta Adresi",
                controller: TextEditingController(),
                hint: "test@uzman.com",
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
              ),
              const SizedBox(height: 16),
              UzmanTextField(
                label: "Şifre",
                controller: TextEditingController(),
                isPassword: true,
                prefixIcon: Icons.lock_outline,
              ),
              const SizedBox(height: 16),
              UzmanTextField(
                label: "Hatalı Input",
                controller: TextEditingController(text: "Yanlış Veri"),
                errorText: "Geçersiz format",
                prefixIcon: Icons.error_outline,
              ),

              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 32),

              // Buttons Section
              Text("Buttons", style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: UzmanButton(
                      label: "Primary",
                      variant: ButtonVariant.primary,
                      onPressed: () {},
                      icon: Icons.check,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: UzmanButton(
                      label: "Secondary",
                      variant: ButtonVariant.secondary,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              UzmanButton(
                label: "Danger Action",
                variant: ButtonVariant.danger,
                onPressed: () {},
                icon: Icons.delete_outline,
              ),
              const SizedBox(height: 16),

              UzmanButton(
                label: "Outline Button",
                variant: ButtonVariant.outline,
                onPressed: () {},
              ),
              const SizedBox(height: 16),

              UzmanButton(
                label: "Loading...",
                isLoading: true,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
