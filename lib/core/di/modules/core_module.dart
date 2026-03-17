// lib/core/di/modules/core_module.dart

import 'package:clarityrms/config/app_config.dart';
import 'package:clarityrms/core/infrastructure/network/network_info.dart';
import 'package:clarityrms/core/infrastructure/network/interceptors/auth_interceptor.dart';
import 'package:clarityrms/core/router/app_router.dart';
import 'package:clarityrms/core/utils/log_util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clarityrms/core/di/locator.dart';

/// Core DI registrations for core and external dependencies.
///
/// Feature-level implementations (e.g. `AuthLocalDataSource`) should be
/// registered by their feature modules; call `registerAuthInfraDependencies`
/// after feature DI to register infra that depends on those implementations.

void registerCoreAndExternalDependencies() {
  _registerAppConfig();
  _registerExternalClients();
  _registerNetworkInfo();
  _registerRouter();

  Log.d('Core & external dependencies registered (high level).', name: 'DI');
}

void _registerAppConfig() {
  if (!sl.isRegistered<AppConfig>()) {
    sl.registerLazySingleton<AppConfig>(() => AppConfig.getInstance());
  }
}

void _registerExternalClients() {
  // Ensure that Dio and FlutterSecureStorage are present (usually created earlier)
  if (!sl.isRegistered<Dio>()) {
    throw Exception('Dio client chưa được đăng ký!');
  }
  if (!sl.isRegistered<FlutterSecureStorage>()) {
    throw Exception('FlutterSecureStorage chưa được đăng ký!');
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

/// Register auth-related infra that depends on feature-level implementations.
/// Call this after feature DI (e.g. after `registerAuthFeatureDependencies`).
void registerAuthInfraDependencies() {
  // Token Dio (Dio dành riêng cho refresh token)
  final Dio mainDio = sl<Dio>();
  if (!sl.isRegistered<Dio>(instanceName: 'tokenDio')) {
    sl.registerLazySingleton<Dio>(
      instanceName: 'tokenDio',
      () => Dio(mainDio.options),
    );
  }

  // AuthInterceptor depends on feature implementation of AuthLocalDataSource
  if (!sl.isRegistered<AuthInterceptor>()) {
    sl.registerLazySingleton<AuthInterceptor>(
      () => AuthInterceptor(
        authLocalDataSource: sl(),
        tokenDio: sl(instanceName: 'tokenDio'),
        dio: mainDio,
      ),
    );
  }

  // Attach interceptor to main Dio if present
  try {
    if (sl.isRegistered<Dio>()) {
      final Dio existingDio = sl<Dio>();
      final interceptor = sl<AuthInterceptor>();
      final alreadyAdded = existingDio.interceptors
          .where((i) => identical(i, interceptor))
          .isNotEmpty;
      if (!alreadyAdded) {
        existingDio.interceptors.add(interceptor);
        Log.d('AuthInterceptor attached to main Dio.', name: 'DIO');
      }
    }
  } catch (e) {
    Log.e(
      'Lỗi khi thêm AuthInterceptor vào Dio sau khi đăng ký: $e',
      name: 'DIO',
    );
  }
}
