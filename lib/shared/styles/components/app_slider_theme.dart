import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppSliderTheme {
  AppSliderTheme._();

  /// Progress Indicator Theme - Dùng cho thanh tiến trình (Linear/Circular)
  static ProgressIndicatorThemeData getProgressTheme({required bool isDark}) =>
      ProgressIndicatorThemeData(
        // Sử dụng Indigo cho Progress
        color: isDark ? AppColors.primaryLight : AppColors.primary,
        linearTrackColor: isDark ? AppColors.darkOutline : AppColors.outline,
      );

  /// Slider Theme - Dùng cho các thanh trượt điều chỉnh giá trị
  static SliderThemeData getSliderTheme({required bool isDark}) =>
      SliderThemeData(
        // Thanh đang hoạt động (Active)
        activeTrackColor: isDark ? AppColors.primaryLight : AppColors.primary,
        // Thanh chưa hoạt động (Inactive)
        inactiveTrackColor: isDark ? AppColors.darkOutline : AppColors.outline,
        // Nút trượt (Thumb)
        thumbColor: isDark ? AppColors.primaryLight : AppColors.primary,
        // Vòng tròn lan tỏa khi chạm vào thumb
        overlayColor: (isDark ? AppColors.primaryLight : AppColors.primary)
            .withValues(
              alpha: 0.12,
            ), // Sử dụng withValues thay cho withAlpha/withOpacity
        // Tùy chỉnh kích thước để trông hiện đại hơn
        trackHeight: 4.0,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),

        // Màu sắc nhãn giá trị (Value Indicator)
        valueIndicatorColor: AppColors.primary,
        valueIndicatorTextStyle: const TextStyle(color: Colors.white),
      );
}
