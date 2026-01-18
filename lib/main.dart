import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/theme/app_theme.dart';

import 'package:mobile/core/network/dio_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Create ProviderContainer to read providers before UI
  final container = ProviderContainer();

  // 2. Initialize Cookies & Dio Interceptors
  try {
    final dio = container.read(dioProvider);
    final cookieJar = await container.read(cookieJarProvider.future);
    await setupDio(dio, cookieJar);
    print("✅ Dio setup complete with Cookies.");
  } catch (e) {
    print("❌ Failed to setup Dio: $e");
  }

  // 3. Run App with the same container
  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'UzmanaSor',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.light, // Change to .dark to test dark mode
      routerConfig: router,
    );
  }
}
