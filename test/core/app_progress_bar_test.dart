import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:testing_task/core/widgets/app_progress_bar.dart';

Widget _host(Widget child, {bool disableAnimations = false}) {
  return ScreenUtilInit(
    designSize: const Size(375, 812),
    builder: (context, _) => MediaQuery(
      data: MediaQueryData(disableAnimations: disableAnimations),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Center(child: SizedBox(width: 200, child: child)),
      ),
    ),
  );
}

double _fill(WidgetTester tester) {
  return tester
          .widget<FractionallySizedBox>(find.byType(FractionallySizedBox))
          .widthFactor ??
      1;
}

void main() {
  testWidgets('animates the fill from 0 to its value on first appearance',
      (tester) async {
    await tester.pumpWidget(
      _host(const AppProgressBar(value: 0.6, label: '3/5')),
    );

    // Starts (near) empty rather than snapping to the final value.
    await tester.pump();
    expect(_fill(tester), lessThan(0.2));

    // Settles exactly at the target.
    await tester.pumpAndSettle();
    expect(_fill(tester), closeTo(0.6, 0.001));

    // The fill is anchored to the start edge (right in RTL), not centred.
    final box =
        tester.widget<FractionallySizedBox>(find.byType(FractionallySizedBox));
    expect(box.alignment, AlignmentDirectional.centerStart);
  });

  testWidgets('jumps straight to value when animations are disabled',
      (tester) async {
    await tester.pumpWidget(
      _host(
        const AppProgressBar(value: 0.6, label: '3/5'),
        disableAnimations: true,
      ),
    );
    await tester.pump();

    expect(_fill(tester), closeTo(0.6, 0.001));
  });

  testWidgets('re-animates from the current fill when the value changes',
      (tester) async {
    await tester.pumpWidget(
      _host(const AppProgressBar(value: 0.2, label: '1/5')),
    );
    await tester.pumpAndSettle();
    expect(_fill(tester), closeTo(0.2, 0.001));

    // New value (e.g. fresh API data) animates rather than snapping.
    await tester.pumpWidget(
      _host(const AppProgressBar(value: 0.9, label: '9/10')),
    );
    await tester.pump();
    expect(_fill(tester), lessThan(0.9));

    await tester.pumpAndSettle();
    expect(_fill(tester), closeTo(0.9, 0.001));
  });
}
