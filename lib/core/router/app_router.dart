import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/features/auth/domain/entities/user_entity.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/pages/login_page.dart';

// ---------------------------------------------------------------------------
// GoRouter — Uygulama navigasyonu.
//
// initialLocation: /dashboard (session varsa direkt açılır)
// refreshListenable: AuthListenable (auth state değişince re-evaluate)
// redirect: Auth guard — login/logout yönlendirmeleri
// ---------------------------------------------------------------------------

final goRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/dashboard',
    debugLogDiagnostics: false,
    refreshListenable: AuthListenable(ref),
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      // Loading iken yönlendirme yapma
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value != null;
      final isOnLogin = state.matchedLocation == '/login';

      // Giriş yapmamışsa → login'e
      if (!isLoggedIn) return isOnLogin ? null : '/login';

      // Giriş yapmışsa ve login'deyse → dashboard'a
      if (isLoggedIn && isOnLogin) return '/dashboard';

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const _PlaceholderPage(title: 'Dashboard'),
      ),
    ],
  );
});

/// Auth state değişimlerinde GoRouter'ı tetikleyen Listenable.
class AuthListenable extends ChangeNotifier {
  final Ref ref;

  AuthListenable(this.ref) {
    ref.listen<AsyncValue<UserEntity?>>(authProvider, (previous, next) {
      if (previous?.isLoading != next.isLoading) {
        notifyListeners();
        return;
      }
      if (previous?.value != next.value) {
        notifyListeners();
        return;
      }
      if (previous?.hasError != next.hasError) {
        notifyListeners();
        return;
      }
    });
  }
}

/// Geçici placeholder — iskelet fazında dashboard yerine gösterilir.
class _PlaceholderPage extends StatelessWidget {
  final String title;
  const _PlaceholderPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '$title — Faz 0 İskelet',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}
