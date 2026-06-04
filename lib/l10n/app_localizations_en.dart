// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Achievements';

  @override
  String get tabTasks => 'Tasks';

  @override
  String get tabRecords => 'Records';

  @override
  String get tabPrizes => 'Prizes';

  @override
  String get sectionMyRecords => 'My records';

  @override
  String get sectionTopRecords => 'Top records in the system';

  @override
  String get sectionMyPrizes => 'My prizes';

  @override
  String get claim => 'Claim';

  @override
  String get retry => 'Retry';

  @override
  String taskProgress(int current, int target) {
    return '$current/$target';
  }

  @override
  String prizeProgress(int current, int total) {
    return '$current of $total';
  }
}
