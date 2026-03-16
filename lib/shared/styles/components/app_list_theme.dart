import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';

class AppListTheme {
  static DividerThemeData getDividerTheme({required bool isDark}) =>
      DividerThemeData(
        color: isDark ? const Color(0xFF424242) : const Color(0xFFE0E0E0),
        thickness: AppDimensions.lineThicknessMd,
        space: AppSpacing.xs,
      );

  static ScrollbarThemeData getScrollbarTheme({required bool isDark}) =>
      ScrollbarThemeData(
        thumbColor: WidgetStateProperty.all(
          isDark ? const Color(0xFF9E8E83) : const Color(0xFF83746B),
        ),
        thickness: WidgetStateProperty.all(AppDimensions.scrollbarThickness),
        radius: const Radius.circular(AppRadius.md),
      );
}
