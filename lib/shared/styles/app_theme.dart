import 'package:clarityrms/shared/styles/components/app_bar_theme.dart';
import 'package:clarityrms/shared/styles/components/app_button_theme.dart';
import 'package:clarityrms/shared/styles/components/app_card_theme.dart';
import 'package:clarityrms/shared/styles/components/app_decoration_theme.dart';
import 'package:clarityrms/shared/styles/components/app_fab_theme.dart';
import 'package:clarityrms/shared/styles/components/app_feedback_theme.dart';
import 'package:clarityrms/shared/styles/components/app_input_theme.dart';
import 'package:clarityrms/shared/styles/components/app_list_theme.dart';
import 'package:clarityrms/shared/styles/components/app_misc_theme.dart';
import 'package:clarityrms/shared/styles/components/app_nav_theme.dart';
import 'package:clarityrms/shared/styles/components/app_selection_theme.dart';
import 'package:clarityrms/shared/styles/components/app_slider_theme.dart';
import 'package:clarityrms/shared/styles/components/app_tab_bar_theme.dart';
import 'package:flutter/material.dart';
import 'package:clarityrms/shared/styles/app_typography.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    // COLOR SCHEME
    colorScheme: AppColors.lightScheme,

    // TYPOGRAPHY
    textTheme: AppTypography.lightTextTheme,

    // COMPONENT THEMES
    appBarTheme: AppAppBarTheme.getTheme(isDark: false),
    cardTheme: AppCardTheme.getTheme(isDark: false),

    elevatedButtonTheme: AppButtonTheme.getElevatedButtonTheme(isDark: false),
    outlinedButtonTheme: AppButtonTheme.getOutlinedButtonTheme(isDark: false),
    textButtonTheme: AppButtonTheme.getTextButtonTheme(isDark: false),

    inputDecorationTheme: AppInputTheme.getTheme(isDark: false),

    tabBarTheme: AppTabBarTheme.getTheme(isDark: false),
    floatingActionButtonTheme: AppFabTheme.getTheme(isDark: false),
    chipTheme: AppMiscTheme.getChipTheme(isDark: false),
    dialogTheme: AppMiscTheme.getDialogTheme(isDark: false),

    // Danh sách & Phân cách
    dividerTheme: AppListTheme.getDividerTheme(isDark: false),
    scrollbarTheme: AppListTheme.getScrollbarTheme(isDark: false),

    // Trang trí & Icon
    iconTheme: AppDecorationTheme.getIconTheme(isDark: false),
    tooltipTheme: AppDecorationTheme.getTooltipTheme(isDark: false),

    // Điều hướng
    bottomNavigationBarTheme: AppNavTheme.getBottomNavTheme(isDark: false),
    navigationBarTheme: AppNavTheme.getNavigationBarTheme(isDark: false),

    checkboxTheme: AppSelectionTheme.getCheckboxTheme(isDark: false),
    radioTheme: AppSelectionTheme.getRadioTheme(isDark: false),
    switchTheme: AppSelectionTheme.getSwitchTheme(isDark: false),
    snackBarTheme: AppFeedbackTheme.getSnackBarTheme(isDark: false),
    bottomSheetTheme: AppFeedbackTheme.getBottomSheetTheme(isDark: false),
    badgeTheme: AppFeedbackTheme.getBadgeTheme(isDark: false),
    progressIndicatorTheme: AppSliderTheme.getProgressTheme(isDark: false),
    sliderTheme: AppSliderTheme.getSliderTheme(isDark: false),

    visualDensity: VisualDensity.compact,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    // COLOR SCHEME
    colorScheme: AppColors.darkScheme,

    // TYPOGRAPHY
    textTheme: AppTypography.darkTextTheme,

    // COMPONENT THEMES
    appBarTheme: AppAppBarTheme.getTheme(isDark: true),
    cardTheme: AppCardTheme.getTheme(isDark: true),

    elevatedButtonTheme: AppButtonTheme.getElevatedButtonTheme(isDark: true),
    outlinedButtonTheme: AppButtonTheme.getOutlinedButtonTheme(isDark: true),
    textButtonTheme: AppButtonTheme.getTextButtonTheme(isDark: true),

    inputDecorationTheme: AppInputTheme.getTheme(isDark: true),

    tabBarTheme: AppTabBarTheme.getTheme(isDark: true),
    floatingActionButtonTheme: AppFabTheme.getTheme(isDark: true),
    chipTheme: AppMiscTheme.getChipTheme(isDark: true),
    dialogTheme: AppMiscTheme.getDialogTheme(isDark: true),

    // Danh sách & Phân cách
    dividerTheme: AppListTheme.getDividerTheme(isDark: true),
    scrollbarTheme: AppListTheme.getScrollbarTheme(isDark: true),

    // Trang trí & Icon
    iconTheme: AppDecorationTheme.getIconTheme(isDark: true),
    tooltipTheme: AppDecorationTheme.getTooltipTheme(isDark: true),

    // Điều hướng
    bottomNavigationBarTheme: AppNavTheme.getBottomNavTheme(isDark: true),
    navigationBarTheme: AppNavTheme.getNavigationBarTheme(isDark: true),

    checkboxTheme: AppSelectionTheme.getCheckboxTheme(isDark: true),
    radioTheme: AppSelectionTheme.getRadioTheme(isDark: true),
    switchTheme: AppSelectionTheme.getSwitchTheme(isDark: true),
    snackBarTheme: AppFeedbackTheme.getSnackBarTheme(isDark: true),
    bottomSheetTheme: AppFeedbackTheme.getBottomSheetTheme(isDark: true),
    badgeTheme: AppFeedbackTheme.getBadgeTheme(isDark: true),
    progressIndicatorTheme: AppSliderTheme.getProgressTheme(isDark: true),
    sliderTheme: AppSliderTheme.getSliderTheme(isDark: true),

    visualDensity: VisualDensity.compact,
  );
}
