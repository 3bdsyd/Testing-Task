import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/api_result.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/prize_achievement.dart';
import '../../domain/entities/record_achievement.dart';
import '../../domain/entities/task_achievement.dart';
import '../../domain/usecases/get_prizes_usecase.dart';
import '../../domain/usecases/get_records_usecase.dart';
import '../../domain/usecases/get_tasks_usecase.dart';

part 'achievements_state.dart';

/// Drives the achievements screen. Depends only on use cases (CLAUDE.md §B1)
/// and resolves all business decisions here so widgets stay declarative.
class AchievementsCubit extends Cubit<AchievementsState> {
  AchievementsCubit({
    required GetTasksUseCase getTasks,
    required GetRecordsUseCase getRecords,
    required GetPrizesUseCase getPrizes,
  })  : _getTasks = getTasks,
        _getRecords = getRecords,
        _getPrizes = getPrizes,
        super(const AchievementsInitial());

  final GetTasksUseCase _getTasks;
  final GetRecordsUseCase _getRecords;
  final GetPrizesUseCase _getPrizes;

  /// Loads every category. Categories are fetched concurrently; the screen
  /// shows a single loaded state once all are available.
  Future<void> load() async {
    emit(const AchievementsLoading());

    final results = await Future.wait([
      _getTasks(),
      _getRecords(),
      _getPrizes(),
    ]);

    final tasksResult = results[0] as ApiResult<List<TaskAchievement>>;
    final recordsResult = results[1] as ApiResult<RecordsCollection>;
    final prizesResult = results[2] as ApiResult<List<PrizeAchievement>>;

    switch ((tasksResult, recordsResult, prizesResult)) {
      case (
          Success(data: final tasks),
          Success(data: final records),
          Success(data: final prizes),
        ):
        emit(AchievementsLoaded(
          tasks: tasks,
          records: records,
          prizes: prizes,
        ));
      default:
        emit(AchievementsError(_firstFailureMessage(results)));
    }
  }

  /// Switches the active tab. No-op unless data is already loaded.
  void selectTab(AchievementsTab tab) {
    final current = state;
    if (current is AchievementsLoaded && current.selectedTab != tab) {
      emit(current.copyWith(selectedTab: tab));
    }
  }

  String _firstFailureMessage(List<ApiResult<Object?>> results) {
    for (final result in results) {
      if (result case ResultFailure(:final failure)) {
        return failure.message;
      }
    }
    return const UnknownFailure().message;
  }
}
