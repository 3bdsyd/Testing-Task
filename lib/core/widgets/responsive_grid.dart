import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_dimens.dart';
import '../constants/app_durations.dart';
import 'fade_slide_in.dart';

/// Reusable non-scrolling grid that lays items out in [crossAxisCount] columns
/// and reveals them with a staggered fade/slide entrance. Meant to be embedded
/// inside a scrollable (e.g. the tab's `SingleChildScrollView`).
///
/// Rather than a fixed `childAspectRatio` (which forces every cell to one height
/// and overflows when content is a few pixels taller on a given device/locale),
/// each column gets a computed width and items size to their **intrinsic
/// height** via a [Wrap]. Rows grow to fit content, so cards never overflow —
/// regardless of text scale, device or future content. Horizontal placement
/// follows the ambient text direction (right-to-left first in RTL).
///
/// New achievement categories only need to supply an item builder
/// (CLAUDE.md §2 — shared code).
class ResponsiveGrid extends StatelessWidget {
  const ResponsiveGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.crossAxisCount = 3,
    this.mainAxisSpacing = AppDimens.spaceLg,
    this.crossAxisSpacing = AppDimens.spaceLg,
    this.baseDelay = Duration.zero,
    this.animate = true,
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;

  /// Delay applied before the first item animates (lets a section start after
  /// the one above it).
  final Duration baseDelay;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final spacing = crossAxisSpacing.w;
    final runSpacing = mainAxisSpacing.h;

    return LayoutBuilder(
      builder: (context, constraints) {
        final totalSpacing = spacing * (crossAxisCount - 1);
        final itemWidth =
            (constraints.maxWidth - totalSpacing) / crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: [
            for (var index = 0; index < itemCount; index++)
              SizedBox(
                width: itemWidth,
                child: FadeSlideIn(
                  animate: animate,
                  // Cap the stagger so large grids don't wait too long.
                  delay: baseDelay + AppDurations.stagger * index.clamp(0, 8),
                  duration: AppDurations.medium,
                  child: itemBuilder(context, index),
                ),
              ),
          ],
        );
      },
    );
  }
}
