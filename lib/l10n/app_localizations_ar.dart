// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'الانجازات';

  @override
  String get tabTasks => 'المهام';

  @override
  String get tabRecords => 'الارقام القياسية';

  @override
  String get tabPrizes => 'الجوائز';

  @override
  String get sectionMyRecords => 'ارقامي القياسي';

  @override
  String get sectionTopRecords => 'اعلى ارقام قياسية في النظام';

  @override
  String get sectionMyPrizes => 'الجوائز الخاصة بي';

  @override
  String get claim => 'احصل عليها';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String taskProgress(int current, int target) {
    return '$current/$target';
  }

  @override
  String prizeProgress(int current, int total) {
    return '$current من $total';
  }
}
