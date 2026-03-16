import 'package:flutter/material.dart';

/// Class tiện ích để quản lý các thông số và tính toán liên quan đến kích thước
/// màn hình và thiết kế responsive.
class ScreenUtil {
  ScreenUtil._(); // Ngăn chặn khởi tạo

  // ==========================================================
  // 1. CÁC THÔNG SỐ RESPONSIVE (Breakpoints)
  // Các kích thước chuẩn để phân biệt Mobile, Tablet, Desktop
  // ==========================================================

  /// Chiều rộng tối đa cho thiết bị di động (Mobile)
  static const double mobileMaxWidth = 600.0;

  /// Chiều rộng tối đa cho máy tính bảng (Tablet)
  static const double tabletMaxWidth = 1024.0;

  /// Kích thước lớn hơn 1024.0 được xem là Desktop

  // ==========================================================
  // 2. KHỞI TẠO VÀ TRUY CẬP (Cần Context hoặc Global Key)
  // ==========================================================

  static late BuildContext _context;

  /// Khởi tạo ScreenUtil bằng cách cung cấp BuildContext.
  /// Thường được gọi ở đầu MainApp hoặc ở một Widget Wrapper.
  static void init(BuildContext context) {
    _context = context;
  }

  /// Trả về MediaQueryData hiện tại
  static MediaQueryData get mediaQuery => MediaQuery.of(_context);

  /// Trả về chiều rộng màn hình hiện tại
  static double get width => mediaQuery.size.width;

  /// Trả về chiều cao màn hình hiện tại
  static double get height => mediaQuery.size.height;

  /// Trả về tỷ lệ pixel của thiết bị
  static double get pixelRatio => mediaQuery.devicePixelRatio;

  /// Trả về khoảng cách an toàn từ trên xuống (ví dụ: tai thỏ)
  static double get safeAreaTop => mediaQuery.padding.top;

  /// Trả về khoảng cách an toàn từ dưới lên (ví dụ: thanh điều hướng Home)
  static double get safeAreaBottom => mediaQuery.padding.bottom;

  // ==========================================================
  // 3. CÁC HÀM KIỂM TRA LOẠI THIẾT BỊ
  // ==========================================================

  /// Kiểm tra xem màn hình hiện tại có phải là Mobile không.
  static bool get isMobile => width <= mobileMaxWidth;

  /// Kiểm tra xem màn hình hiện tại có phải là Tablet không.
  static bool get isTablet => width > mobileMaxWidth && width <= tabletMaxWidth;

  /// Kiểm tra xem màn hình hiện tại có phải là Desktop không.
  static bool get isDesktop => width > tabletMaxWidth;

  /// Tương tự với Orientation
  static bool get isLandscape =>
      mediaQuery.orientation == Orientation.landscape;

  // ==========================================================
  // 4. HÀM TÍNH TOÁN KÍCH THƯỚC ĐÁP ỨNG (Responsive Scaling)
  // ==========================================================

  /// Tính toán chiều rộng dựa trên tỷ lệ màn hình.
  /// Ví dụ: `widthScale(0.5)` sẽ là 50% chiều rộng màn hình.
  static double widthScale(double percentage) {
    return width * percentage;
  }

  /// Tính toán chiều cao dựa trên tỷ lệ màn hình.
  static double heightScale(double percentage) {
    return height * percentage;
  }
}
