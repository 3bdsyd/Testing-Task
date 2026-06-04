import 'package:flutter/material.dart';

import '../constants/app_curves.dart';
import '../constants/app_durations.dart';

/// Reusable press-feedback wrapper: scales its child down slightly while
/// pressed and springs back on release. Used for every tappable card and
/// button so interaction feedback stays consistent (CLAUDE.md §9).
///
/// When [onTap] is null the child is rendered as-is (no gesture handling, no
/// scaling) so it can wrap non-interactive content safely.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.97,
    this.duration = AppDurations.fast,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration duration;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.onTap == null) return widget.child;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? widget.pressedScale : 1,
        duration: widget.duration,
        curve: AppCurves.press,
        child: widget.child,
      ),
    );
  }
}
