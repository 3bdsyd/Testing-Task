import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_task/core/di/injection.dart';
import 'package:testing_task/features/achievements/presentation/pages/achievements_page.dart';
import 'package:testing_task/l10n/app_localizations.dart';

Widget _wrap() {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (context, _) => MaterialApp(
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const AchievementsPage(),
    ),
  );
}

void main() {
  setUpAll(configureDependencies);
  tearDownAll(getIt.reset);

  testWidgets('renders the achievements header and tab labels', (tester) async {
    await tester.pumpWidget(_wrap());
    // Let the mock data-source latency and entrance animations settle.
    await tester.pumpAndSettle(const Duration(seconds: 1));

    expect(find.text('الانجازات'), findsOneWidget);
    expect(find.text('المهام'), findsOneWidget);
    expect(find.text('الجوائز'), findsOneWidget);
  });

  testWidgets('switches to the prizes tab on tap', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.tap(find.text('الجوائز'));
    await tester.pumpAndSettle();

    // Prizes section header is shown after switching tabs.
    expect(find.text('الجوائز الخاصة بي'), findsOneWidget);
  });

  testWidgets('renders both record sections without overflow', (tester) async {
    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    await tester.tap(find.text('الارقام القياسية'));
    await tester.pumpAndSettle();

    expect(find.text('ارقامي القياسي'), findsOneWidget);

    // The second section is lazily built; scrolling reveals it (and exercises
    // the collapsing header). A render overflow would throw during the pumps.
    await tester.scrollUntilVisible(
      find.text('اعلى ارقام قياسية في النظام'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('اعلى ارقام قياسية في النظام'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('header collapses but tabs stay pinned and tappable on scroll',
      (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 700);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Move to the tall prizes tab so there's plenty of scroll extent.
    await tester.tap(find.text('الجوائز'));
    await tester.pumpAndSettle();

    // The collapsing region (title + banner) shrinks as the user scrolls up.
    final flexible = find.byType(FlexibleSpaceBar);
    final expandedHeight = tester.getSize(flexible).height;

    await tester.drag(find.byType(CustomScrollView), const Offset(0, -400));
    await tester.pumpAndSettle();

    final collapsedHeight = tester.getSize(flexible).height;
    expect(collapsedHeight, lessThan(expandedHeight));

    // Tabs remain pinned and usable without scrolling back to the top.
    expect(find.text('المهام'), findsOneWidget);
    await tester.tap(find.text('المهام'));
    await tester.pumpAndSettle();
    expect(find.text('الوصف الذي بعد العنوان'), findsWidgets);
  });

  testWidgets('tapping a tab scrolls back to the top', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 700);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(_wrap());
    await tester.pumpAndSettle(const Duration(seconds: 1));

    // Go to the tall prizes tab and scroll down.
    await tester.tap(find.text('الجوائز'));
    await tester.pumpAndSettle();

    final position = tester.state<ScrollableState>(find.byType(Scrollable));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -350));
    await tester.pumpAndSettle();
    expect(position.position.pixels, greaterThan(0));

    // Re-tapping the *same* tab returns to the top.
    await tester.tap(find.text('الجوائز'));
    await tester.pumpAndSettle();
    expect(position.position.pixels, 0);

    // Scroll down again, then switching to *another* tab also resets to top.
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -350));
    await tester.pumpAndSettle();
    expect(position.position.pixels, greaterThan(0));

    await tester.tap(find.text('الارقام القياسية'));
    await tester.pumpAndSettle();
    expect(position.position.pixels, 0);
  });

  // Responsiveness guarantee: every tab must render without overflow across
  // small phones, large phones and tablets.
  const sizes = <String, Size>{
    'small phone': Size(320, 568),
    'large phone': Size(414, 896),
    'tablet': Size(768, 1024),
  };

  for (final entry in sizes.entries) {
    testWidgets('renders every tab without overflow on ${entry.key}',
        (tester) async {
      tester.view.devicePixelRatio = 1.0;
      tester.view.physicalSize = entry.value;
      addTearDown(tester.view.reset);

      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle(const Duration(seconds: 1));

      for (final tab in ['الارقام القياسية', 'الجوائز', 'المهام']) {
        await tester.tap(find.text(tab));
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: '$tab on ${entry.key}');
      }
    });
  }
}
