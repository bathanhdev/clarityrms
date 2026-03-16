import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import '../app_colors.dart';

class AppCardTheme {
  static CardThemeData getTheme({required bool isDark}) => CardThemeData(
    shape: AppRadius.roundedRectangleBorderMd,
    elevation: isDark ? AppDimensions.elevationMd : AppDimensions.elevationSm,
    color: isDark ? AppColors.darkSurface : AppColors.surface,
    margin: AppSpacing.paddingAllSm,
  );
}
