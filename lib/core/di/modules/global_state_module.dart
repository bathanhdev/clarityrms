import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/global_state/network/network_cubit.dart';
import 'package:clarityrms/core/di/locator.dart';

/// Đăng ký tất cả các Cubit/BLoC quản lý trạng thái toàn cục.
void registerGlobalStateDependencies() {
  // Register global state cubits and blocs

  // 1. NetworkCubit (Phụ thuộc vào NetworkInfo)
  if (!sl.isRegistered<NetworkCubit>()) {
    sl.registerLazySingleton<NetworkCubit>(
      () => NetworkCubit(networkInfo: sl()),
    );
  }

  // 2. AuthCubit (Phụ thuộc vào Use Cases)
  sl.registerLazySingleton<AuthCubit>(
    () => AuthCubit(loginUser: sl(), checkAuthStatus: sl(), logoutUser: sl()),
  );

  // Global state registrations complete
}
