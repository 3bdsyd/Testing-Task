import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/achievements_cubit.dart';
import 'achievement_banner.dart';
import 'achievement_tab_bar.dart';

/// Collapsing orange header, implemented as a [SliverAppBar].
///
/// * Expanded: large orange area with the title and the banner.
/// * Collapsed (on scroll up): the title/banner area shrinks away smoothly and
///   the tab bar — hosted in the app bar's pinned `bottom` — stays at the top so
///   the user can switch tabs from anywhere without scrolling back up.
/// * A drop shadow appears once content scrolls under (`scrolledUnderElevation`).
///
/// Orchestrates the screen-entrance choreography (CLAUDE.md §8): the title
/// enters first, then the banner, then the tabs stagger in. Entrance state
/// lives in the [FadeSlideIn]s, so it plays once and is not replayed by the
/// rebuilds that scrolling/state changes trigger.
class AchievementsSliverHeader extends StatelessWidget {
  const AchievementsSliverHeader({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  final AchievementsTab selectedTab;
  final ValueChanged<AchievementsTab> onTabChanged;

  String _labelFor(AppLocalizations l10n, AchievementsTab tab) {
    return switch (tab) {
      AchievementsTab.tasks => l10n.tabTasks,
      AchievementsTab.records => l10n.tabRecords,
      AchievementsTab.prizes => l10n.tabPrizes,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    // Height of the title + banner block that sits *above* the tab bar (the
    // part that collapses away).
    final aboveTabsHeight = (AppDimens.spaceMd +
            AppDimens.headerTitleHeight +
            AppDimens.spaceLg +
            AppDimens.bannerHeight)
        .h;
    // Height of the pinned tab bar block (stays visible when collapsed).
    final bottomHeight = AppDimens.tabBarHeight.h + AppDimens.spaceMd.h * 2;

    return SliverAppBar(
      pinned: true,
      primary: true,
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.primaryOrange,
      surfaceTintColor: Colors.transparent,
      shadowColor: AppColors.shadow,
      systemOverlayStyle: SystemUiOverlayStyle.light,
      elevation: 0,
      scrolledUnderElevation: 6,
      toolbarHeight: 0,
      collapsedHeight: bottomHeight,
      expandedHeight: aboveTabsHeight + bottomHeight,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: SafeArea(
          bottom: false,
          child: Padding(
            // The flexibleSpace fills the *entire* bar (the pinned tab bar is
            // painted over its bottom). Reserve `bottomHeight` at the bottom so
            // the banner ends above the tab bar instead of behind it.
            padding: EdgeInsets.only(
              left: AppDimens.screenPadding.w,
              right: AppDimens.screenPadding.w,
              top: AppDimens.spaceMd.h,
              bottom: bottomHeight,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FadeSlideIn(
                  duration: AppDurations.long,
                  offset: const Offset(0, -0.4),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child:
                        Text(l10n.appTitle, style: AppTextStyles.headerTitle),
                  ),
                ),
                SizedBox(height: AppDimens.spaceLg.h),
                Expanded(
                  child: FadeSlideIn(
                    delay: AppDurations.short,
                    duration: AppDurations.long,
                    offset: const Offset(0, 0.08),
                    child: const AchievementBanner(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(bottomHeight),
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            AppDimens.screenPadding.w,
            AppDimens.spaceMd.h,
            AppDimens.screenPadding.w,
            AppDimens.spaceMd.h,
          ),
          child: AchievementTabBar(
            selected: selectedTab,
            onChanged: onTabChanged,
            labelFor: (tab) => _labelFor(l10n, tab),
            itemEntranceDelay: AppDurations.medium,
          ),
        ),
      ),
    );
  }
}
