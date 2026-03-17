import 'package:clarityrms/core/di/locator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:clarityrms/core/utils/log_util.dart'; // kept commented for future use if needed

// Uses centralized service locator `sl` (lib/core/di/locator.dart)

/// Lớp chịu trách nhiệm khởi tạo Local Storage
class StorageModule {
  /// Khởi tạo và đăng ký các dịch vụ lưu trữ
  static Future<void> initializeStorage() async {
    // Đăng ký Singleton vào GetIt

    // 1. Khởi tạo và đăng ký FlutterSecureStorage
    if (!sl.isRegistered<FlutterSecureStorage>()) {
      const FlutterSecureStorage secureStorage = FlutterSecureStorage();
      sl.registerLazySingleton<FlutterSecureStorage>(() => secureStorage);
    }

    // [Nếu dùng] 2. Khởi tạo SharedPreferences
    if (!sl.isRegistered<SharedPreferences>()) {
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
    }

    // [Nếu dùng] 3. Khởi tạo Hive
    if (!sl.isRegistered<HiveInterface>()) {
      await Hive.initFlutter();
      sl.registerLazySingleton<HiveInterface>(() => Hive);
    }

    // Storage backends are ready (no verbose log to reduce noise)
  }
}
