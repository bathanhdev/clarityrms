import 'package:clarityrms/core/constants/app_durations.dart';
import 'package:clarityrms/core/infrastructure/network/interceptors/auth_interceptor.dart';
import 'package:clarityrms/core/utils/log_util.dart';
import 'package:dio/dio.dart';
import 'package:clarityrms/core/di/locator.dart';
import 'package:flutter/foundation.dart';

// Uses the centralized service locator `sl` (lib/core/di/locator.dart)

/// Lớp chịu trách nhiệm khởi tạo và cấu hình Dio Client
class DioModule {
  /// Khởi tạo Dio Client với Base URL và các Interceptors
  static void setupDio(String baseUrl) {
    if (sl.isRegistered<Dio>()) {
      Log.w('Dio client đã được đăng ký trước đó. Bỏ qua khởi tạo.');
      return;
    }

    // 1. Tạo Base Options
    final baseOptions = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: AppDurations.apiTimeout, // 15 giây
      receiveTimeout: AppDurations.apiTimeout, // 15 giây
      headers: {'Content-Type': 'application/json'},
    );

    // 2. Tạo Dio Instance
    final Dio dio = Dio(baseOptions);

    // 3. Thêm Interceptors

    // A. Logging Interceptor (Chỉ trong môi trường Dev)
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          requestHeader: false,
          responseHeader: false,
          request: false,
          error: true,
          // Chỉ log thông tin quan trọng để tránh làm lộn xộn console
          // logPrint: (obj) => Log.d(obj.toString(), name: 'DIO'),
        ),
      );
    }

    // 4. Đăng ký Dio Instance vào GetIt
    // Sử dụng LazySingleton để chỉ có một instance Dio duy nhất
    sl.registerLazySingleton<Dio>(() => dio);

    // Attach AuthInterceptor if it is already registered. If the
    // interceptor is registered later, `registerAuthInfraDependencies`
    // will attach it as a fallback.
    try {
      if (sl.isRegistered<AuthInterceptor>()) {
        final interceptor = sl<AuthInterceptor>();
        final alreadyAdded = dio.interceptors
            .where((i) => identical(i, interceptor))
            .isNotEmpty;
        if (!alreadyAdded) {
          dio.interceptors.add(interceptor);
          Log.d('AuthInterceptor attached to main Dio.', name: 'DIO');
        }
      }
    } catch (e) {
      Log.e('Lỗi khi thêm AuthInterceptor vào Dio: $e', name: 'DIO');
    }
  }
}
