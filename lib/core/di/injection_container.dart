import 'package:clarityrms/core/di/modules/features/auth/auth_feature_module.dart';
import 'package:clarityrms/core/di/modules/core/core_module.dart';
import 'package:clarityrms/core/di/modules/state/global_state_module.dart';
import 'package:clarityrms/core/di/modules/features/user/user_feature_module.dart';
import 'package:clarityrms/core/utils/log_util.dart';

Future<void> configureDependencies() async {
  // 0. Core and external dependencies (network infrastructure, config, router)
  registerCoreAndExternalDependencies();

  // 1. AUTH MODULE
  registerAuthModuleDependencies();

  // 2. USER FEATURE DEPENDENCIES
  registerUserModuleDependencies();

  Log.d('Feature dependencies registered.', name: 'DI');

  // 3. GLOBAL STATE: Đăng ký các Cubit toàn cục (Phụ thuộc vào Core & Feature)
  registerGlobalStateDependencies();
  Log.d('Dependency injection completed.', name: 'DI');
}
