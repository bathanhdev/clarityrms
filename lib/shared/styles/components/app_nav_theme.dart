import 'package:flutter/material.dart';
import '../app_colors.dart';

class AppNavTheme {
  AppNavTheme._();

  static BottomNavigationBarThemeData getBottomNavTheme({
    required bool isDark,
  }) => BottomNavigationBarThemeData(
    backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
    selectedItemColor: isDark ? AppColors.primaryLight : AppColors.primary,
    unselectedItemColor: isDark ? Colors.white60 : Colors.black54,

    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 12,
    ),
    unselectedLabelStyle: const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 12,
    ),
  );

  /// NavigationBar Theme (Chuẩn Material 3 hiện đại hơn)
  static NavigationBarThemeData getNavigationBarTheme({required bool isDark}) =>
      NavigationBarThemeData(
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.surface,
        indicatorColor: isDark
            ? AppColors.primary.withValues(alpha: 0.2)
            : AppColors.primaryLight.withValues(alpha: 0.2),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return IconThemeData(
              color: isDark ? AppColors.primaryLight : AppColors.primary,
            );
          }
          return IconThemeData(color: isDark ? Colors.white60 : Colors.black54);
        }),
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final color = states.contains(WidgetState.selected)
              ? (isDark ? AppColors.primaryLight : AppColors.primary)
              : (isDark ? Colors.white60 : Colors.black54);
          return TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          );
        }),
      );
}
