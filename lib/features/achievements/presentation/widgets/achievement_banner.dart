import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_colors.dart';

/// Top banner inside the header.
///
/// The banner owns a fixed *frame* (rounded corners, clipping and background)
/// and renders swappable *content* inside it. It expands to fill whatever space
/// its parent gives it, which lets the collapsing header shrink it smoothly
/// without the banner fighting the layout.
///
/// Today the content is a static image placeholder; when the Rive animation is
/// ready, pass a [contentBuilder] returning the `RiveAnimation` (or change the
/// default in one place). Because the screen only ever references
/// `const AchievementBanner()` and the frame is stable, swapping in Rive needs
/// no screen refactoring (per feature requirements).
class AchievementBanner extends StatelessWidget {
  const AchievementBanner({super.key, this.contentBuilder});

  /// Builds the content rendered inside the banner frame. Defaults to the
  /// static image placeholder. This is the single seam for Rive integration.
  final WidgetBuilder? contentBuilder;

  static const String _placeholderAsset =
      'assets/images/banner_placeholder.png';

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimens.radiusMd.r),
      child: SizedBox.expand(
        child: ColoredBox(
          color: AppColors.placeholder,
          child: contentBuilder?.call(context) ?? _defaultContent(),
        ),
      ),
    );
  }

  Widget _defaultContent() {
    // Static placeholder. The grey background remains visible while the asset
    // (and later a Rive scene) loads, so there's never an empty flash.
    return Image.asset(
      _placeholderAsset,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const SizedBox.expand(),
    );
  }
}
