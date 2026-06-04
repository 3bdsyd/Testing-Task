part of 'achievements_cubit.dart';

/// The three achievement categories, in display (RTL) order.
enum AchievementsTab { tasks, records, prizes }

/// State union for the achievements screen. Sealed so the UI can pattern-match
/// exhaustively without Freezed (CLAUDE.md §B2).
sealed class AchievementsState extends Equatable {
  const AchievementsState();

  @override
  List<Object?> get props => [];
}

final class AchievementsInitial extends AchievementsState {
  const AchievementsInitial();
}

final class AchievementsLoading extends AchievementsState {
  const AchievementsLoading();
}

final class AchievementsLoaded extends AchievementsState {
  const AchievementsLoaded({
    required this.tasks,
    required this.records,
    required this.prizes,
    this.selectedTab = AchievementsTab.tasks,
  });

  final List<TaskAchievement> tasks;
  final RecordsCollection records;
  final List<PrizeAchievement> prizes;
  final AchievementsTab selectedTab;

  AchievementsLoaded copyWith({AchievementsTab? selectedTab}) {
    return AchievementsLoaded(
      tasks: tasks,
      records: records,
      prizes: prizes,
      selectedTab: selectedTab ?? this.selectedTab,
    );
  }

  @override
  List<Object?> get props => [tasks, records, prizes, selectedTab];
}

final class AchievementsError extends AchievementsState {
  const AchievementsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
