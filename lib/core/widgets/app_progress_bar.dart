import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_curves.dart';
import '../constants/app_durations.dart';
import '../constants/app_dimens.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Pill progress bar with a centered label. Direction-aware: the fill grows
/// from the start edge (right in RTL) thanks to [AlignmentDirectional], so no
/// manual RTL handling is needed at call sites.
///
/// Motion (CLAUDE.md §8):
/// * On first appearance the fill animates from 0 to [value]. Because callers
///   place these inside lazy slivers, "first appearance" is effectively "first
///   becomes visible" — off-screen bars don't animate until scrolled into view.
/// * It does **not** replay on rebuilds; it only re-animates when [value] itself
///   changes (e.g. fresh API data), tweening from the currently shown fraction.
/// * Honors [MediaQuery.disableAnimations] by jumping straight to [value].
class AppProgressBar extends StatefulWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    required this.label,
    this.height = AppDimens.progressBarHeight,
    this.startDelay = Duration.zero,
  }) : assert(value >= 0 && value <= 1);

  /// Progress fraction in the range 0..1.
  final double value;
  final String label;
  final double height;

  /// Delay before the entrance fill starts, so it can begin just after the
  /// card's own entrance animation.
  final Duration startDelay;

  @override
  State<AppProgressBar> createState() => _AppProgressBarState();
}

class _AppProgressBarState extends State<AppProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: AppDurations.long,
  );
  late Animation<double> _fill = _buildFill(0, widget.value);
  bool _started = false;

  Animation<double> _buildFill(double from, double to) {
    return Tween<double>(begin: from, end: to).animate(
      CurvedAnimation(parent: _controller, curve: AppCurves.emphasized),
    );
  }

  bool get _reduceMotion =>
      MediaQuery.maybeOf(context)?.disableAnimations ?? false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;

    if (_reduceMotion) {
      _controller.value = 1;
      return;
    }
    if (widget.startDelay == Duration.zero) {
      _controller.forward();
    } else {
      Future<void>.delayed(widget.startDelay, () {
        if (mounted) _controller.forward();
      });
    }
  }

  @override
  void didUpdateWidget(AppProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only re-animate when the target actually changes — never on plain rebuilds.
    if (oldWidget.value != widget.value) {
      _fill = _buildFill(_fill.value, widget.value);
      if (_reduceMotion) {
        _controller.value = 1;
      } else {
        _controller
          ..reset()
          ..forward();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final barHeight = widget.height.h;
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusPill.r),
      child: SizedBox(
        height: barHeight,
        child: Stack(
          children: [
            const Positioned.fill(child: ColoredBox(color: AppColors.track)),
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _fill,
                builder: (context, _) {
                  // Anchor the fill to the start edge (right in RTL) directly on
                  // the FractionallySizedBox — it fills the track, so wrapping it
                  // in an Align would just centre the fraction instead.
                  return FractionallySizedBox(
                    alignment: AlignmentDirectional.centerStart,
                    widthFactor: _fill.value.clamp(0.0, 1.0),
                    child: const ColoredBox(color: AppColors.progressFill),
                  );
                },
              ),
            ),
            Center(child: Text(widget.label, style: AppTextStyles.onAccent)),
          ],
        ),
      ),
    );
  }
}
