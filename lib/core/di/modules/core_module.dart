// lib/core/di/modules/core_module.dart

import 'package:clarityrms/config/app_config.dart';
import 'package:clarityrms/core/infrastructure/network/network_info.dart';
import 'package:clarityrms/core/infrastructure/network/interceptors/auth_interceptor.dart';
import 'package:clarityrms/core/router/app_router.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:clarityrms/core/utils/log_util.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:clarityrms/core/di/locator.dart';

/// Đăng ký tất cả các phụ thuộc Core, External và các Infra/Data Source cơ sở.
void registerCoreAndExternalDependencies() {
  // Begin registering core & external dependencies

  // 1. APP CONFIG
  if (!sl.isRegistered<AppConfig>()) {
    sl.registerLazySingleton<AppConfig>(() => AppConfig.getInstance());
  }

  // 2. NETWORKING (Dio) & 3. SECURE STORAGE
  if (!sl.isRegistered<Dio>()) {
    throw Exception("Dio client chưa được đăng ký!");
  }
  if (!sl.isRegistered<FlutterSecureStorage>()) {
    throw Exception("FlutterSecureStorage chưa được đăng ký!");
  }

  // 3. NETWORK INFO
  if (!sl.isRegistered<Connectivity>()) {
    sl.registerLazySingleton<Connectivity>(() => Connectivity());
  }
  if (!sl.isRegistered<NetworkInfo>()) {
    sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
  }

  // Đăng ký AppRouter Singleton
  if (!sl.isRegistered<AppRouter>()) {
    sl.registerLazySingleton<AppRouter>(() => AppRouter());
  }

  // ==========================================================
  // PHỤ THUỘC CỦA AUTH INFRASTRUTURE (Cần thiết cho Dio Interceptor)
  // ==========================================================

  // A. Local Data Source (Cần thiết cho Interceptor đọc token)
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(secureStorage: sl()),
  );

  // B. Token Dio (Dio Dành Riêng cho Refresh Token, không có Interceptor)
  final Dio mainDio = sl<Dio>();
  sl.registerLazySingleton<Dio>(
    instanceName: 'tokenDio',
    () => Dio(mainDio.options), // Dùng chung options
  );
  Log.d('Token Dio registered.', name: 'DI');
  // C. Auth Interceptor (Cần thiết cho Dio chính)
  sl.registerLazySingleton<AuthInterceptor>(
    () => AuthInterceptor(
      authLocalDataSource: sl(),
      tokenDio: sl(instanceName: 'tokenDio'),
      dio: mainDio,
    ),
  );
  Log.d('AuthInterceptor registered.', name: 'DI');
  // Nếu Dio đã được khởi tạo và đăng ký trước đó, đảm bảo thêm interceptor này vào Dio
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

  // Core & External registration complete
}
