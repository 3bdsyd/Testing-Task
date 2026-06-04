import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_curves.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../cubit/achievements_cubit.dart';

/// Segmented tab selector rendered as a white pill (matches the design).
///
/// Selection is communicated purely through an animated label color/weight
/// change — no extra indicator is added so the control stays pixel-faithful.
/// Tab order is logical ([AchievementsTab.values]); the surrounding RTL
/// directionality places "المهام" on the right with no manual mirroring.
class AchievementTabBar extends StatelessWidget {
  const AchievementTabBar({
    super.key,
    required this.selected,
    required this.onChanged,
    required this.labelFor,
    this.itemEntranceDelay,
  });

  final AchievementsTab selected;
  final ValueChanged<AchievementsTab> onChanged;
  final String Function(AchievementsTab tab) labelFor;

  /// When set, each tab reveals with a staggered fade/slide starting at this
  /// delay (used for the screen entrance). Null = no entrance animation.
  final Duration? itemEntranceDelay;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppDimens.tabBarHeight.h,
      padding: EdgeInsets.symmetric(horizontal: AppDimens.spaceXs.w),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusPill.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          for (final (index, tab) in AchievementsTab.values.indexed)
            Expanded(
              child: _maybeAnimate(
                index: index,
                child: _TabItem(
                  label: labelFor(tab),
                  isSelected: tab == selected,
                  onTap: () => onChanged(tab),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _maybeAnimate({required int index, required Widget child}) {
    final delay = itemEntranceDelay;
    if (delay == null) return child;
    return FadeSlideIn(
      delay: delay + AppDurations.stagger * index,
      duration: AppDurations.medium,
      offset: const Offset(0, 0.35),
      child: child,
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Center(
        child: AnimatedDefaultTextStyle(
          duration: AppDurations.medium,
          curve: AppCurves.emphasized,
          style: AppTextStyles.tabLabel.copyWith(
            color: isSelected ? AppColors.primaryGreen : AppColors.tabInactive,
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
