import '../../domain/entities/prize_achievement.dart';

/// Data-layer DTO for a prize achievement.
class PrizeAchievementModel {
  const PrizeAchievementModel({
    required this.id,
    required this.title,
    required this.value,
    required this.owned,
    required this.total,
  });

  final String id;
  final String title;
  final int value;
  final int owned;
  final int total;

  factory PrizeAchievementModel.fromJson(Map<String, dynamic> json) {
    return PrizeAchievementModel(
      id: json['id'] as String,
      title: json['title'] as String,
      value: json['value'] as int,
      owned: json['owned'] as int,
      total: json['total'] as int,
    );
  }

  PrizeAchievement toEntity() => PrizeAchievement(
        id: id,
        title: title,
        value: value,
        owned: owned,
        total: total,
      );
}
