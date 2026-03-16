import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import '../app_colors.dart';

class AppFeedbackTheme {
  static SnackBarThemeData getSnackBarTheme({required bool isDark}) =>
      SnackBarThemeData(
        backgroundColor: isDark
            ? AppColors.primary
            : const Color(0xFF1E293B), // Slate 800
        contentTextStyle: TextStyle(
          color: isDark ? Colors.white : Colors.white,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
      );

  static BottomSheetThemeData getBottomSheetTheme({required bool isDark}) =>
      BottomSheetThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.lg),
          ),
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
      );

  static BadgeThemeData getBadgeTheme({required bool isDark}) => BadgeThemeData(
    backgroundColor: AppColors.error,
    textColor: Colors.white,
    padding: AppSpacing.paddingHorizontalSm,
    largeSize: AppDimensions.iconSizeXs + 2,
  );
}
