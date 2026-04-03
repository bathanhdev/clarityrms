import 'package:clarityrms/core/infrastructure/network/factories/api_client_factory.dart';
import 'package:clarityrms/core/infrastructure/network/interceptors/auth_interceptor.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class TestAuthInterceptor extends AuthInterceptor {
  TestAuthInterceptor(AuthLocalDataSource local, Dio tokenDio, Dio dio)
    : super(authLocalDataSource: local, tokenDio: tokenDio, dio: dio);
}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  test(
    'createDio attaches auth interceptor from factory and preserves options',
    () async {
      final local = MockAuthLocalDataSource();

      AuthInterceptor factory(Dio d) => TestAuthInterceptor(local, Dio(), d);

      final sut = ApiClientFactory(authInterceptorFactory: factory);

      final dio = sut.createDio(baseUrl: 'https://api.example');

      // baseUrl set
      expect(dio.options.baseUrl, 'https://api.example');

      // timeouts set to AppDurations.apiTimeout (a Duration)
      expect(
        dio.options.connectTimeout is Duration ||
            dio.options.connectTimeout is int,
        isTrue,
      );

      // interceptor from factory attached
      expect(dio.interceptors.any((i) => i is TestAuthInterceptor), isTrue);
    },
  );

  test(
    'createApiClient returns ApiClient backed by Dio with extra interceptors',
    () async {
      final sut = ApiClientFactory();

      final extra = InterceptorsWrapper(onRequest: (o, h) => h.next(o));
      final client = sut.createApiClient(
        baseUrl: 'https://api.example',
        additionalInterceptors: [extra],
      );

      // underlying dio should have the extra interceptor
      final dio = client.client; // ApiClient exposes `client`
      expect(dio.interceptors.contains(extra), isTrue);
    },
  );
}
