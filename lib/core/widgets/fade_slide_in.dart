import 'package:flutter/material.dart';

import '../constants/app_curves.dart';
import '../constants/app_durations.dart';

/// Reusable entrance animation wrapper: fades the child in while sliding it a
/// short distance into place. Used to compose header / banner / staggered tab
/// and content reveals without each screen re-implementing the motion.
///
/// Honors [MediaQuery.disableAnimations] for accessibility (CLAUDE.md §8): when
/// disabled the child appears immediately at its final position.
class FadeSlideIn extends StatefulWidget {
  const FadeSlideIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = AppDurations.long,
    this.curve = AppCurves.standard,
    this.offset = const Offset(0, 0.12),
    this.animate = true,
  });

  final Widget child;

  /// Delay before the animation starts — drive staggering by passing
  /// increasing delays to sibling widgets.
  final Duration delay;
  final Duration duration;
  final Curve curve;

  /// Start offset as a fraction of the child's size (slides toward `Offset.zero`).
  final Offset offset;

  /// When false the child is shown immediately (used to replay/reset lists).
  final bool animate;

  @override
  State<FadeSlideIn> createState() => _FadeSlideInState();
}

class _FadeSlideInState extends State<FadeSlideIn>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: widget.duration,
  );

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    if (!widget.animate) {
      _controller.value = 1;
      return;
    }
    if (widget.delay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.delay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Accessibility: skip motion when the platform requests reduced animations.
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) {
      return widget.child;
    }

    final curved = CurvedAnimation(parent: _controller, curve: widget.curve);
    return FadeTransition(
      opacity: curved,
      child: AnimatedBuilder(
        animation: curved,
        builder: (context, child) {
          final dy = widget.offset.dy * (1 - curved.value);
          final dx = widget.offset.dx * (1 - curved.value);
          return FractionalTranslation(
            translation: Offset(dx, dy),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}
