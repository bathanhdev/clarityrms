import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import '../app_colors.dart';

class AppFabTheme {
  static FloatingActionButtonThemeData getTheme({required bool isDark}) =>
      FloatingActionButtonThemeData(
        backgroundColor: isDark ? AppColors.primary : AppColors.primaryLight,
        foregroundColor: isDark ? Colors.white : const Color(0xFF001A40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        elevation: AppDimensions.elevationMd,
      );
}
