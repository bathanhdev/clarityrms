import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/global_state/network/network_cubit.dart';
import 'package:clarityrms/core/global_state/theme/theme_cubit.dart';
import 'package:clarityrms/core/di/locator.dart';

void registerGlobalStateDependencies() {
  if (!sl.isRegistered<NetworkCubit>()) {
    sl.registerLazySingleton<NetworkCubit>(
      () => NetworkCubit(networkInfo: sl()),
    );
  }

  if (!sl.isRegistered<AuthCubit>()) {
    sl.registerLazySingleton<AuthCubit>(
      () => AuthCubit(
        loginUser: sl(),
        socialLoginUser: sl(),
        checkAuthStatus: sl(),
        logoutUser: sl(),
      ),
    );
  }

  if (!sl.isRegistered<ThemeCubit>()) {
    sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit(prefs: sl()));
  }
}
