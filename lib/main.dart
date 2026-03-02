import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// main.dart — Uygulama giriş noktası.
//
// Başlatma sırası:
//   1. Flutter engine hazırla
//   2. ApiClient'ı async olarak oluştur (cookie jar dizini gerektiğinden)
//   3. ProviderContainer'a apiClientProvider override'ı ile enjekte et
//   4. MyApp'i UncontrolledProviderScope ile sar → GoRouter çalışsın
// ---------------------------------------------------------------------------
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR');

  // ApiClient async init (PersistCookieJar disk yolu gerektirir)
  final apiClient = await ApiClient.create();

  // ProviderContainer — apiClient senkron Provider olarak override
  final container = ProviderContainer(
    overrides: [apiClientProvider.overrideWithValue(apiClient)],
  );

  runApp(UncontrolledProviderScope(container: container, child: const MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);

    return MaterialApp.router(
      title: 'UzmanaSor',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
