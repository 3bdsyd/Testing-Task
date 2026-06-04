import 'package:equatable/equatable.dart';

/// A prize shown in the "الجوائز" (Prizes) tab. [owned]/[total] render as
/// "5 من 10".
class PrizeAchievement extends Equatable {
  const PrizeAchievement({
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

  @override
  List<Object?> get props => [id, title, value, owned, total];
}
