import '../../../../core/error/api_result.dart';
import '../entities/prize_achievement.dart';
import '../repositories/achievements_repository.dart';

/// Fetches the user's prizes.
class GetPrizesUseCase {
  const GetPrizesUseCase(this._repository);

  final AchievementsRepository _repository;

  Future<ApiResult<List<PrizeAchievement>>> call() => _repository.getPrizes();
}
