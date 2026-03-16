import 'package:flutter/material.dart';

/// Chứa các giá trị Spacing, Padding, Margin sử dụng hệ thống tỷ lệ 8x.
class AppSpacing {
  AppSpacing._();

  // ==========================================================
  // 1. CÁC HẰNG SỐ GIÁ TRỊ CƠ SỞ
  // ==========================================================
  static const double none = 0.0;
  static const double xxs = 2.0;
  static const double xs = 4.0;
  static const double sm = 8.0; // Small
  static const double s12 = 12.0; // Bổ sung cho Padding linh hoạt
  static const double md = 16.0; // Medium (Tiêu chuẩn màn hình)
  static const double lg = 24.0; // Large
  static const double xl = 32.0; // Extra Large
  static const double xxl = 48.0;
  static const double xxxl = 64.0;

  // ==========================================================
  // 2. WIDGET TIỆN ÍCH CHO SPACING (SizedBox)
  // ==========================================================

  // Chiều Dọc (Vertical Space)
  static const Widget verticalSpaceXs = SizedBox(height: xs);
  static const Widget verticalSpaceSm = SizedBox(height: sm);
  static const Widget verticalSpaceMd = SizedBox(height: md);
  static const Widget verticalSpaceLg = SizedBox(height: lg);
  static const Widget verticalSpaceXl = SizedBox(height: xl);

  // Chiều Ngang (Horizontal Space)
  static const Widget horizontalSpaceXs = SizedBox(width: xs);
  static const Widget horizontalSpaceSm = SizedBox(width: sm);
  static const Widget horizontalSpaceMd = SizedBox(width: md);
  static const Widget horizontalSpaceLg = SizedBox(width: lg);
  static const Widget horizontalSpaceXl = SizedBox(width: xl);

  // ==========================================================
  // 3. CÁC GIÁ TRỊ PADDING VÀ MARGIN (EdgeInsets)
  // ==========================================================

  // A. All Sides
  static const EdgeInsets paddingAllXs = EdgeInsets.all(xs);
  static const EdgeInsets paddingAllSm = EdgeInsets.all(sm);
  static const EdgeInsets paddingAllMd = EdgeInsets.all(md);
  static const EdgeInsets paddingAllLg = EdgeInsets.all(lg);

  // Semantic Aliases
  static const EdgeInsets screenPadding = paddingAllMd;
  static const EdgeInsets cardPadding = paddingAllMd;

  // B. Symmetric
  static const EdgeInsets paddingSymmetricMdSm = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  // Padding chuyên dụng cho Input/Button để đảm bảo chiều cao đồng bộ
  static const EdgeInsets paddingSymmetricMd = EdgeInsets.symmetric(
    horizontal: md,
    vertical: md,
  );

  static const EdgeInsets paddingSymmetricLgMd = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  // Horizontal Only
  static const EdgeInsets paddingHorizontalSm = EdgeInsets.symmetric(
    horizontal: sm,
  );
  static const EdgeInsets paddingHorizontalMd = EdgeInsets.symmetric(
    horizontal: md,
  );
  static const EdgeInsets paddingHorizontalLg = EdgeInsets.symmetric(
    horizontal: lg,
  );

  // Vertical Only
  static const EdgeInsets paddingVerticalXs = EdgeInsets.symmetric(
    vertical: xs,
  );
  static const EdgeInsets paddingVerticalSm = EdgeInsets.symmetric(
    vertical: sm,
  );
  static const EdgeInsets paddingVerticalMd = EdgeInsets.symmetric(
    vertical: md,
  );
  static const EdgeInsets paddingVerticalLg = EdgeInsets.symmetric(
    vertical: lg,
  );

  // C. Only / Combinations
  static const EdgeInsets paddingTopMd = EdgeInsets.only(top: md);
  static const EdgeInsets paddingTopLg = EdgeInsets.only(top: lg);
  static const EdgeInsets paddingBottomMd = EdgeInsets.only(bottom: md);
  static const EdgeInsets paddingBottomLg = EdgeInsets.only(bottom: lg);

  // Tổ hợp cho Form fields
  static const EdgeInsets paddingInputLabel = EdgeInsets.only(bottom: xs);
}
