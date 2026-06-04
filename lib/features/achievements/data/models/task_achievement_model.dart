import '../../domain/entities/task_achievement.dart';

/// Data-layer DTO for a task achievement. Kept separate from the domain entity
/// so API shape changes never leak into the domain/presentation (CLAUDE.md §B13).
class TaskAchievementModel {
  const TaskAchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.current,
    required this.target,
    required this.status,
  });

  final String id;
  final String title;
  final String description;
  final int current;
  final int target;
  final String status;

  factory TaskAchievementModel.fromJson(Map<String, dynamic> json) {
    return TaskAchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      current: json['current'] as int,
      target: json['target'] as int,
      status: json['status'] as String,
    );
  }

  TaskAchievement toEntity() => TaskAchievement(
        id: id,
        title: title,
        description: description,
        current: current,
        target: target,
        status: _statusFromString(status),
      );

  static TaskStatus _statusFromString(String value) {
    return switch (value) {
      'claimable' => TaskStatus.claimable,
      'claimed' => TaskStatus.claimed,
      _ => TaskStatus.inProgress,
    };
  }
}
