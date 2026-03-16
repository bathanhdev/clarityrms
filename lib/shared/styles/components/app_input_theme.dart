import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import '../app_colors.dart';

class AppInputTheme {
  AppInputTheme._();

  static InputDecorationTheme getTheme({required bool isDark}) {
    return InputDecorationTheme(
      // 1. CẤU HÌNH NỀN (Nổi bật hơn trên Dark Mode với Surface L2)
      filled: true,
      fillColor: isDark ? AppColors.darkSurfaceL2 : Colors.white,

      isDense: true,

      // Padding ngang lớn (Lg) để tạo sự sang trọng, Padding dọc (Md) để căn giữa
      contentPadding: AppSpacing.paddingSymmetricMd,

      // 3. TEXT STYLES (Định nghĩa màu và kích thước theo Dimensions)
      // Label dùng bodyMedium (14px)
      labelStyle: TextStyle(
        fontSize: AppDimensions.fontSizeBodyMedium,
        color: isDark
            ? AppColors.darkOnSurface.withAlpha(178) // ~0.7 opacity
            : AppColors.textSecondary,
      ),
      // Hint dùng bodyMedium (14px)
      hintStyle: TextStyle(
        fontSize: AppDimensions.fontSizeBodyMedium,
        color: isDark
            ? AppColors.darkOnSurface.withAlpha(102) // ~0.4 opacity
            : AppColors.textSecondary.withAlpha(153), // ~0.6 opacity
      ),
      // Khi Label bay lên trên
      floatingLabelStyle: TextStyle(
        fontSize: AppDimensions.fontSizeLabelLarge, // 14px
        color: isDark ? AppColors.primaryLowSat : AppColors.primary,
        fontWeight: FontWeight.w600,
      ),

      // 4. ICON COLORS
      prefixIconColor: isDark
          ? AppColors.darkTextSecondary
          : AppColors.textSecondary,
      suffixIconColor: isDark
          ? AppColors.darkTextSecondary
          : AppColors.textSecondary,

      // 5. BORDERS (Đồng bộ Bo góc và Độ dày)
      border: _buildBorder(
        isDark: isDark,
        color: isDark ? AppColors.darkOutline : AppColors.outline,
      ),
      enabledBorder: _buildBorder(
        isDark: isDark,
        color: isDark ? AppColors.darkOutline : AppColors.outline,
      ),
      focusedBorder: _buildBorder(
        isDark: isDark,
        color: isDark ? AppColors.primaryLowSat : AppColors.primary,
        width: AppDimensions.lineThicknessLg,
      ),

      errorBorder: _buildBorder(isDark: isDark, color: AppColors.error),
      focusedErrorBorder: _buildBorder(
        isDark: isDark,
        color: AppColors.error,
        width: AppDimensions.lineThicknessLg,
      ),

      disabledBorder: _buildBorder(
        isDark: isDark,
        color: (isDark ? AppColors.darkOutline : AppColors.outline).withAlpha(
          80,
        ),
      ),
    );
  }

  /// Hàm hỗ trợ build Border để code gọn gàng hơn
  static OutlineInputBorder _buildBorder({
    required bool isDark,
    required Color color,
    double? width,
  }) {
    return OutlineInputBorder(
      gapPadding: 0,
      borderRadius: AppRadius.borderRadiusMd,
      borderSide: BorderSide(
        color: color.withValues(alpha: .6),
        width: width ?? AppDimensions.lineThicknessMd,
      ),
    );
  }
}
