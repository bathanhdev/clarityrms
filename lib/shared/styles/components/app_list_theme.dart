import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/shared/styles/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';

class AppListTheme {
  static DividerThemeData getDividerTheme({required bool isDark}) =>
      DividerThemeData(
        color: isDark ? AppColors.darkSurfaceL2 : AppColors.outline,
        thickness: AppDimensions.lineThicknessMd,
        space: AppSpacing.xs,
      );

  static ScrollbarThemeData getScrollbarTheme({required bool isDark}) =>
      ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        ),
        thickness: WidgetStateProperty.all(AppDimensions.scrollbarThickness),
        radius: const Radius.circular(AppRadius.md),
      );
}
