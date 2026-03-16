import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import '../app_colors.dart';

class AppMiscTheme {
  AppMiscTheme._();

  /// Chip Theme - Dùng cho các thẻ tag, bộ lọc
  static ChipThemeData getChipTheme({required bool isDark}) => ChipThemeData(
    shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
    selectedColor: isDark ? AppColors.primary : AppColors.primaryLight,
    backgroundColor: isDark ? AppColors.darkOutline : AppColors.outline,
    labelStyle: TextStyle(
      color: isDark ? Colors.white : AppColors.textPrimary,
      fontSize: AppDimensions.fontSizeLabelMedium,
    ),
    padding: AppSpacing.paddingAllSm,
    secondarySelectedColor: AppColors.secondary,
  );

  /// Progress Indicator Theme - Dùng cho Loading bar/circle
  static ProgressIndicatorThemeData getProgressIndicatorTheme({
    required bool isDark,
  }) => ProgressIndicatorThemeData(
    color: isDark ? AppColors.primaryLight : AppColors.primary,
    linearTrackColor: isDark ? AppColors.darkOutline : AppColors.outline,
    refreshBackgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
  );

  /// Dialog Theme - Dùng cho các bảng thông báo
  static DialogThemeData getDialogTheme({required bool isDark}) =>
      DialogThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        shape: AppRadius.roundedRectangleBorderLg,
        elevation: AppDimensions.elevationLg,
        titleTextStyle: TextStyle(
          color: isDark ? AppColors.darkOnSurface : AppColors.textPrimary,
          fontSize: AppDimensions.fontSizeTitleLarge,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: TextStyle(
          color: isDark
              ? AppColors.darkOnSurface.withValues(alpha: 0.8)
              : AppColors.textSecondary,
          fontSize: AppDimensions.fontSizeBodyMedium,
        ),
      );
}
