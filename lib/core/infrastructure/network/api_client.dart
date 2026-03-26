import 'dart:convert';

import 'package:clarityrms/core/constants/app_durations.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Base client cho mọi microservice API.
///
/// Dùng chung để tách biệt baseUrl và interceptor riêng biệt theo service.
class ApiClient {
  final Dio dio;

  ApiClient(
    String baseUrl, {
    String contentType = 'application/json',
    List<Interceptor>? interceptors,
  }) : dio = Dio(
         BaseOptions(
           baseUrl: baseUrl,
           contentType: contentType,
           connectTimeout: AppDurations.apiTimeout,
           receiveTimeout: AppDurations.apiTimeout,
           sendTimeout: AppDurations.apiTimeout,
         ),
       ) {
    // Default logger (chỉ dùng debug)
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

    // Custom interceptors, nếu có
    if (interceptors != null && interceptors.isNotEmpty) {
      dio.interceptors.addAll(interceptors);
    }
  }

  ApiClient.fromDio(this.dio);

  /// Convenience helper đưa body object thành json string (khi cần).
  String encodeJson(Object? data) => jsonEncode(data);

  /// Lấy base URL đang dùng, phục vụ logging.
  String get baseUrl => dio.options.baseUrl;

  /// Lấy HTTP client (Dio) để gọi API.
  Dio get client => dio;
}
