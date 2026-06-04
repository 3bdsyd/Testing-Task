import '../../domain/entities/record_achievement.dart';

/// Data-layer DTO for a record achievement.
class RecordAchievementModel {
  const RecordAchievementModel({
    required this.id,
    required this.title,
    required this.date,
    required this.value,
    this.studentName,
  });

  final String id;
  final String title;
  final String date;
  final int value;
  final String? studentName;

  factory RecordAchievementModel.fromJson(Map<String, dynamic> json) {
    return RecordAchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      value: json['value'] as int,
      studentName: json['studentName'] as String?,
    );
  }

  RecordAchievement toEntity() => RecordAchievement(
        id: id,
        title: title,
        date: date,
        value: value,
        studentName: studentName,
      );
}
