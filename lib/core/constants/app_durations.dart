/// Shared animation durations.
///
/// Centralized so motion stays consistent across screens — don't invent new
/// per-screen durations (see CLAUDE.md §8 / §15).
abstract final class AppDurations {
  const AppDurations._();

  /// Quick feedback (press / ripple).
  static const Duration fast = Duration(milliseconds: 120);

  /// Short transitions (150–200ms band).
  static const Duration short = Duration(milliseconds: 180);

  /// Medium transitions (250–300ms band) — tab switches, content reveals.
  static const Duration medium = Duration(milliseconds: 280);

  /// Long transitions (400–500ms band) — header / banner entrance.
  static const Duration long = Duration(milliseconds: 450);

  /// Delay between consecutive items in a staggered reveal.
  static const Duration stagger = Duration(milliseconds: 70);
}
