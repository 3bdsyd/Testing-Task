import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../../../core/widgets/responsive_grid.dart';
import '../../../../core/widgets/section_title.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/record_achievement.dart';
import 'record_card.dart';

/// Content of the "الارقام القياسية" (Records) tab — the user's personal
/// records followed by the system-wide top records. Returns a sliver.
class RecordsTab extends StatelessWidget {
  const RecordsTab({super.key, required this.records});

  final RecordsCollection records;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: AppDimens.screenPadding.w),
      sliver: SliverMainAxisGroup(
        slivers: [
          _adapter(
            Padding(
              padding: EdgeInsets.only(top: AppDimens.spaceLg.h),
              child: FadeSlideIn(child: SectionTitle(l10n.sectionMyRecords)),
            ),
          ),
          _gap(AppDimens.spaceLg),
          _adapter(
            ResponsiveGrid(
              itemCount: records.myRecords.length,
              baseDelay: AppDurations.short,
              itemBuilder: (context, index) =>
                  RecordCard(record: records.myRecords[index], onTap: () {}),
            ),
          ),
          _gap(AppDimens.spaceXl),
          _adapter(
            FadeSlideIn(child: SectionTitle(l10n.sectionTopRecords)),
          ),
          _gap(AppDimens.spaceLg),
          _adapter(
            ResponsiveGrid(
              itemCount: records.topRecords.length,
              baseDelay: AppDurations.short,
              itemBuilder: (context, index) =>
                  RecordCard(record: records.topRecords[index], onTap: () {}),
            ),
          ),
        ],
      ),
    );
  }

  Widget _adapter(Widget child) => SliverToBoxAdapter(child: child);

  Widget _gap(double height) =>
      SliverToBoxAdapter(child: SizedBox(height: height.h));
}
