import 'package:flutter/material.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import '../app_colors.dart';

class AppAppBarTheme {
  static AppBarTheme getTheme({required bool isDark}) => AppBarTheme(
    backgroundColor: isDark ? const Color(0xFF111318) : AppColors.primary,
    foregroundColor: Colors.white,
    elevation: AppDimensions.elevationNone,
    centerTitle: true,
    toolbarHeight: AppDimensions.appBarHeight,
  );
}
