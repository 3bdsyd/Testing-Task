/// Shared spacing & radius tokens (logical pixels, design-time values).
///
/// Apply `flutter_screenutil` extensions at the call site (`.w`, `.h`, `.r`)
/// so the same token scales responsively. Never hard-code raw spacing in
/// widgets (CLAUDE.md §9 / §15).
abstract final class AppDimens {
  const AppDimens._();

  // Spacing scale.
  static const double spaceXs = 4;
  static const double spaceSm = 8;
  static const double spaceMd = 12;
  static const double spaceLg = 16;
  static const double spaceXl = 24;
  static const double spaceXxl = 32;

  // Corner radii.
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 22;

  /// Large radius that reads as a full pill.
  static const double radiusPill = 999;

  // Common screen paddings.
  static const double screenPadding = 16;

  // Component sizes.
  static const double bannerHeight = 170;
  static const double tabBarHeight = 52;
  // Reserved height for the header title block (≈ a 22sp line + breathing room).
  static const double headerTitleHeight = 34;
  static const double taskAvatar = 60;
  // Grid avatars are sized to roughly half a 3-column cell at the 375 design
  // width so they leave the gaps the design shows and never overflow a cell.
  static const double recordAvatar = 58;
  static const double prizeAvatar = 64;
  static const double progressBarHeight = 22;
  static const double claimButtonHeight = 44;
}
