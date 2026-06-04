import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../domain/entities/task_achievement.dart';
import 'task_card.dart';

/// Content of the "المهام" (Tasks) tab.
///
/// Returns a **sliver** so it scrolls inside the shared collapsing-header
/// [CustomScrollView]. The list is lazy, so each card (and its progress bar)
/// only builds — and therefore animates — when it scrolls into view.
class TasksTab extends StatelessWidget {
  const TasksTab({super.key, required this.tasks});

  final List<TaskAchievement> tasks;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimens.screenPadding.w,
        vertical: AppDimens.spaceSm.h,
      ),
      sliver: SliverList.separated(
        itemCount: tasks.length,
        separatorBuilder: (_, _) => Divider(
          height: 1.h,
          thickness: 1.h,
          color: AppColors.track,
        ),
        itemBuilder: (context, index) {
          return FadeSlideIn(
            delay: AppDurations.stagger * index.clamp(0, 8),
            duration: AppDurations.medium,
            child: TaskCard(task: tasks[index], onTap: () {}),
          );
        },
      ),
    );
  }
}
