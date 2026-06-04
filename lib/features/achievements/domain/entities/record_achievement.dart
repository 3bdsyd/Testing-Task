import 'package:equatable/equatable.dart';

/// A record / high-score entry shown in the "الارقام القياسية" (Records) tab.
///
/// The same entity represents both the user's own records and the system-wide
/// top records — for the latter [studentName] is populated.
class RecordAchievement extends Equatable {
  const RecordAchievement({
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

  /// Owner of the record; only present for system-wide top records.
  final String? studentName;

  @override
  List<Object?> get props => [id, title, date, value, studentName];
}

/// Groups the two record lists shown on the Records tab.
class RecordsCollection extends Equatable {
  const RecordsCollection({
    required this.myRecords,
    required this.topRecords,
  });

  final List<RecordAchievement> myRecords;
  final List<RecordAchievement> topRecords;

  @override
  List<Object?> get props => [myRecords, topRecords];
}
