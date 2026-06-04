import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_colors.dart';

/// Centralized text styles. Font sizes use `.sp` so they scale with
/// `flutter_screenutil`. Reference these instead of inlining `TextStyle`
/// (CLAUDE.md §9).
abstract final class AppTextStyles {
  const AppTextStyles._();

  /// Large white header title ("الانجازات").
  static TextStyle get headerTitle => TextStyle(
    fontSize: 22.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.textOnPrimary,
    height: 1.1,
  );

  /// Tab label (selected / unselected color applied by the widget).
  static TextStyle get tabLabel =>
      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700);

  /// Green section header ("ارقامي القياسي").
  static TextStyle get sectionTitle => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.primaryGreen,
  );

  /// Card title ("العنوان").
  static TextStyle get cardTitle => TextStyle(
    fontSize: 16.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
  );

  /// Card secondary description / date.
  static TextStyle get cardSubtitle => TextStyle(
    fontSize: 13.sp,
    fontWeight: FontWeight.w400,
    color: AppColors.textSecondary,
  );

  /// Bold student name under a top-record card.
  static TextStyle get studentName => TextStyle(
    fontSize: 14.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  /// Number badge value ("523").
  static TextStyle get badgeNumber => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w800,
    color: AppColors.textPrimary,
  );

  /// White label inside a progress bar / on the claim button.
  static TextStyle get onAccent => TextStyle(
    fontSize: 12.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnPrimary,
  );

  /// Claim button label.
  static TextStyle get button => TextStyle(
    fontSize: 15.sp,
    fontWeight: FontWeight.w700,
    color: AppColors.textOnPrimary,
  );
}
