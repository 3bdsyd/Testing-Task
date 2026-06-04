import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/app_progress_bar.dart';
import '../../../../core/widgets/avatar_circle.dart';
import '../../../../core/widgets/pressable_scale.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/task_achievement.dart';

/// A single mission row in the Tasks tab. In-progress tasks show a progress
/// bar; claimable tasks show the green claim button instead.
///
/// Layout is direction-agnostic (logical Row/Column alignment), so RTL is
/// handled by the ambient [Directionality] with no manual mirroring.
class TaskCard extends StatelessWidget {
  const TaskCard({
    super.key,
    required this.task,
    this.onTap,
    this.onClaim,
  });

  final TaskAchievement task;
  final VoidCallback? onTap;
  final VoidCallback? onClaim;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return PressableScale(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: AppDimens.spaceMd.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AvatarCircle(diameter: AppDimens.taskAvatar),
            SizedBox(width: AppDimens.spaceMd.w),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(task.title, style: AppTextStyles.cardTitle),
                  if (task.status == TaskStatus.claimable) ...[
                    SizedBox(height: AppDimens.spaceSm.h),
                    _ClaimButton(label: l10n.claim, onTap: onClaim),
                  ] else ...[
                    SizedBox(height: AppDimens.spaceXs.h),
                    Text(task.description, style: AppTextStyles.cardSubtitle),
                    SizedBox(height: AppDimens.spaceSm.h),
                    _ProgressRow(
                      value: task.progress,
                      label: l10n.taskProgress(task.current, task.target),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({required this.value, required this.label});

  final double value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: AppProgressBar(
            value: value,
            label: label,
            startDelay: AppDurations.short,
          ),
        ),
        SizedBox(width: AppDimens.spaceSm.w),
        Container(
          width: AppDimens.spaceXxl.w,
          height: AppDimens.spaceXxl.w,
          decoration: BoxDecoration(
            color: AppColors.placeholder,
            borderRadius: BorderRadius.circular(AppDimens.radiusSm.r),
          ),
        ),
      ],
    );
  }
}

class _ClaimButton extends StatelessWidget {
  const _ClaimButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PressableScale(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: AppDimens.claimButtonHeight.h,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(AppDimens.radiusSm.r),
        ),
        child: Text(label, style: AppTextStyles.button),
      ),
    );
  }
}
