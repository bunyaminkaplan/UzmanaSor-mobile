import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/admin/presentation/pages/approval_page.dart';
import 'package:mobile/features/auth/presentation/pages/login_page.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/admin/presentation/pages/assignment_hub_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/dashboard_dispatcher.dart';

final goRouterProvider = Provider<GoRouter>((ref) {
  // We need to listen to auth state changes to trigger redirects

  return GoRouter(
    initialLocation: '/dashboard',
    debugLogDiagnostics: true,
    refreshListenable: AuthListenable(ref), // Custom Listenable
    redirect: (context, state) {
      final authState = ref.read(authProvider);

      // 1. Loading State Guards
      // If we are still checking session, DO NOT REDIRECT.
      // This prevents kicking the user to login page while the cookie check is happening.
      if (authState.isLoading) return null;

      final isLoggedIn = authState.value != null;
      final isLoggingIn = state.matchedLocation == '/login';

      // 2. Auth Guards
      if (!isLoggedIn) {
        // If not logged in and not on login page, go to login
        return isLoggingIn ? null : '/login';
      }

      if (isLoggedIn) {
        // If logged in and trying to go to login, go to dashboard
        return isLoggingIn ? '/dashboard' : null;
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardDispatcher(),
      ),
      GoRoute(
        path: '/approvals',
        builder: (context, state) => const ApprovalPage(),
      ),
      GoRoute(
        path: '/assignments',
        builder: (context, state) => const AssignmentHubPage(),
      ),
    ],
  );
});

/// A Listenable that notifies when [authProvider] state changes.
class AuthListenable extends ChangeNotifier {
  final Ref ref;

  AuthListenable(this.ref) {
    ref.listen(authProvider, (_, __) => notifyListeners());
  }
}
