import '../../../../core/error/api_result.dart';
import '../../../../core/error/failure.dart';
import '../../domain/entities/prize_achievement.dart';
import '../../domain/entities/record_achievement.dart';
import '../../domain/entities/task_achievement.dart';
import '../../domain/repositories/achievements_repository.dart';
import '../datasources/achievements_local_data_source.dart';

/// Concrete repository. Catches data-source exceptions at the boundary and maps
/// them to typed [Failure]s, returning domain entities upward (CLAUDE.md §3/§B5).
class AchievementsRepositoryImpl implements AchievementsRepository {
  const AchievementsRepositoryImpl(this._dataSource);

  final AchievementsLocalDataSource _dataSource;

  @override
  Future<ApiResult<List<TaskAchievement>>> getTasks() async {
    try {
      final models = await _dataSource.getTasks();
      return ApiResult.success(
        models.map((m) => m.toEntity()).toList(growable: false),
      );
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<RecordsCollection>> getRecords() async {
    try {
      final data = await _dataSource.getRecords();
      return ApiResult.success(
        RecordsCollection(
          myRecords: data.mine.map((m) => m.toEntity()).toList(growable: false),
          topRecords: data.top.map((m) => m.toEntity()).toList(growable: false),
        ),
      );
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }

  @override
  Future<ApiResult<List<PrizeAchievement>>> getPrizes() async {
    try {
      final models = await _dataSource.getPrizes();
      return ApiResult.success(
        models.map((m) => m.toEntity()).toList(growable: false),
      );
    } catch (e) {
      return ApiResult.failure(ServerFailure(e.toString()));
    }
  }
}
