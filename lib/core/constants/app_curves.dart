import 'package:flutter/animation.dart';

/// Shared animation curves. Avoid `Curves.linear` for UI motion (CLAUDE.md §8).
abstract final class AppCurves {
  const AppCurves._();

  /// Default entrance curve — decelerates into place.
  static const Curve standard = Curves.easeOutCubic;

  /// Symmetric curve for state changes that go both ways (tab switch).
  static const Curve emphasized = Curves.easeInOutCubic;

  /// Springy press feedback.
  static const Curve press = Curves.easeOut;
}
