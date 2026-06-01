import 'dart:async';
import 'package:flutter/material.dart';

class TopSnackBar extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onTap;
  final VoidCallback? onDismissed;

  const TopSnackBar({
    super.key,
    required this.child,
    this.duration = const Duration(seconds: 4),
    this.onTap,
    this.onDismissed,
  });

  static void show(
    BuildContext context, {
    required Widget child,
    Duration duration = const Duration(seconds: 4),
    VoidCallback? onTap,
  }) {
    final overlayState = Navigator.of(context).overlay;
    if (overlayState == null) return;

    late OverlayEntry overlayEntry;
    overlayEntry = OverlayEntry(
      builder: (context) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: TopSnackBar(
              duration: duration,
              onTap: onTap,
              onDismissed: () {
                if (overlayEntry.mounted) {
                  overlayEntry.remove();
                }
              },
              child: child,
            ),
          ),
        );
      },
    );

    overlayState.insert(overlayEntry);
  }

  @override
  State<TopSnackBar> createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<TopSnackBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _offsetAnimation;
  late final Animation<double> _fadeAnimation;
  Timer? _dismissTimer;
  bool _isDismissed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    _dismissTimer = Timer(widget.duration, _dismiss);
  }

  void _dismiss() {
    if (_isDismissed || !mounted) return;
    _isDismissed = true;
    _dismissTimer?.cancel();
    _controller.reverse().then((_) {
      widget.onDismissed?.call();
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Padding(
          padding: const EdgeInsets.only(top: 50.0, left: 16.0, right: 16.0),
          child: GestureDetector(
            onTap: () {
              if (widget.onTap != null) {
                widget.onTap!();
              }
              _dismiss();
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
