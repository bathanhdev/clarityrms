import 'package:clarityrms/core/di/modules/auth_feature_module.dart';
import 'package:clarityrms/core/di/modules/core_module.dart';
import 'package:clarityrms/core/di/modules/global_state_module.dart';
import 'package:clarityrms/core/utils/log_util.dart';

/// Hàm chính để đăng ký tất cả các phụ thuộc
Future<void> configureDependencies() async {
  // 1. CORE & EXTERNAL: Phải được đăng ký trước tiên
  // (Đảm bảo Dio, Storage, NetworkInfo sẵn sàng)
  registerCoreAndExternalDependencies();

  // 2. FEATURE DEPENDENCIES: Đăng ký các Repository và Use Case
  registerAuthFeatureDependencies();

  // 3. GLOBAL STATE: Đăng ký các Cubit toàn cục (Phụ thuộc vào Core & Feature)
  registerGlobalStateDependencies();
  Log.d('Dependency injection completed.', name: 'DI');
}
