import 'package:equatable/equatable.dart';

/// Lifecycle of a task/mission achievement.
enum TaskStatus {
  /// Still being worked on — show a progress bar.
  inProgress,

  /// Completed and the reward can be collected — show the claim button.
  claimable,

  /// Reward already collected.
  claimed,
}

/// A mission shown in the "المهام" (Tasks) tab.
///
/// Pure domain entity — no Flutter imports (CLAUDE.md §B3).
class TaskAchievement extends Equatable {
  const TaskAchievement({
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
  final TaskStatus status;

  /// Completion fraction in 0..1, safe against a zero target.
  double get progress {
    if (target <= 0) return 0;
    return (current / target).clamp(0.0, 1.0);
  }

  @override
  List<Object?> get props => [id, title, description, current, target, status];
}
