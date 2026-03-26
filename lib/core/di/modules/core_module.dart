import 'package:clarityrms/config/app_config.dart';
import 'package:clarityrms/core/constants/app_durations.dart';
import 'package:clarityrms/core/infrastructure/network/api_client_factory.dart';
import 'package:clarityrms/core/infrastructure/network/interceptors/auth_interceptor.dart';
import 'package:clarityrms/core/infrastructure/network/network_info.dart';
import 'package:clarityrms/core/router/app_router.dart';
import 'package:clarityrms/core/utils/log_util.dart';
import 'package:dio/dio.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:clarityrms/core/di/locator.dart';

void registerCoreAndExternalDependencies() {
  _registerAppConfig();
  _registerNetworkInfo();
  _registerRouter();
  _registerNetworkInfrastructure();

  Log.d('Core & external dependencies registered (high level).', name: 'DI');
}

void _registerNetworkInfrastructure() {
  if (!sl.isRegistered<Dio>(instanceName: 'tokenDio')) {
    final authBaseUrl = sl<AppConfig>().authBaseUrl;
    final authHttp = Dio(
      BaseOptions(
        baseUrl: authBaseUrl,
        connectTimeout: AppDurations.apiTimeout,
        receiveTimeout: AppDurations.apiTimeout,
        headers: {'Content-Type': 'application/json'},
      ),
    );

    sl.registerLazySingleton<Dio>(
      instanceName: 'tokenDio',
      () => Dio(authHttp.options),
    );

    if (!sl.isRegistered<AuthInterceptor>()) {
      sl.registerLazySingleton<AuthInterceptor>(
        () => AuthInterceptor(
          authLocalDataSource: sl(),
          tokenDio: sl(instanceName: 'tokenDio'),
          dio: authHttp,
        ),
      );
    }
  }

  if (!sl.isRegistered<ApiClientFactory>()) {
    sl.registerLazySingleton<ApiClientFactory>(
      () => ApiClientFactory(authInterceptor: sl<AuthInterceptor>()),
    );
  }

  Log.d('Network infrastructure registered.', name: 'DI');
}

void _registerAppConfig() {
  if (!sl.isRegistered<AppConfig>()) {
    sl.registerLazySingleton<AppConfig>(() => AppConfig.getInstance());
  }
}

void _registerNetworkInfo() {
  if (!sl.isRegistered<Connectivity>()) {
    sl.registerLazySingleton<Connectivity>(() => Connectivity());
  }
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  }
}

void _registerRouter() {
  if (!sl.isRegistered<AppRouter>()) {
    sl.registerLazySingleton<AppRouter>(() => AppRouter());
  }
}
