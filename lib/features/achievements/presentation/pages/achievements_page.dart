import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/app_curves.dart';
import '../../../../core/constants/app_dimens.dart';
import '../../../../core/constants/app_durations.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../cubit/achievements_cubit.dart';
import '../widgets/achievements_header.dart';
import '../widgets/prizes_tab.dart';
import '../widgets/records_tab.dart';
import '../widgets/tasks_tab.dart';

/// Entry point for the Achievements feature. Owns the [AchievementsCubit] and
/// composes a single sliver scroll view: a collapsing header pinned above the
/// active tab's content.
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AchievementsCubit>(
      create: (_) => getIt<AchievementsCubit>()..load(),
      child: const _AchievementsView(),
    );
  }
}

class _AchievementsView extends StatefulWidget {
  const _AchievementsView();

  @override
  State<_AchievementsView> createState() => _AchievementsViewState();
}

class _AchievementsViewState extends State<_AchievementsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  /// Tapping any tab scrolls back to the top — re-expanding the header —
  /// whether the user re-taps the current tab or switches to another one.
  void _onTabSelected(AchievementsTab tab) {
    if (_scrollController.hasClients && _scrollController.offset > 0) {
      _scrollController.animateTo(
        0,
        duration: AppDurations.long,
        curve: AppCurves.emphasized,
      );
    }
    context.read<AchievementsCubit>().selectTab(tab);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: BlocBuilder<AchievementsCubit, AchievementsState>(
        builder: (context, state) {
          // The header is always present and stable across state changes (its
          // entrance plays once); only the active tab is forwarded so the pill
          // animates its selection.
          final selectedTab = state is AchievementsLoaded
              ? state.selectedTab
              : AchievementsTab.tasks;

          return CustomScrollView(
            controller: _scrollController,
            // Bouncing-aware physics that feel consistent on Android and iOS.
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              AchievementsSliverHeader(
                selectedTab: selectedTab,
                onTabChanged: _onTabSelected,
              ),
              _content(context, state),
            ],
          );
        },
      ),
    );
  }

  Widget _content(BuildContext context, AchievementsState state) {
    switch (state) {
      case AchievementsInitial():
      case AchievementsLoading():
        return const SliverFillRemaining(
          hasScrollBody: false,
          child: _LoadingView(),
        );
      case AchievementsError(:final message):
        return SliverFillRemaining(
          hasScrollBody: false,
          child: _ErrorView(
            message: message,
            onRetry: () => context.read<AchievementsCubit>().load(),
          ),
        );
      case AchievementsLoaded():
        // SliverSafeArea guarantees the last item clears the Android nav bar /
        // gesture area and the iOS home indicator, plus side notches in
        // landscape — applied once here rather than per screen.
        return SliverSafeArea(
          top: false,
          minimum: EdgeInsets.only(bottom: AppDimens.spaceXxl.h),
          sliver: switch (state.selectedTab) {
            AchievementsTab.tasks => TasksTab(tasks: state.tasks),
            AchievementsTab.records => RecordsTab(records: state.records),
            AchievementsTab.prizes => PrizesTab(prizes: state.prizes),
          },
        );
    }
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.primaryGreen),
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimens.spaceXl.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTextStyles.cardSubtitle,
            ),
            SizedBox(height: AppDimens.spaceLg.h),
            FilledButton(
              onPressed: onRetry,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
              ),
              child: Text(AppLocalizations.of(context).retry),
            ),
          ],
        ),
      ),
    );
  }
}
