import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'dashboard_drawer.dart';

/// Tüm dashboard sayfalarında ortak olan Scaffold iskeleti.
///
/// AppBar (başlık + yenile/çıkış butonları), DashboardDrawer ve
/// opsiyonel RefreshIndicator içerir. Sayfalar sadece [body] verir.
///
/// Kullanım:
/// ```dart
/// DashboardScaffold(
///   title: 'Dekan Paneli',
///   onRefresh: () => ref.invalidate(deanStatsProvider),
///   onLogout: () => ref.read(authProvider.notifier).logout(),
///   body: ...,
/// )
/// ```
class DashboardScaffold extends ConsumerWidget {
  final String title;
  final VoidCallback onRefresh;
  final VoidCallback onLogout;
  final Widget body;
  final Widget? floatingActionButton;

  /// Ek AppBar action'ları (refresh/logout'un önüne eklenir).
  final List<Widget>? extraActions;

  const DashboardScaffold({
    super.key,
    required this.title,
    required this.onRefresh,
    required this.onLogout,
    required this.body,
    this.floatingActionButton,
    this.extraActions,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).value;

    if (user != null) {
      final role = user.activeDashboard;
      final reqDept = ['teacher', 'student', 'student_rep'];
      final reqFac = ['teacher', 'student', 'student_rep', 'dean'];

      List<String> missing = [];
      if (reqFac.contains(role) && user.facultyDetails == null) {
        missing.add('Fakülte');
      }
      if (reqDept.contains(role) && user.departmentDetails == null) {
        missing.add('Bölüm');
      }

      if (missing.isNotEmpty) {
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(icon: const Icon(Icons.logout), onPressed: onLogout),
            ],
          ),
          drawer: const DashboardDrawer(),
          body: Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.security_update_warning,
                    size: 80,
                    color: AppColors.accentOrange,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Eksik Profil Bilgisi',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Bu panele erişebilmeniz için profilinize ${missing.join(' ve ')} atamasının yapılmış olması gerekmektedir.\n\nLütfen sistem yöneticisi ile iletişime geçin veya soldaki menü üzerinden profilinize tıklayarak aktif role geçiş yapın.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (extraActions != null) ...extraActions!,
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: onRefresh,
            tooltip: 'Yenile',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: onLogout,
            tooltip: 'Çıkış',
          ),
        ],
      ),
      drawer: const DashboardDrawer(),
      floatingActionButton: floatingActionButton,
      body: RefreshIndicator(onRefresh: () async => onRefresh(), child: body),
    );
  }
}
