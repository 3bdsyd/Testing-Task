import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/avatar_circle.dart';
import '../../../../core/widgets/number_badge.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/prize_achievement.dart';

/// A prize tile in the Prizes tab: a large avatar with an overlapping value
/// badge, the title, and the owned/total count ("5 من 10"). No card border —
/// the items sit directly on the background per the design.
class PrizeItem extends StatelessWidget {
  const PrizeItem({super.key, required this.prize, this.onTap});

  final PrizeAchievement prize;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PressableScale(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: AppDimens.spaceMd.h),
                child: AvatarCircle(diameter: AppDimens.prizeAvatar),
              ),
              NumberBadge(value: prize.value.toString()),
            ],
          ),
          SizedBox(height: AppDimens.spaceSm.h),
          Text(
            prize.title,
            style: AppTextStyles.cardTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppDimens.spaceXs.h),
          Text(
            l10n.prizeProgress(prize.owned, prize.total),
            style: AppTextStyles.cardSubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
