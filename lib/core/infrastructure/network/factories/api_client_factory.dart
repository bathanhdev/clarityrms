import 'package:clarityrms/core/infrastructure/network/network.dart';
// auth interceptor creation is handled via injected factory when available.
import 'package:clarityrms/core/constants/app_durations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Factory phục vụ việc tạo danh sách interceptor cho mọi ApiClient.
///
/// Khi hệ thống hiện tại yêu cầu token/refresh, `AuthInterceptor` sẽ được
/// tạo per-Dio (prefer factory from DI) để tránh replay trên sai baseUrl.
class ApiClientFactory {
  final AuthInterceptor Function(Dio)? authInterceptorFactory;

  ApiClientFactory({this.authInterceptorFactory});

  List<Interceptor>? getInterceptors({bool authRequired = true, Dio? dio}) {
    final interceptors = <Interceptor>[];

    if (authRequired && authInterceptorFactory != null && dio != null) {
      interceptors.add(authInterceptorFactory!(dio));
    }

    return interceptors.isEmpty ? null : interceptors;
  }

  Dio createDio({
    required String baseUrl,
    bool authRequired = true,
    List<Interceptor>? additionalInterceptors,
  }) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: 'application/json',
        connectTimeout: AppDurations.apiTimeout,
        receiveTimeout: AppDurations.apiTimeout,
        sendTimeout: AppDurations.apiTimeout,
      ),
    );

    // Match ApiClient: add debug LogInterceptor for consistency
    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: false,
          requestHeader: false,
          requestBody: false,
          responseHeader: false,
          responseBody: false,
          error: true,
        ),
      );
    }

    // Build interceptors (auth interceptor via DI factory or default) and attach.
    final built = getInterceptors(authRequired: authRequired, dio: dio);
    if (built != null) {
      dio.interceptors.addAll(built);
    }

    if (additionalInterceptors != null && additionalInterceptors.isNotEmpty) {
      dio.interceptors.addAll(additionalInterceptors);
    }

    return dio;
  }

  /// Create an `ApiClient` backed by a Dio configured the same way as
  /// `createDio(...)`. This is a convenience for callers that expect an
  /// `ApiClient` instance instead of raw `Dio`.
  ApiClient createApiClient({
    required String baseUrl,
    bool authRequired = true,
    List<Interceptor>? additionalInterceptors,
  }) {
    final dio = createDio(
      baseUrl: baseUrl,
      authRequired: authRequired,
      additionalInterceptors: additionalInterceptors,
    );
    return ApiClient.fromDio(dio);
  }
}
