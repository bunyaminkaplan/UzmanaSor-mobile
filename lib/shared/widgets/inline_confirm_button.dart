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
    this.confirmColor,
    this.timeout = const Duration(seconds: 3),
    this.showProgressIndicator = true,
    this.borderRadius = 12.0,
  });

  @override
  State<InlineConfirmButton> createState() => _InlineConfirmButtonState();
}

class _InlineConfirmButtonState extends State<InlineConfirmButton> with SingleTickerProviderStateMixin {
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
      setState(() {
        _isOverlayActive = true;
      });
      
      final scrollable = Scrollable.maybeOf(context);
      if (scrollable != null) {
        _scrollPosition = scrollable.position;
        _scrollPosition?.addListener(_onScroll);
      }
      
      _showOverlay(overlay);
      
      // Gecikmeli olarak confirm moda geç ki AnimatedSize overlay içinde tetiklensin
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        setState(() {
          _isConfirmMode = true;
        });
        _overlayEntry?.markNeedsBuild();
        _timeoutController.forward(from: 0.0);
      });
    } else {
      setState(() {
        _isConfirmMode = true;
      });
      _timeoutController.forward(from: 0.0);
    }
  }

  void _cancelConfirmMode() {
    if (!_isConfirmMode) return;
    
    _timeoutController.stop();
    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = null;
    
    if (_isOverlayActive) {
      setState(() {
        _isConfirmMode = false;
      });
      _overlayEntry?.markNeedsBuild();
      widget.onCancel?.call();
      
      // Animasyonun bitmesini bekle ve overlay'i kaldır
      Future.delayed(const Duration(milliseconds: 250), () {
        if (mounted && !_isConfirmMode) {
          setState(() {
            _isOverlayActive = false;
          });
          _removeOverlay();
        }
      });
    } else {
      setState(() {
        _isConfirmMode = false;
      });
      widget.onCancel?.call();
    }
  }

  void _executeConfirm() {
    if (!_isConfirmMode) return;

    _timeoutController.stop();
    _scrollPosition?.removeListener(_onScroll);
    _scrollPosition = null;
    
    if (_isOverlayActive) {
      setState(() {
        _isConfirmMode = false;
        _isOverlayActive = false;
      });
      _removeOverlay();
    } else {
      setState(() {
        _isConfirmMode = false;
      });
    }
    
    widget.onConfirm();
  }

  void _showOverlay(OverlayState overlay) {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned(
          child: CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            targetAnchor: Alignment.topLeft,
            followerAnchor: Alignment.topLeft,
            child: TapRegion(
              onTapOutside: (_) => _cancelConfirmMode(),
              child: Material(
                color: Colors.transparent,
                child: _buildButtonContent(),
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
    _overlayEntry = null;
  }

  Widget _buildButtonContent({bool forceNormalState = false}) {
    final themeNormalColor = widget.normalColor ?? context.cardBg;
    final themeConfirmColor = widget.confirmColor ?? AppColors.error;
    
    final isConfirming = forceNormalState ? false : _isConfirmMode;
    
    final bgColor = isConfirming ? themeConfirmColor : themeNormalColor;
    final fgColor = isConfirming ? Colors.white : context.textMuted;
    final icon = isConfirming ? widget.confirmIcon : widget.normalIcon;
    final label = isConfirming ? widget.confirmLabel : widget.normalLabel;

    return AnimatedSize(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
      alignment: Alignment.centerLeft,
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                if (!_isConfirmMode) {
                  _enterConfirmMode();
                } else {
                  _executeConfirm();
                }
              },
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(widget.borderRadius),
                  border: Border.all(
                    color: isConfirming ? Colors.transparent : context.theme.dividerColor.withOpacity(0.1),
                  ),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(icon, size: 18, color: fgColor),
                    const SizedBox(width: 8),
                    Text(
                      label,
                      style: TextStyle(
                        color: fgColor,
                        fontWeight: isConfirming ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (isConfirming && widget.showProgressIndicator)
            Positioned(
              left: 12,
              right: 12,
              bottom: 4,
              child: AnimatedBuilder(
                animation: _timeoutController,
                builder: (context, child) {
                  return FractionallySizedBox(
                    alignment: Alignment.centerLeft, // Sağdan sola erisin
                    widthFactor: 1.0 - _timeoutController.value,
                    child: Container(
                      height: 2,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if we are allowed to use overlay (Overlay must exist)
    final hasOverlay = Overlay.maybeOf(context) != null;

    if (hasOverlay) {
      return CompositedTransformTarget(
        link: _layerLink,
        child: IgnorePointer(
          ignoring: _isOverlayActive,
          child: Opacity(
            opacity: _isOverlayActive ? 0.0 : 1.0,
            child: _buildButtonContent(forceNormalState: _isOverlayActive),
          ),
        ),
      );
    }

    // Inline fallback
    return TapRegion(
      onTapOutside: _isConfirmMode ? (_) => _cancelConfirmMode() : null,
      child: _buildButtonContent(),
    );
  }
}
