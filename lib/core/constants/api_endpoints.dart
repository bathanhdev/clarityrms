/// Lớp chứa tất cả các đường dẫn (endpoints) API
/// được sử dụng trong ứng dụng dưới dạng hằng số tĩnh.
class ApiEndpoints {
  ApiEndpoints._();
  // ==========================================================
  // PHẦN BASE URL (Thường được lấy từ AppConfig, nhưng giữ ở đây để tham khảo)
  // static const String baseUrl = 'https://api.clarityrms.com/v1';
  // ==========================================================

  // --- 1. AUTH FEATURE ---
  static const String auth = '/auth';

  /// POST: /auth/login
  static const String login = '$auth/login';

  /// POST: /auth/refresh
  static const String refreshToken = '$auth/refresh';

  /// POST: /auth/logout
  static const String logout = '$auth/logout';

  // --- 2. USER FEATURE ---
  static const String users = '/users';

  /// GET: /users/profile
  static const String userProfile = '$users/profile';

  // --- 3. PRODUCT FEATURE ---
  static const String products = '/products';

  /// GET: /products
  static const String listProducts = products;
}
