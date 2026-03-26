import 'package:clarityrms/core/di/injection_container.dart';
import 'package:clarityrms/core/infrastructure/storage/storage_module.dart';
import 'package:clarityrms/core/utils/log_util.dart';

/// Lớp chịu trách nhiệm khởi tạo tất cả các dịch vụ và phụ thuộc cốt lõi trước khi ứng dụng chạy.
class AppInitializer {
  Future<void> init() async {
    // 1. Khởi tạo Local Storage (SecureStorage)
    await StorageModule.initializeStorage();

    // 2. Đăng ký tất cả các phụ thuộc
    await configureDependencies();

    // App initialization complete
    Log.d('App initialization complete.', name: 'INIT');
  }
}
