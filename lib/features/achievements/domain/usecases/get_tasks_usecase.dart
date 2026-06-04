import '../../../../core/error/api_result.dart';
import '../entities/task_achievement.dart';
import '../repositories/achievements_repository.dart';

/// Fetches the user's task/mission achievements.
class GetTasksUseCase {
  const GetTasksUseCase(this._repository);

  final AchievementsRepository _repository;

  Future<ApiResult<List<TaskAchievement>>> call() => _repository.getTasks();
}
