import 'package:clarityrms/core/constants/app_durations.dart';
import 'package:clarityrms/core/utils/log_util.dart';
import 'package:dio/dio.dart';
import 'package:clarityrms/core/di/locator.dart';
import 'package:flutter/foundation.dart';

// Uses the centralized service locator `sl` (lib/core/di/locator.dart)

/// Lớp chịu trách nhiệm khởi tạo và cấu hình Dio Client
class DioModule {
  /// Tạo một Dio client độc lập theo baseUrl.
  static Dio createDio(
    String baseUrl, {
    int? connectTimeoutMs,
    int? receiveTimeoutMs,
    int? sendTimeoutMs,
    List<Interceptor>? interceptors,
  }) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: Duration(
        milliseconds:
            connectTimeoutMs ?? AppDurations.apiTimeout.inMilliseconds,
      ),
      receiveTimeout: Duration(
        milliseconds:
            receiveTimeoutMs ?? AppDurations.apiTimeout.inMilliseconds,
      ),
      sendTimeout: Duration(
        milliseconds: sendTimeoutMs ?? AppDurations.apiTimeout.inMilliseconds,
      ),
      headers: {'Content-Type': 'application/json'},
    );

    final dio = Dio(options);

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          requestBody: false,
          responseBody: false,
          requestHeader: false,
          responseHeader: false,
          request: false,
          error: true,
        ),
      );
    }

    if (interceptors != null && interceptors.isNotEmpty) {
      dio.interceptors.addAll(interceptors);
    }

    return dio;
  }

  /// Dùng cho legacy setup toàn cục (AppInitializer).
  ///
  /// Không gắn AuthInterceptor tự động, để tránh leak behavior toàn system.
  static void setupDio(String baseUrl) {
    if (sl.isRegistered<Dio>()) {
      Log.w('Dio client đã được đăng ký trước đó. Bỏ qua khởi tạo.');
      return;
    }

    final dio = createDio(baseUrl);
    sl.registerLazySingleton<Dio>(() => dio);
  }
}
