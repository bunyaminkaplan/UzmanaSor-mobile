import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_colors_ext.dart';

class InlineConfirmButton extends StatefulWidget {
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final IconData normalIcon;
  final IconData confirmIcon;
  final String normalLabel;
  final String confirmLabel;
  final Color? normalColor;
  final Color? normalTextColor;
  final Color? confirmColor;
  final Duration timeout;
  final bool showProgressIndicator;
  final double borderRadius;

  const InlineConfirmButton({
    super.key,
    required this.onConfirm,
    required this.normalIcon,
    required this.confirmIcon,
    required this.normalLabel,
    required this.confirmLabel,
    this.onCancel,
    this.normalColor,
    this.normalTextColor,
    this.confirmColor,
    this.timeout = const Duration(seconds: 3),
    this.showProgressIndicator = true,
    this.borderRadius = 12.0,
  });

  @override
  State<InlineConfirmButton> createState() => _InlineConfirmButtonState();
}

class _InlineConfirmButtonState extends State<InlineConfirmButton>
    with SingleTickerProviderStateMixin {
  bool _isConfirmMode = false;
  bool _isOverlayActive = false;

  late AnimationController _timeoutController;
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  ScrollPosition? _scrollPosition;

  @override
  void initState() {
    super.initState();
    _timeoutController = AnimationController(
      vsync: this,
      duration: widget.timeout,
    );
    _timeoutController.addStatusListener(_handleTimeoutStatus);
  }

  void _handleTimeoutStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _cancelConfirmMode();
    }
  }

  @override
  void dispose() {
    _timeoutController.dispose();
    _removeOverlay();
    _scrollPosition?.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_isConfirmMode) {
      _cancelConfirmMode();
    }
  }

  void _enterConfirmMode() {
    if (_isConfirmMode) return;

    final overlay = Overlay.maybeOf(context);
    if (overlay != null) {
      // Scroll listener
      final scrollable = Scrollable.maybeOf(context);
      if (scrollable != null) {
        _scrollPosition = scrollable.position;
        _scrollPosition?.addListener(_onScroll);
      }

      setState(() {
        _isConfirmMode = true;
        _isOverlayActive = true;
      });

      // Bir frame bekle: mevcut pointer event'in TapRegion tarafından
      // "outside" olarak algılanmasını önler.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_isConfirmMode) return;
        _showOverlay(overlay);
        _timeoutController.forward(from: 0.0);
      });
    } else {
      // Overlay yok — inline fallback
      setState(() {
        _isConfirmMode = true;
      });
      _timeoutController.forward(from: 0.0);
    }
  }

  void _cancelConfirmMode() {
    if (!_isConfirmMode && !_isOverlayActive) return;

    _timeoutController.stop();
    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = null;

    _removeOverlay();
    setState(() {
      _isConfirmMode = false;
      _isOverlayActive = false;
    });
    widget.onCancel?.call();
  }

  void _executeConfirm() {
    if (!_isConfirmMode) return;

    _timeoutController.stop();
    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = null;

    _removeOverlay();
    setState(() {
      _isConfirmMode = false;
      _isOverlayActive = false;
    });

    widget.onConfirm();
  }

  void _showOverlay(OverlayState overlay) {
    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Positioned(
          left: 0,
          top: 0,
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.center,
            followerAnchor: Alignment.center,
            child: TapRegion(
              onTapOutside: (_) => _cancelConfirmMode(),
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOutCubic,
                builder: (_, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.scale(
                      scale: 0.92 + (0.08 * value),
                      child: child,
                    ),
                  );
                },
                child: Material(
                  color: Colors.transparent,
                  elevation: 6,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  child: IntrinsicWidth(
                    child: _buildChip(isConfirming: true),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry?.dispose();
    _overlayEntry = null;
  }

  /// Butonun tek bir görsel halini oluşturur.
  Widget _buildChip({required bool isConfirming}) {
    final themeNormalColor = widget.normalColor ?? context.cardBg;
    final themeConfirmColor = widget.confirmColor ?? AppColors.error;

    final bgColor = isConfirming ? themeConfirmColor : themeNormalColor;
    final fgColor = isConfirming ? Colors.white : (widget.normalTextColor ?? context.textMuted);
    final icon = isConfirming ? widget.confirmIcon : widget.normalIcon;
    final label = isConfirming ? widget.confirmLabel : widget.normalLabel;

    return InkWell(
      onTap: () {
        if (isConfirming) {
          _executeConfirm();
        } else {
          _enterConfirmMode();
        }
      },
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: isConfirming
                ? Colors.transparent
                : Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: fgColor),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: fgColor,
                    fontSize: 13,
                    fontWeight:
                        isConfirming ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ],
            ),
            // Progress bar (eriyen alt çizgi)
            if (isConfirming && widget.showProgressIndicator)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: SizedBox(
                  height: 2,
                  child: AnimatedBuilder(
                    animation: _timeoutController,
                    builder: (_, _) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 1.0 - _timeoutController.value,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.6),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasOverlay = Overlay.maybeOf(context) != null;

    if (hasOverlay) {
      return CompositedTransformTarget(
        link: _layerLink,
        child: Opacity(
          // Ghost: overlay aktifken orijinal buton görünmez ama yer tutar
          opacity: _isOverlayActive ? 0.0 : 1.0,
          child: IgnorePointer(
            ignoring: _isOverlayActive,
            child: _buildChip(isConfirming: false),
          ),
        ),
      );
    }

    // Overlay yok — inline fallback (AnimatedSize ile genişleme kabul edilir)
    return TapRegion(
      onTapOutside: _isConfirmMode ? (_) => _cancelConfirmMode() : null,
      child: AnimatedSize(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutBack,
        alignment: Alignment.centerLeft,
        child: _buildChip(isConfirming: _isConfirmMode),
      ),
    );
  }
}
