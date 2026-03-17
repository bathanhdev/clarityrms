import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';

class AppTypography {
  AppTypography._();

  // Font family: kiểu chữ cơ sở dùng BeVietnamPro
  static final TextStyle _baseInter = GoogleFonts.beVietnamPro();

  // Display - chữ rất lớn
  static final TextStyle displayLarge = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeDisplayLarge,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.25,
  );

  static final TextStyle displayMedium = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeDisplayMedium,
    fontWeight: FontWeight.w400,
  );

  static final TextStyle displaySmall = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeDisplaySmall,
    fontWeight: FontWeight.w400,
  );

  // Headline - tiêu đề lớn
  static final TextStyle headlineLarge = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeHeadlineLarge,
    fontWeight: FontWeight.bold,
  );

  static final TextStyle headlineMedium = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeHeadlineMedium,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle headlineSmall = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeHeadlineSmall,
    fontWeight: FontWeight.w600,
  );

  // Title - tiêu đề trung (AppBar, Card)
  static final TextStyle titleLarge = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeTitleLarge,
    fontWeight: FontWeight.w600,
  );

  static final TextStyle titleMedium = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeTitleMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.15,
  );

  static final TextStyle titleSmall = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeTitleSmall,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.1,
  );

  // Body - chữ nội dung
  static final TextStyle bodyLarge = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeBodyLarge,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.5,
  );

  static final TextStyle bodyMedium = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeBodyMedium,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.25,
  );

  static final TextStyle bodySmall = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeBodySmall,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.4,
  );

  // Label - chữ nhãn (Button, Badge)
  static final TextStyle labelLarge = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeLabelLarge,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.1,
  );

  static final TextStyle labelMedium = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeLabelMedium,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  static final TextStyle labelSmall = _baseInter.copyWith(
    fontSize: AppDimensions.fontSizeLabelSmall,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.5,
  );

  // Tạo `TextTheme`

  static TextTheme get lightTextTheme {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: Colors.black87),
      displayMedium: displayMedium.copyWith(color: Colors.black87),
      displaySmall: displaySmall.copyWith(color: Colors.black87),
      headlineLarge: headlineLarge.copyWith(color: Colors.black),
      headlineMedium: headlineMedium.copyWith(color: Colors.black87),
      headlineSmall: headlineSmall.copyWith(color: Colors.black87),
      titleLarge: titleLarge.copyWith(color: Colors.black),
      titleMedium: titleMedium.copyWith(color: Colors.black87),
      titleSmall: titleSmall.copyWith(color: Colors.black87),
      bodyLarge: bodyLarge.copyWith(color: Colors.black87),
      bodyMedium: bodyMedium.copyWith(color: Colors.black87),
      bodySmall: bodySmall.copyWith(color: Colors.black54),
      labelLarge: labelLarge.copyWith(color: Colors.black),
      labelMedium: labelMedium.copyWith(color: Colors.black87),
      labelSmall: labelSmall.copyWith(color: Colors.black54),
    );
  }

  static TextTheme get darkTextTheme {
    return TextTheme(
      displayLarge: displayLarge.copyWith(color: Colors.white),
      displayMedium: displayMedium.copyWith(color: Colors.white),
      displaySmall: displaySmall.copyWith(color: Colors.white),
      headlineLarge: headlineLarge.copyWith(color: Colors.white),
      headlineMedium: headlineMedium.copyWith(color: Colors.white),
      headlineSmall: headlineSmall.copyWith(color: Colors.white),
      titleLarge: titleLarge.copyWith(color: Colors.white),
      titleMedium: titleMedium.copyWith(color: Colors.white),
      titleSmall: titleSmall.copyWith(color: Colors.white),
      bodyLarge: bodyLarge.copyWith(color: Colors.white),
      bodyMedium: bodyMedium.copyWith(color: Colors.white),
      bodySmall: bodySmall.copyWith(color: Colors.white70),
      labelLarge: labelLarge.copyWith(color: Colors.white),
      labelMedium: labelMedium.copyWith(color: Colors.white),
      labelSmall: labelSmall.copyWith(color: Colors.white70),
    );
  }
}
