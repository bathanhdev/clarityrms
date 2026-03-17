import 'package:clarityrms/config/app_config.dart';
import 'package:clarityrms/core/di/injection_container.dart';
import 'package:clarityrms/core/infrastructure/network/dio_module.dart';
import 'package:clarityrms/core/infrastructure/storage/storage_module.dart';
import 'package:clarityrms/core/utils/log_util.dart';

/// Lớp chịu trách nhiệm khởi tạo tất cả các dịch vụ và phụ thuộc cốt lõi trước khi ứng dụng chạy.
class AppInitializer {
  Future<void> init() async {
    // 1. Lấy AppConfig Instance
    final appConfig = AppConfig.getInstance();

    // 2. Khởi tạo Local Storage (SecureStorage)
    await StorageModule.initializeStorage();

    // 3. Cấu hình HTTP Client (Dio) - Sử dụng Base URL từ AppConfig
    DioModule.setupDio(appConfig.baseUrl);

    // 4. Đăng ký tất cả các phụ thuộc
    await configureDependencies();

    // App initialization complete
    Log.d('App initialization complete.', name: 'INIT');
  }
}
