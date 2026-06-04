import '../models/prize_achievement_model.dart';
import '../models/record_achievement_model.dart';
import '../models/task_achievement_model.dart';

/// Source of achievement data.
///
/// Today this is backed by in-memory mock JSON. When a real backend is ready,
/// swap the implementation for a remote data source behind the same interface
/// (or add one alongside it) — the repository and everything above are
/// unaffected (CLAUDE.md §1).
abstract interface class AchievementsLocalDataSource {
  Future<List<TaskAchievementModel>> getTasks();
  Future<({List<RecordAchievementModel> mine, List<RecordAchievementModel> top})>
      getRecords();
  Future<List<PrizeAchievementModel>> getPrizes();
}

class AchievementsLocalDataSourceImpl implements AchievementsLocalDataSource {
  const AchievementsLocalDataSourceImpl();

  /// Simulated I/O latency so loading/entrance states are exercised.
  static const Duration _latency = Duration(milliseconds: 350);

  @override
  Future<List<TaskAchievementModel>> getTasks() async {
    await Future<void>.delayed(_latency);
    return _tasksJson
        .map((e) => TaskAchievementModel.fromJson(e))
        .toList(growable: false);
  }

  @override
  Future<({List<RecordAchievementModel> mine, List<RecordAchievementModel> top})>
      getRecords() async {
    await Future<void>.delayed(_latency);
    return (
      mine: _myRecordsJson
          .map((e) => RecordAchievementModel.fromJson(e))
          .toList(growable: false),
      top: _topRecordsJson
          .map((e) => RecordAchievementModel.fromJson(e))
          .toList(growable: false),
    );
  }

  @override
  Future<List<PrizeAchievementModel>> getPrizes() async {
    await Future<void>.delayed(_latency);
    return _prizesJson
        .map((e) => PrizeAchievementModel.fromJson(e))
        .toList(growable: false);
  }

  // --- Mock payloads -------------------------------------------------------
  // Mirrors the design exactly: three in-progress tasks, one claimable task.

  static final List<Map<String, dynamic>> _tasksJson = [
    {
      'id': 't1',
      'title': 'العنوان',
      'description': 'الوصف الذي بعد العنوان',
      'current': 3,
      'target': 5,
      'status': 'inProgress',
    },
    {
      'id': 't2',
      'title': 'العنوان',
      'description': 'الوصف الذي بعد العنوان',
      'current': 3,
      'target': 5,
      'status': 'inProgress',
    },
    {
      'id': 't3',
      'title': 'العنوان',
      'description': 'الوصف الذي بعد العنوان',
      'current': 5,
      'target': 5,
      'status': 'claimable',
    },
    {
      'id': 't4',
      'title': 'العنوان',
      'description': 'الوصف الذي بعد العنوان',
      'current': 3,
      'target': 5,
      'status': 'inProgress',
    },
  ];

  static final List<Map<String, dynamic>> _myRecordsJson = List.generate(
    6,
    (i) => {
      'id': 'mr$i',
      'title': 'العنوان',
      'date': 'التاريخ',
      'value': 523,
    },
  );

  static final List<Map<String, dynamic>> _topRecordsJson = List.generate(
    6,
    (i) => {
      'id': 'tr$i',
      'title': 'العنوان',
      'date': 'التاريخ',
      'value': 523,
      'studentName': 'اسم الطالب',
    },
  );

  static final List<Map<String, dynamic>> _prizesJson = List.generate(
    9,
    (i) => {
      'id': 'p$i',
      'title': 'العنوان',
      'value': 523,
      'owned': 5,
      'total': 10,
    },
  );
}
