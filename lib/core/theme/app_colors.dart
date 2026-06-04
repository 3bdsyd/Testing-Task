import 'package:flutter/material.dart';

/// Centralized color palette for the design system.
///
/// Never hard-code colors in widgets — reference these tokens so the whole
/// app stays consistent and themeable (see CLAUDE.md §9).
abstract final class AppColors {
  const AppColors._();

  /// Coral/orange used for the achievements header background.
  static const Color primaryOrange = Color(0xFFF47C52);

  /// Brand green used for selected tabs, section titles, card borders and the
  /// claim button.
  static const Color primaryGreen = Color(0xFF15B26B);

  /// Amber fill used inside task progress bars.
  static const Color progressFill = Color(0xFFF5A623);

  /// Neutral track behind a progress bar.
  static const Color track = Color(0xFFE4E4E4);

  /// Generic grey used for image / avatar placeholders.
  static const Color placeholder = Color(0xFFD9D9D9);

  static const Color surface = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFFFF);

  static const Color textPrimary = Color(0xFF2B2B2B);
  static const Color textSecondary = Color(0xFFB5B5B5);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  static const Color shadow = Color(0x1A000000);

  /// Inactive tab label color (on the white pill).
  static const Color tabInactive = Color(0xFFB9B9B9);
}
