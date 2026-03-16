import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import '../app_colors.dart';

class AppTabBarTheme {
  AppTabBarTheme._();

  static TabBarThemeData getTheme({required bool isDark}) => TabBarThemeData(
    // Chuyển sang màu Indigo chủ đạo
    labelColor: isDark ? AppColors.primaryLight : AppColors.primary,

    unselectedLabelColor: isDark
        ? AppColors.darkOnSurface.withValues(alpha: 0.6)
        : AppColors.textSecondary,

    indicatorSize: TabBarIndicatorSize.tab,

    // Tùy chỉnh thanh gạch chân (Indicator)
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(
        color: isDark ? AppColors.primaryLight : AppColors.primary,
        width: AppDimensions.lineThicknessLg, // Độ dày tiêu chuẩn từ Dimensions
      ),
    ),

    // Kiểu chữ cho Tab
    labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
    unselectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 14,
    ),
  );
}
