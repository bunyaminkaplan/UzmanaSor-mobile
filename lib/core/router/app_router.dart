import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/features/auth/domain/entities/user_entity.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/pages/auth_page.dart';
import 'package:mobile/features/auth/presentation/pages/verify_page.dart';
import 'package:mobile/features/questions/presentation/pages/ask_question_page.dart';
import 'package:mobile/features/questions/presentation/pages/question_detail_page.dart';
import 'package:mobile/features/questions/presentation/pages/question_list_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/rep_dashboard_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/student_dashboard_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/teacher_dashboard_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/dean_dashboard_page.dart';

// ---------------------------------------------------------------------------
// GoRouter — Uygulama navigasyonu.
//
// Route yapısı:
//   /login       → AuthPage (Login + Register tab)
//   /verify      → VerifyPage (E-posta doğrulama)
//   /dashboard   → Placeholder (Faz 5'te gerçek dashboard)
//
// redirect mantığı:
//   1. Loading → null (bekle)
//   2. Unauthenticated → /login
//   3. Authenticated + login sayfasında → /dashboard
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

      final user = authState.value;
      final isLoggedIn = user != null;
      final currentPath = state.matchedLocation;

      // Giriş yapmamışsa → login'e
      if (!isLoggedIn) {
        return currentPath == '/login' ? null : '/login';
      }

      // Giriş yapmış ama e-posta doğrulanmamışsa → verify'a
      if (!user.isEmailVerified && currentPath != '/verify') {
        return '/verify';
      }

      // E-posta doğrulanmış ve verify/login'deyse → dashboard'a
      if (user.isEmailVerified &&
          (currentPath == '/login' || currentPath == '/verify')) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const AuthPage()),
      GoRoute(path: '/verify', builder: (context, state) => const VerifyPage()),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const _RoleDashboardBuilder(),
      ),
      GoRoute(
        path: '/questions',
        builder: (context, state) => const QuestionListPage(),
      ),
      GoRoute(
        path: '/ask',
        builder: (context, state) => const AskQuestionPage(),
      ),
      GoRoute(
        path: '/questions/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return QuestionDetailPage(questionId: id);
        },
      ),
      GoRoute(
        path: '/rep-dashboard',
        builder: (context, state) => const RepDashboardPage(),
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

/// Rol bazlı dashboard builder — kullanıcının rolüne göre doğru dashboard'u döner.
class _RoleDashboardBuilder extends ConsumerWidget {
  const _RoleDashboardBuilder();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;
    final role = user?.userType;

    switch (role) {
      case 'student':
      case 'r_student':
        return const StudentDashboardPage();
      case 'teacher':
      case 'department_head':
        return const TeacherDashboardPage();
      case 'dean':
        return const DeanDashboardPage();
      // TODO: Faz 4-d → case 'rector': return RectorDashboardPage();
      // TODO: Faz 4-e → case 'school_admin': return SchoolAdminDashboardPage();
      default:
        // Henüz oluşturulmamış roller için geçici placeholder
        return Scaffold(
          appBar: AppBar(
            title: const Text('Dashboard'),
            actions: [
              IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () => ref.read(authProvider.notifier).logout(),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Hoşgeldin, ${user?.fullName ?? 'Kullanıcı'}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 8),
                Text(
                  'Rol: ${user?.userType ?? 'Bilinmiyor'}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () => GoRouter.of(context).push('/questions'),
                  icon: const Icon(Icons.question_answer_outlined),
                  label: const Text('Sorularım'),
                ),
              ],
            ),
          ),
        );
    }
  }
}
