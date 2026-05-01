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
/// [header] verildiğinde NestedScrollView ile scroll edilebilir header
/// oluşturulur. Header ekrandan çıktığında AppBar başlığı [pageTitle]
/// değerine slide-up animasyonuyla dönüşür.
///
/// Kullanım:
/// ```dart
/// DashboardScaffold(
///   pageTitle: 'Öğretmen Paneli',
///   header: DashboardPageHeader(title: 'Öğretmen Paneli', ...),
///   onRefresh: () => ref.invalidate(deanStatsProvider),
///   body: ...,
/// )
/// ```
class DashboardScaffold extends ConsumerStatefulWidget {
  final VoidCallback onRefresh;
  final Widget body;
  final Widget? floatingActionButton;

  /// Scroll edilebilir sayfa başlığı widget'ı (genellikle DashboardPageHeader).
  /// Verildiğinde NestedScrollView ile body'nin üstüne yerleştirilir.
  final Widget? header;

  /// AppBar'da gösterilecek sayfa başlığı.
  /// Header ekrandan çıktığında "Uzmana Sor" yerine bu metin görünür.
  final String? pageTitle;

  const DashboardScaffold({
    super.key,
    required this.onRefresh,
    required this.body,
    this.floatingActionButton,
    this.header,
    this.pageTitle,
  });

  /// Header scroll threshold — bu piksel değerinden sonra title takeover
  /// tetiklenir. Header'ın margin + padding + text yüksekliğine denk gelir.
  static const double _kHeaderThreshold = 120.0;

  @override
  ConsumerState<DashboardScaffold> createState() => _DashboardScaffoldState();
}

class _DashboardScaffoldState extends ConsumerState<DashboardScaffold> {
  /// true olduğunda AppBar'da pageTitle gösterilir (header ekrandan çıkmış).
  bool _showPageTitle = false;

  /// Sabit AppBar — tüm sayfalar için ortak.
  /// [pageTitle] ve [header] verilmişse, scroll durumuna göre başlık animasyonu
  /// uygular.
  AppBar _buildAppBar() {
    final hasTitle = widget.pageTitle != null && widget.header != null;

    return AppBar(
      title: hasTitle
          ? AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (child, animation) {
                final offset = Tween<Offset>(
                  begin: const Offset(0, 0.5),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ));
                return SlideTransition(
                  position: offset,
                  child: FadeTransition(opacity: animation, child: child),
                );
              },
              child: Text(
                _showPageTitle ? widget.pageTitle! : 'Uzmana Sor',
                key: ValueKey<bool>(_showPageTitle),
              ),
            )
          : const Text('Uzmana Sor'),
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

  /// Scroll bildirimlerini dinler ve header'ın ekrandan çıkıp çıkmadığını
  /// belirler.
  bool _onScrollNotification(ScrollNotification notification) {
    if (widget.pageTitle == null || widget.header == null) return false;

    final shouldShow =
        notification.metrics.pixels > DashboardScaffold._kHeaderThreshold;
    if (shouldShow != _showPageTitle) {
      setState(() => _showPageTitle = shouldShow);
    }
    return false;
  }

  /// Header varsa NestedScrollView, yoksa mevcut RefreshIndicator yapısı.
  Widget _buildBody() {
    if (widget.header != null) {
      return NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverToBoxAdapter(child: widget.header!),
          ],
          body: RefreshIndicator(
            onRefresh: () async => widget.onRefresh(),
            child: widget.body,
          ),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => widget.onRefresh(),
      child: widget.body,
    );
  }

  @override
  Widget build(BuildContext context) {
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
      floatingActionButton: widget.floatingActionButton,
      body: _buildBody(),
    );
  }
}
