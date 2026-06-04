import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:testing_task/core/error/api_result.dart';
import 'package:testing_task/core/error/failure.dart';
import 'package:testing_task/features/achievements/domain/entities/prize_achievement.dart';
import 'package:testing_task/features/achievements/domain/entities/record_achievement.dart';
import 'package:testing_task/features/achievements/domain/entities/task_achievement.dart';
import 'package:testing_task/features/achievements/domain/usecases/get_prizes_usecase.dart';
import 'package:testing_task/features/achievements/domain/usecases/get_records_usecase.dart';
import 'package:testing_task/features/achievements/domain/usecases/get_tasks_usecase.dart';
import 'package:testing_task/features/achievements/presentation/cubit/achievements_cubit.dart';

class _MockGetTasks extends Mock implements GetTasksUseCase {}

class _MockGetRecords extends Mock implements GetRecordsUseCase {}

class _MockGetPrizes extends Mock implements GetPrizesUseCase {}

const _task = TaskAchievement(
  id: 't1',
  title: 'ع',
  description: 'د',
  current: 3,
  target: 5,
  status: TaskStatus.inProgress,
);
const _records = RecordsCollection(myRecords: [], topRecords: []);
const _prizes = <PrizeAchievement>[];

void main() {
  late _MockGetTasks getTasks;
  late _MockGetRecords getRecords;
  late _MockGetPrizes getPrizes;

  AchievementsCubit build() => AchievementsCubit(
        getTasks: getTasks,
        getRecords: getRecords,
        getPrizes: getPrizes,
      );

  setUp(() {
    getTasks = _MockGetTasks();
    getRecords = _MockGetRecords();
    getPrizes = _MockGetPrizes();
  });

  void stubSuccess() {
    when(() => getTasks()).thenAnswer((_) async => const Success([_task]));
    when(() => getRecords()).thenAnswer((_) async => const Success(_records));
    when(() => getPrizes()).thenAnswer((_) async => const Success(_prizes));
  }

  group('load', () {
    blocTest<AchievementsCubit, AchievementsState>(
      'emits [Loading, Loaded] when every category succeeds',
      build: () {
        stubSuccess();
        return build();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<AchievementsLoading>(),
        isA<AchievementsLoaded>()
            .having((s) => s.tasks, 'tasks', [_task])
            .having((s) => s.selectedTab, 'selectedTab', AchievementsTab.tasks),
      ],
    );

    blocTest<AchievementsCubit, AchievementsState>(
      'emits [Loading, Error] when any category fails',
      build: () {
        when(() => getTasks())
            .thenAnswer((_) async => const ResultFailure(ServerFailure('x')));
        when(() => getRecords()).thenAnswer((_) async => const Success(_records));
        when(() => getPrizes()).thenAnswer((_) async => const Success(_prizes));
        return build();
      },
      act: (cubit) => cubit.load(),
      expect: () => [
        isA<AchievementsLoading>(),
        isA<AchievementsError>().having((s) => s.message, 'message', 'x'),
      ],
    );
  });

  group('selectTab', () {
    blocTest<AchievementsCubit, AchievementsState>(
      'updates the selected tab when loaded',
      build: build,
      seed: () => const AchievementsLoaded(
        tasks: [_task],
        records: _records,
        prizes: _prizes,
      ),
      act: (cubit) => cubit.selectTab(AchievementsTab.prizes),
      expect: () => [
        isA<AchievementsLoaded>()
            .having((s) => s.selectedTab, 'selectedTab', AchievementsTab.prizes),
      ],
    );

    blocTest<AchievementsCubit, AchievementsState>(
      'is a no-op when the tab is already selected',
      build: build,
      seed: () => const AchievementsLoaded(
        tasks: [_task],
        records: _records,
        prizes: _prizes,
      ),
      act: (cubit) => cubit.selectTab(AchievementsTab.tasks),
      expect: () => const <AchievementsState>[],
    );
  });
}
