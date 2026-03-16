import 'package:flutter/material.dart';

/// Chứa các giá trị Border Radius cố định (độ cong góc) cho toàn bộ ứng dụng.
class AppRadius {
  AppRadius._();
  // ==========================================================
  // 1. CÁC HẰNG SỐ GIÁ TRỊ CƠ SỞ (Đơn vị thô)
  // ==========================================================
  static const double none = 0.0;
  static const double sm = 4.0; // Rất nhỏ (Thường cho Input Field)
  static const double md = 8.0; // Trung bình (Thường cho Card, Button)
  static const double lg = 12.0; // Lớn
  static const double xl = 16.0;
  static const double circular = 1000.0; // Dùng để tạo hình tròn/Pill

  // ==========================================================
  // 2. BORDER RADIUS OBJECTS (Dùng trực tiếp)
  // ==========================================================

  // Dạng BorderRadius.circular()
  static const BorderRadius borderRadiusSm = BorderRadius.all(
    Radius.circular(sm),
  );
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(md),
  );
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(lg),
  );
  static const BorderRadius borderRadiusCircular = BorderRadius.all(
    Radius.circular(circular),
  );

  // Dạng ShapeBorder (Dùng cho ButtonTheme, Card, v.v.)
  static RoundedRectangleBorder get roundedRectangleBorderSm =>
      RoundedRectangleBorder(borderRadius: borderRadiusSm);

  static RoundedRectangleBorder get roundedRectangleBorderMd =>
      RoundedRectangleBorder(borderRadius: borderRadiusMd);

  static RoundedRectangleBorder get roundedRectangleBorderLg =>
      RoundedRectangleBorder(borderRadius: borderRadiusLg);
}
