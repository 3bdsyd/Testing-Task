import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/app_dimens.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// White rounded badge displaying a record value (e.g. "523"), with a soft
/// shadow. Designed to overlap the bottom of an [AvatarCircle].
class NumberBadge extends StatelessWidget {
  const NumberBadge({super.key, required this.value});

  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.spaceLg.w,
        vertical: AppDimens.spaceXs.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppDimens.radiusSm.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Text(value, style: AppTextStyles.badgeNumber),
    );
  }
}
