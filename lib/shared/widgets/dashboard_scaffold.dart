import 'package:flutter/material.dart';
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
class DashboardScaffold extends StatelessWidget {
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
  Widget build(BuildContext context) {
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
