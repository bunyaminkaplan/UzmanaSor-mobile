import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:mobile/features/auth/domain/entities/user_entity.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/pages/auth_page.dart';
import 'package:mobile/features/auth/presentation/pages/verify_page.dart';
import 'package:mobile/features/questions/presentation/pages/ask_question_page.dart';
import 'package:mobile/features/questions/presentation/pages/question_detail_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/rep_dashboard_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/student_dashboard_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/teacher_dashboard_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/dean_dashboard_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/rector_dashboard_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/school_admin_dashboard_page.dart';

import 'package:mobile/features/manage_approvals/presentation/pages/manage_approvals_page.dart';
import 'package:mobile/features/manage_terms/presentation/pages/manage_terms_page.dart';
import 'package:mobile/features/manage_heads/presentation/pages/manage_heads_page.dart';
import 'package:mobile/features/manage_advisors/presentation/pages/manage_advisors_page.dart';
import 'package:mobile/features/manage_courses/presentation/pages/manage_courses_page.dart';
import 'package:mobile/features/manage_courses/presentation/pages/admin_manage_courses_page.dart';
import 'package:mobile/features/manage_class_rep/presentation/pages/manage_class_rep_page.dart';
import 'package:mobile/features/content_moderation/presentation/pages/content_moderation_page.dart';
import 'package:mobile/features/public_feed/presentation/pages/public_feed_page.dart';
import 'package:mobile/features/profile/presentation/pages/profile_page.dart';
import 'package:mobile/features/splash/presentation/pages/splash_page.dart';

// ---------------------------------------------------------------------------
// GoRouter — Uygulama navigasyonu.
//
// Route yapısı:
//   /splash      → SplashPage (Native splash bitimi, 2sn bekler)
//   /login       → AuthPage (Login + Register tab)
//   /verify      → VerifyPage (E-posta doğrulama)
//   /dashboard   → Rol bazlı dashboard
//   /profile     → Kullanıcı Profil sayfası
//
// redirect mantığı:
//   1. Loading → null (bekle)
//   2. /splash → null (splash'ten otomatik login yönlendirmesi engellenir, manuel yapılır)
//   3. Unauthenticated → /login
//   4. Authenticated + login sayfasında → /dashboard
// ---------------------------------------------------------------------------

final goRouterProvider = Provider<GoRouter>((ref) {
  // [YUKARIDAKI ICERIK AYNI]
  // Asagiya inip routes listesini duzenliyoruz (LINTER HATASINI ENGELLEMEK ICIN ORAYA AYRI REPLACE YAPTIRIYORUM ALTA)

  return GoRouter(
    initialLocation: '/splash',
    debugLogDiagnostics: false,
    refreshListenable: AuthListenable(ref),
    redirect: (context, state) {
      final currentPath = state.matchedLocation;

      // SADECE /splash rotasındaysak redirect yapma!
      // Çünkü SplashPage kendi animasyonunu bitirince (2 saniye bekleme süresinden sonra)
      // manuel olarak context.go('/dashboard' veya '/login') tetikleyecektir.
      if (currentPath == '/splash') {
        return null;
      }

      final authState = ref.read(authProvider);

      // Loading iken yönlendirme yapma
      if (authState.isLoading) return null;

      final user = authState.value;
      final isLoggedIn = user != null;

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
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(path: '/login', builder: (context, state) => const AuthPage()),
      GoRoute(path: '/verify', builder: (context, state) => const VerifyPage()),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const _RoleDashboardBuilder(),
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
      GoRoute(
        path: '/manage-approvals',
        builder: (context, state) => const ManageApprovalsPage(),
      ),
      GoRoute(
        path: '/manage-terms',
        builder: (context, state) => const ManageTermsPage(),
      ),
      GoRoute(
        path: '/manage-heads',
        builder: (context, state) => const ManageHeadsPage(),
      ),
      GoRoute(
        path: '/manage-advisors',
        builder: (context, state) => const ManageAdvisorsPage(),
      ),
      GoRoute(
        path: '/manage-courses',
        builder: (context, state) => const ManageCoursesPage(),
      ),
      GoRoute(
        path: '/admin-courses',
        builder: (context, state) => const AdminManageCoursesPage(),
      ),
      GoRoute(
        path: '/manage-class-rep',
        builder: (context, state) => const ManageClassRepPage(),
      ),
      GoRoute(
        path: '/content-moderation',
        builder: (context, state) => const ContentModerationPage(),
      ),
      GoRoute(
        path: '/active-feed',
        builder: (context, state) => const PublicFeedPage(),
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
      case 'rector':
        return const RectorDashboardPage();
      case 'school_admin':
        return const SchoolAdminDashboardPage();
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
