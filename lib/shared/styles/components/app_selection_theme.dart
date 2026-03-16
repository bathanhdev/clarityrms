import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppSelectionTheme {
  AppSelectionTheme._();

  /// Checkbox Theme - Bo góc nhẹ hiện đại
  static CheckboxThemeData getCheckboxTheme({required bool isDark}) =>
      CheckboxThemeData(
        checkColor: WidgetStateProperty.all(Colors.white),
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return isDark ? AppColors.primaryLight : AppColors.primary;
          }
          return null;
        }),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      );

  /// Radio Theme
  static RadioThemeData getRadioTheme({required bool isDark}) => RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return isDark ? AppColors.primaryLight : AppColors.primary;
      }
      return null;
    }),
  );

  /// Switch Theme - Tinh chỉnh màu Track và Thumb cho cảm giác "tươi" hơn
  static SwitchThemeData getSwitchTheme({required bool isDark}) =>
      SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white; // Thumb trắng luôn nổi bật khi bật
          }
          return isDark ? Colors.grey[400] : Colors.grey[200];
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            // Khi bật dùng màu Mint (Secondary) hoặc Indigo (Primary)
            return isDark ? AppColors.secondary : AppColors.primary;
          }
          return isDark ? Colors.white10 : Colors.black12;
        }),
      );
}
