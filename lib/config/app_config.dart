import 'package:flutter/foundation.dart';
import 'env.dart';
import 'package:clarityrms/core/utils/log_util.dart';

enum Environment { dev, prod }

class AppConfig {
  // 1. Thuộc tính Singleton (Instance)
  static AppConfig? _instance;

  // 2. Thuộc tính cấu hình môi trường
  final Environment environment;
  final String baseUrl;
  final String firebaseApiKey;

  // 3. Private Constructor
  const AppConfig._({
    required this.environment,
    required this.baseUrl,
    required this.firebaseApiKey,
  });

  // 4. Factory để khởi tạo hoặc trả về instance đã có
  static AppConfig getInstance() {
    // Nếu _instance chưa được khởi tạo, nó sẽ throw lỗi.
    // Việc khởi tạo phải được thực hiện trong AppInitializer hoặc main.dart.
    if (_instance == null) {
      throw Exception(
        "AppConfig must be initialized before calling getInstance.",
      );
    }
    return _instance!;
  }

  // 5. Hàm khởi tạo và Thiết lập môi trường
  static void initialize({required Environment environment}) {
    // Ngăn chặn khởi tạo lại
    if (_instance != null) {
      debugPrint("AppConfig has already been initialized.");
      return;
    }

    final String finalBaseUrl;
    final String finalFirebaseApiKey;

    switch (environment) {
      case Environment.dev:
        // Sử dụng các hằng số đã được generate bởi Envied (EnvDev)
        finalBaseUrl = EnvDev.baseUrl;
        finalFirebaseApiKey = EnvDev.firebaseApiKey;
        Log.d('App environment: DEV', name: 'CONFIG');
        break;

      case Environment.prod:
        // Sử dụng các hằng số đã được generate bởi Envied (EnvProd)
        finalBaseUrl = EnvProd.baseUrl;
        finalFirebaseApiKey = EnvProd.firebaseApiKey;
        Log.d('App environment: PROD', name: 'CONFIG');
        break;
    }

    // Khởi tạo Singleton Instance
    _instance = AppConfig._(
      environment: environment,
      baseUrl: finalBaseUrl,
      firebaseApiKey: finalFirebaseApiKey,
    );
    Log.d('Resolved baseUrl: $finalBaseUrl', name: 'CONFIG');
  }

  // 6. Phương thức tiện ích
  bool get isProduction => environment == Environment.prod;
  bool get isDevelopment => environment == Environment.dev;
}
