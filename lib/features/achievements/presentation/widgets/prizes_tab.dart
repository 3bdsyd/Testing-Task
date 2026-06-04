import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/responsive_grid.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/prize_achievement.dart';
import 'prize_item.dart';

/// Content of the "الجوائز" (Prizes) tab. Returns a sliver.
class PrizesTab extends StatelessWidget {
  const PrizesTab({super.key, required this.prizes});

  final List<PrizeAchievement> prizes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.screenPadding.w),
      sliver: SliverMainAxisGroup(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(top: AppDimens.spaceLg.h),
              child: FadeSlideIn(child: SectionTitle(l10n.sectionMyPrizes)),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: AppDimens.spaceXl.h)),
          SliverToBoxAdapter(
            child: ResponsiveGrid(
              itemCount: prizes.length,
              mainAxisSpacing: AppDimens.spaceXl,
              baseDelay: AppDurations.short,
              itemBuilder: (context, index) =>
                  PrizeItem(prize: prizes[index], onTap: () {}),
            ),
          ),
        ],
      ),
    );
  }
}
