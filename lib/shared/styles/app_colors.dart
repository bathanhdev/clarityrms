import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Raw colors (Tailwind-like palette)
  // Brand blue (Brightened further per request)
  static const Color primary = Color(0xFF2A78FF);
  static const Color primaryLight = Color(0xFF86C8FF);
  static const Color primaryDark = Color(0xFF0A59B0);
  static const Color primaryLowSat = Color(
    0xFFBFE0FF,
  ); // Lighter blue for dark mode variants

  static const Color secondary = Color(0xFF06D6A0); // green accent
  static const Color secondaryDark = Color(0xFF05A67A);

  static const Color error = Color(0xFFEF4444); // Red 500
  static const Color success = Color(0xFF22C55E); // Green 500
  static const Color warning = Color(0xFFF59E0B); // Amber 500
  static const Color info = Color(0xFF3B82F6); // Blue 500

  // Light color palette
  static const Color background = Color(0xFFF8FAFC); // Slate 50
  static const Color surface = Colors.white;
  static const Color textPrimary = Color(0xFF0F172A); // Slate 900
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color outline = Color(0xFFE2E8F0); // Slate 200

  // Dark color palette
  static const Color darkBackground = Color(0xFF020617); // Slate 950
  static const Color darkSurface = Color(0xFF0F172A); // Slate 900
  static const Color darkSurfaceL2 = Color(0xFF1E293B); // Slate 800
  static const Color darkOnSurface = Color(0xFFF1F5F9); // Slate 100
  static const Color darkTextSecondary = Color(0xFF94A3B8); // Slate 400
  static const Color darkOutline = Color(0xFF334155); // Slate 700

  // Standard shadow tone used across the UI (subtle)
  static const Color shadow = Color(0x0F000000);

  // Color schemes

  /// ColorScheme for Light Mode
  static const ColorScheme lightScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    onPrimary: Colors.white,
    primaryContainer: Color(0xFFE0E7FF),
    onPrimaryContainer: primaryDark,

    // Success dùng làm Secondary
    secondary: secondary,
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE6FBF0),
    onSecondaryContainer: Color(0xFF064E3B),

    // Warning dùng làm Tertiary
    tertiary: warning,
    onTertiary: Colors.white,
    tertiaryContainer: Color(0xFFFEF3C7),
    onTertiaryContainer: Color(0xFF92400E),

    surface: surface,
    onSurface: textPrimary,
    // SurfaceContainer (L2) cho nút Cancel/Secondary
    surfaceContainer: Color(0xFFF1F5F9),
    onSurfaceVariant: textSecondary,

    error: error,
    onError: Colors.white,
    outline: outline,
    shadow: Color(0x0F000000),
    inverseSurface: darkSurface,
    onInverseSurface: Colors.white,
    inversePrimary: primaryLight,
  );

  /// ColorScheme for Dark Mode
  static const ColorScheme darkScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primaryLowSat,
    onPrimary: Color(0xFF052033),
    primaryContainer: primaryDark,
    onPrimaryContainer: Color(0xFFE6F6FF),

    // Success dùng làm Secondary
    secondary: Color(0xFF4ADE80),
    onSecondary: Color(0xFF064E3B),
    secondaryContainer: Color(0xFF14532D),
    onSecondaryContainer: Color(0xFFBBF7D0),

    // Warning dùng làm Tertiary
    tertiary: Color(0xFFFBBF24),
    onTertiary: Color(0xFF451A03),
    tertiaryContainer: Color(0xFF78350F),
    onTertiaryContainer: Color(0xFFFEF3C7),

    surface: darkSurface,
    onSurface: darkOnSurface,
    // SurfaceContainer (L2) cho nút Cancel/Secondary
    surfaceContainer: darkSurfaceL2,
    onSurfaceVariant: darkTextSecondary,

    error: Color(0xFFFB7185),
    onError: Color(0xFF4C0519),
    outline: darkOutline,
    shadow: Colors.black,
    inverseSurface: Color(0xFFF1F5F9),
    onInverseSurface: darkBackground,
    inversePrimary: primary,
  );
}
