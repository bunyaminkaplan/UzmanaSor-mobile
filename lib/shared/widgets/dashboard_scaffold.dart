import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/constants/user_roles.dart';
import 'package:mobile/shared/widgets/return_to_top_fab.dart';
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
  final List<Widget>? fabs;

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
    this.fabs,
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
  bool _showReturnToTop = false;

  /// NestedScrollView'ın outer (header slivers) scroll'unu izler.
  /// Inner scroll (body) bu controller'ı etkilemez.
  late final ScrollController _outerScrollController;
  final ValueNotifier<int> _returnToTopSignal = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _outerScrollController = ScrollController()..addListener(_onOuterScroll);
  }

  @override
  void dispose() {
    _returnToTopSignal.dispose();
    _outerScrollController.dispose();
    super.dispose();
  }

  /// Outer scroll offset'i threshold'u geçtiğinde title takeover tetiklenir.
  void _onOuterScroll() {
    if (widget.pageTitle == null || widget.header == null) return;
    final offset = _outerScrollController.offset;
    final shouldShow = offset > DashboardScaffold._kHeaderThreshold;
    if (shouldShow != _showPageTitle) {
      setState(() => _showPageTitle = shouldShow);
    }
  }

  void _returnToTop() {
    if (widget.header != null && _outerScrollController.hasClients) {
      _outerScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
    _returnToTopSignal.value++;
  }

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
                final isEntering =
                    child.key == ValueKey<bool>(_showPageTitle);

                final double dy = _showPageTitle
                    ? (isEntering ? 0.5 : -0.5)
                    : (isEntering ? -0.5 : 0.5);

                final slideOffset = Tween<Offset>(
                  begin: Offset(0, dy),
                  end: Offset.zero,
                ).animate(CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOut,
                ));

                return SlideTransition(
                  position: slideOffset,
                  child: FadeTransition(
                    opacity: animation,
                    child: AnimatedBuilder(
                      animation: animation,
                      builder: (context, wrappedChild) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.accentCyan.withValues(
                            alpha: 0.2 * (1.0 - animation.value),
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: wrappedChild,
                      ),
                      child: child,
                    ),
                  ),
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
          padding: const EdgeInsets.only(right: 8.0, bottom: 4.0),
          child: Container(
            padding: const EdgeInsets.all(1),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Image.asset('assets/images/logo.png', height: 36),
          ),
        ),
      ],
    );
  }

  /// Header varsa NestedScrollView, yoksa mevcut RefreshIndicator yapısı.
  Widget _buildBody() {
    Widget content;

    if (widget.header != null) {
      content = NestedScrollView(
        controller: _outerScrollController,
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverToBoxAdapter(child: widget.header!),
        ],
        body: RefreshIndicator(
          onRefresh: () async => widget.onRefresh(),
          child: _ReturnToTopListener(
            signal: _returnToTopSignal,
            child: widget.body,
          ),
        ),
      );
    } else {
      content = RefreshIndicator(
        onRefresh: () async => widget.onRefresh(),
        child: _ReturnToTopListener(
          signal: _returnToTopSignal,
          child: widget.body,
        ),
      );
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification.metrics.axis != Axis.vertical) return false;
        final shouldShow = notification.metrics.pixels > ReturnToTopFab.kReturnToTopThreshold;
        if (shouldShow != _showReturnToTop) {
          setState(() => _showReturnToTop = shouldShow);
        }
        return false;
      },
      child: content,
    );
  }

  Widget? _buildFabColumn() {
    final allFabs = <Widget>[];

    // Return-to-top her zaman listeye ekleniyor (kendi içinde AnimatedSlide ile çıkıyor)
    allFabs.add(
      ReturnToTopFab(
        visible: _showReturnToTop,
        onPressed: _returnToTop,
      ),
    );

    if (widget.fabs != null) {
      allFabs.addAll(widget.fabs!);
    }


    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (final fab in allFabs)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: fab,
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).value;

    if (user != null) {
      final role = user.activeDashboard;
      final reqDept = [UserRoles.teacher, UserRoles.student, UserRoles.studentRep];
      final reqFac = [
        UserRoles.teacher,
        UserRoles.student,
        UserRoles.studentRep,
        UserRoles.dean,
      ];

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
      floatingActionButton: _buildFabColumn(),
      body: _buildBody(),
    );
  }
}

/// DashboardScaffold'dan gelen "başa dön" sinyalini yakalar
/// ve body subtree'deki PrimaryScrollController'ı sıfırlar.
class _ReturnToTopListener extends StatefulWidget {
  final ValueNotifier<int> signal;
  final Widget child;

  const _ReturnToTopListener({
    required this.signal,
    required this.child,
  });

  @override
  State<_ReturnToTopListener> createState() => _ReturnToTopListenerState();
}

class _ReturnToTopListenerState extends State<_ReturnToTopListener> {
  @override
  void initState() {
    super.initState();
    widget.signal.addListener(_onSignal);
  }

  @override
  void dispose() {
    widget.signal.removeListener(_onSignal);
    super.dispose();
  }

  void _onSignal() {
    final controller = PrimaryScrollController.of(context);
    if (controller.hasClients) {
      controller.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
