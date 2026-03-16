import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import '../app_colors.dart';

class AppDecorationTheme {
  static IconThemeData getIconTheme({required bool isDark}) => IconThemeData(
    color: isDark ? AppColors.darkOnSurface : const Color(0xFF1F1B16),
    size: AppDimensions.iconSizeMd,
  );

  static TooltipThemeData getTooltipTheme({required bool isDark}) =>
      TooltipThemeData(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkOnSurface : const Color(0xFF352F2B),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        textStyle: TextStyle(
          color: isDark ? const Color(0xFF1F1B16) : Colors.white,
          fontSize: 12,
        ),
      );
}
