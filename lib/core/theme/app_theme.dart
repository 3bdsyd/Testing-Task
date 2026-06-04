import 'package:flutter/material.dart';

import '../constants/app_fonts.dart';
import 'app_colors.dart';

/// Single source of truth for the app's [ThemeData].
abstract final class AppTheme {
  const AppTheme._();

  static ThemeData get light => ThemeData(
        useMaterial3: true,
        // App-wide font. Text styles in AppTextStyles inherit this, so it
        // flows everywhere without per-widget fontFamily.
        fontFamily: AppFonts.nunito,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryGreen,
          primary: AppColors.primaryGreen,
          surface: AppColors.surface,
        ),
        splashFactory: InkRipple.splashFactory,
      );
}
