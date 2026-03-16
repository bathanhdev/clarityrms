class AppConstants {
  AppConstants._();

  // Thông tin ứng dụng
  static const String appName = 'ClarityRMS';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // Định dạng ngày tháng (Dùng chung toàn app)
  static const String dateFormat = 'dd/MM/yyyy';
  static const String dateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String timeFormat = 'HH:mm';

  // Giá trị mặc định (Pagination)
  static const int defaultPageSize = 20;
  static const int firstPageNumber = 1;

  // Cấu hình Database nội bộ (nếu có dùng SQLite/Isar)
  static const String dbName = 'clarity_rms.db';
  static const int dbVersion = 1;
}
