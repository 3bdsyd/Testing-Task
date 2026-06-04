import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'features/achievements/presentation/pages/achievements_page.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock the app to portrait on both Android and iOS. Native configs
  // (AndroidManifest / Info.plist) enforce the same at the OS level.
  await SystemChrome.setPreferredOrientations(const [
    DeviceOrientation.portraitUp,
  ]);
  configureDependencies();
  runApp(const TestingTaskApp());
}

class TestingTaskApp extends StatelessWidget {
  const TestingTaskApp({super.key});

  /// Reference design canvas. `flutter_screenutil` scales every `.w/.h/.sp/.r`
  /// against this so the UI stays proportional from small phones to tablets.
  static const Size _designSize = Size(375, 812);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: _designSize,
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, _) {
        return MaterialApp(
          title: 'Achievements',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          // App is Arabic-first; locale resolution + GlobalMaterialLocalizations
          // give the whole tree RTL directionality, so individual widgets need
          // no manual RTL wrappers.
          locale: const Locale('ar'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          home: const AchievementsPage(),
        );
      },
    );
  }
}
