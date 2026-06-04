import '../../../../core/error/api_result.dart';
import '../entities/record_achievement.dart';
import '../repositories/achievements_repository.dart';

/// Fetches the user's personal records and the system-wide top records.
class GetRecordsUseCase {
  const GetRecordsUseCase(this._repository);

  final AchievementsRepository _repository;

  Future<ApiResult<RecordsCollection>> call() => _repository.getRecords();
}
