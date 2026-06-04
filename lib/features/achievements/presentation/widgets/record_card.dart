import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/avatar_circle.dart';
import '../../../../core/widgets/number_badge.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../domain/entities/record_achievement.dart';

/// A record tile used in both Records grids: a green-bordered card holding an
/// avatar with an overlapping value badge, a title and a date. When the record
/// belongs to another student (system top records) their name is shown,
/// bold, beneath the card.
class RecordCard extends StatelessWidget {
  const RecordCard({super.key, required this.record, this.onTap});

  final RecordAchievement record;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _card(),
          if (record.studentName != null) ...[
            SizedBox(height: AppDimens.spaceSm.h),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: Text(record.studentName!, style: AppTextStyles.studentName),
            ),
          ],
        ],
      ),
    );
  }

  Widget _card() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceMd.w,
        vertical: AppDimens.spaceMd.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusLg.r),
        border: Border.all(color: AppColors.primaryGreen, width: 1.4.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          _avatarWithBadge(),
          SizedBox(height: AppDimens.spaceSm.h),
          Text(
            record.title,
            style: AppTextStyles.cardTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: AppDimens.spaceXs.h),
          Text(
            record.date,
            style: AppTextStyles.cardSubtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _avatarWithBadge() {
    return Stack(
      alignment: Alignment.bottomCenter,
      clipBehavior: Clip.none,
      children: [
        // Reserve room at the bottom so the badge overlaps the avatar without
        // overflowing the card.
        Padding(
          padding: EdgeInsets.only(bottom: AppDimens.spaceMd.h),
          child: AvatarCircle(diameter: AppDimens.recordAvatar),
        ),
        NumberBadge(value: record.value.toString()),
      ],
    );
  }
}
