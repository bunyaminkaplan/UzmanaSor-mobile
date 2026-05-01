import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_colors.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import 'dashboard_drawer.dart';

/// Tüm dashboard sayfalarında ortak olan Scaffold iskeleti.
///
/// Sabit "Uzmana Sor" başlığı ve üniversite logosu içeren AppBar,
/// DashboardDrawer ve opsiyonel RefreshIndicator içerir.
/// Logout işlemi Drawer footer'dan sağlanır.
///
/// Kullanım:
/// ```dart
/// DashboardScaffold(
///   onRefresh: () => ref.invalidate(deanStatsProvider),
///   body: ...,
/// )
/// ```
class DashboardScaffold extends ConsumerWidget {
  final VoidCallback onRefresh;
  final Widget body;
  final Widget? floatingActionButton;

  const DashboardScaffold({
    super.key,
    required this.onRefresh,
    required this.body,
    this.floatingActionButton,
  });

  /// Sabit AppBar — tüm sayfalar için ortak.
  AppBar _buildAppBar() {
    return AppBar(
      title: const Text('Uzmana Sor'),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/images/logo.png', height: 40),
          ),
        ),
      ],
    );
  }

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
          appBar: _buildAppBar(),
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
      appBar: _buildAppBar(),
      drawer: const DashboardDrawer(),
      floatingActionButton: floatingActionButton,
      body: RefreshIndicator(onRefresh: () async => onRefresh(), child: body),
    );
  }
}
