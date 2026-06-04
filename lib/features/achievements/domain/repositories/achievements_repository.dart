import '../../../../core/error/api_result.dart';
import '../entities/prize_achievement.dart';
import '../entities/record_achievement.dart';
import '../entities/task_achievement.dart';

/// Domain contract for achievement data. Implemented in the data layer; use
/// cases depend on this abstraction only (CLAUDE.md §1).
///
/// Each category is fetched independently so new tabs can be lazy-loaded later
/// without touching existing ones.
abstract interface class AchievementsRepository {
  Future<ApiResult<List<TaskAchievement>>> getTasks();

  Future<ApiResult<RecordsCollection>> getRecords();

  Future<ApiResult<List<PrizeAchievement>>> getPrizes();
}
