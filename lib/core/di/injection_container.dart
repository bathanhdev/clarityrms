import 'package:clarityrms/core/di/modules/auth_feature_module.dart';
import 'package:clarityrms/core/di/modules/core_module.dart';
import 'package:clarityrms/core/di/modules/global_state_module.dart';
import 'package:clarityrms/core/di/modules/user_feature_module.dart';
import 'package:clarityrms/core/utils/log_util.dart';

Future<void> configureDependencies() async {
  // 0. Core and external dependencies (network infrastructure, config, router)
  registerCoreAndExternalDependencies();

  // 1. AUTH MODULE (Auth feature + Auth infra chung)
  registerAuthModuleDependencies();

  // 2. USER FEATURE DEPENDENCIES
  registerUserFeatureDependencies();

  Log.d('Feature dependencies registered.', name: 'DI');

  // 3. GLOBAL STATE: Đăng ký các Cubit toàn cục (Phụ thuộc vào Core & Feature)
  registerGlobalStateDependencies();
  Log.d('Dependency injection completed.', name: 'DI');
}
