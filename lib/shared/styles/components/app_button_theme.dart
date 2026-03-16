import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import '../app_colors.dart';

class AppButtonTheme {
  AppButtonTheme._();

  /// Theme cho Elevated Button (Nút chính - Có nền)
  static ElevatedButtonThemeData getElevatedButtonTheme({
    required bool isDark,
  }) => ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      // Màu nền: Indigo chính cho Light, Indigo nhạt cho Dark
      backgroundColor: isDark ? AppColors.primaryLowSat : AppColors.primary,

      // Màu chữ/icon: Đen sâu trên nền sáng Dark Mode, Trắng trên nền Indigo Light Mode
      foregroundColor: isDark ? AppColors.darkBackground : Colors.white,

      // Hình dạng: Bo góc Md đồng bộ với Input
      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),

      // KHỚP CHIỀU CAO: Ép chiều cao 56px giống Input
      minimumSize: Size(
        AppDimensions.buttonHeightLg,
        AppDimensions.buttonHeightLg,
      ),

      // Khoảng cách bên trong: Dùng LgMd giúp nội dung Button thoáng đãng
      padding: AppSpacing.paddingSymmetricMd,

      // Đổ bóng: Phẳng trong Dark Mode, nhẹ trong Light Mode
      elevation: isDark ? 0 : 2,

      // KHÔNG set textStyle ở đây để tận dụng labelLarge từ TextTheme
      textStyle: TextStyle(
        fontSize: AppDimensions.fontSizeLabelLarge,
        fontWeight: FontWeight.w600,
      ),
    ),
  );

  /// Theme cho Outlined Button (Nút phụ - Chỉ có viền)
  static OutlinedButtonThemeData getOutlinedButtonTheme({
    required bool isDark,
  }) => OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: isDark ? AppColors.primaryLowSat : AppColors.primary,

      side: BorderSide(
        color: isDark ? AppColors.primaryLowSat : AppColors.primary,
        width: AppDimensions.lineThicknessLg,
      ),

      shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),

      minimumSize: Size(
        AppDimensions.buttonHeightLg,
        AppDimensions.buttonHeightLg,
      ),

      padding: AppSpacing.paddingSymmetricMd,

      enabledMouseCursor: SystemMouseCursors.click,
    ),
  );

  /// Theme cho Text Button (Nút dạng chữ)
  static TextButtonThemeData getTextButtonTheme({required bool isDark}) =>
      TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: isDark ? AppColors.primaryLowSat : AppColors.primary,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
          padding: AppSpacing.paddingSymmetricMdSm,
        ),
      );
}
