import 'package:flutter_test/flutter_test.dart';
import 'package:testing_task/core/error/api_result.dart';
import 'package:testing_task/core/error/failure.dart';
import 'package:testing_task/features/achievements/data/datasources/achievements_local_data_source.dart';
import 'package:testing_task/features/achievements/data/models/prize_achievement_model.dart';
import 'package:testing_task/features/achievements/data/models/record_achievement_model.dart';
import 'package:testing_task/features/achievements/data/models/task_achievement_model.dart';
import 'package:testing_task/features/achievements/data/repositories/achievements_repository_impl.dart';
import 'package:testing_task/features/achievements/domain/entities/task_achievement.dart';

class _FakeDataSource implements AchievementsLocalDataSource {
  @override
  Future<List<TaskAchievementModel>> getTasks() async => const [
        TaskAchievementModel(
          id: 't1',
          title: 'العنوان',
          description: 'الوصف',
          current: 3,
          target: 5,
          status: 'claimable',
        ),
      ];

  @override
  Future<({List<RecordAchievementModel> mine, List<RecordAchievementModel> top})>
      getRecords() async => (
        mine: const [
          RecordAchievementModel(id: 'm1', title: 'ع', date: 'د', value: 523),
        ],
        top: const [
          RecordAchievementModel(
            id: 't1',
            title: 'ع',
            date: 'د',
            value: 523,
            studentName: 'اسم',
          ),
        ],
      );

  @override
  Future<List<PrizeAchievementModel>> getPrizes() async => const [
        PrizeAchievementModel(id: 'p1', title: 'ع', value: 523, owned: 5, total: 10),
      ];
}

class _ThrowingDataSource implements AchievementsLocalDataSource {
  @override
  Future<List<TaskAchievementModel>> getTasks() async =>
      throw Exception('boom');

  @override
  Future<({List<RecordAchievementModel> mine, List<RecordAchievementModel> top})>
      getRecords() async => throw Exception('boom');

  @override
  Future<List<PrizeAchievementModel>> getPrizes() async =>
      throw Exception('boom');
}

void main() {
  group('AchievementsRepositoryImpl', () {
    test('getTasks maps DTOs to domain entities on success', () async {
      final repo = AchievementsRepositoryImpl(_FakeDataSource());

      final result = await repo.getTasks();

      expect(result, isA<Success<List<TaskAchievement>>>());
      final tasks = (result as Success<List<TaskAchievement>>).data;
      expect(tasks, hasLength(1));
      expect(tasks.first.status, TaskStatus.claimable);
      expect(tasks.first.progress, closeTo(0.6, 0.0001));
    });

    test('getRecords splits mine/top and preserves studentName', () async {
      final repo = AchievementsRepositoryImpl(_FakeDataSource());

      final result = await repo.getRecords();

      final data = (result as Success).data;
      expect(data.myRecords.single.studentName, isNull);
      expect(data.topRecords.single.studentName, 'اسم');
    });

    test('maps data-source exceptions to a ServerFailure', () async {
      final repo = AchievementsRepositoryImpl(_ThrowingDataSource());

      final result = await repo.getTasks();

      expect(result, isA<ResultFailure>());
      expect((result as ResultFailure).failure, isA<ServerFailure>());
    });
  });
}
