import 'package:clarityrms/core/infrastructure/network/network.dart';
import 'package:dio/dio.dart';

/// Factory phục vụ việc tạo danh sách interceptor cho mọi ApiClient.
///
/// Khi hệ thống hiện tại yêu cầu token/refresh, `AuthInterceptor` sẽ được
/// dùng lại từ DI container.
class ApiClientFactory {
  final AuthInterceptor? authInterceptor;

  ApiClientFactory({this.authInterceptor});

  List<Interceptor>? getInterceptors({bool authRequired = true}) {
    final interceptors = <Interceptor>[];

    if (authRequired && authInterceptor != null) {
      interceptors.add(authInterceptor!);
    }

    return interceptors.isEmpty ? null : interceptors;
  }

  Dio createDio({
    required String baseUrl,
    bool authRequired = true,
    List<Interceptor>? additionalInterceptors,
  }) {
    final dio = Dio(BaseOptions(baseUrl: baseUrl));
    final built = getInterceptors(authRequired: authRequired);

    if (built != null && built.isNotEmpty) {
      dio.interceptors.addAll(built);
    }

    if (additionalInterceptors != null && additionalInterceptors.isNotEmpty) {
      dio.interceptors.addAll(additionalInterceptors);
    }

    return dio;
  }
}
