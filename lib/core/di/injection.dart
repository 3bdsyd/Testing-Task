import 'package:get_it/get_it.dart';

import '../../features/achievements/data/datasources/achievements_local_data_source.dart';
import '../../features/achievements/data/repositories/achievements_repository_impl.dart';
import '../../features/achievements/domain/repositories/achievements_repository.dart';
import '../../features/achievements/domain/usecases/get_prizes_usecase.dart';
import '../../features/achievements/domain/usecases/get_records_usecase.dart';
import '../../features/achievements/domain/usecases/get_tasks_usecase.dart';
import '../../features/achievements/presentation/cubit/achievements_cubit.dart';

/// Global service locator (CLAUDE.md §B6). Everything is wired here; widgets,
/// cubits, use cases and repositories are resolved through [getIt] rather than
/// being instantiated by hand.
final GetIt getIt = GetIt.instance;

/// Call once at startup, before `runApp`.
void configureDependencies() {
  _registerAchievements();
}

void _registerAchievements() {
  // Data layer.
  getIt.registerLazySingleton<AchievementsLocalDataSource>(
    AchievementsLocalDataSourceImpl.new,
  );
  getIt.registerLazySingleton<AchievementsRepository>(
    () => AchievementsRepositoryImpl(getIt()),
  );

  // Domain layer (use cases).
  getIt
    ..registerFactory(() => GetTasksUseCase(getIt()))
    ..registerFactory(() => GetRecordsUseCase(getIt()))
    ..registerFactory(() => GetPrizesUseCase(getIt()));

  // Presentation layer. A fresh cubit per screen instance.
  getIt.registerFactory(
    () => AchievementsCubit(
      getTasks: getIt(),
      getRecords: getIt(),
      getPrizes: getIt(),
    ),
  );
}
