import 'package:clarityrms/core/infrastructure/network/interceptors/auth_interceptor.dart';
import 'package:clarityrms/core/infrastructure/network/interceptors/auth_logout_handler.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

class MockLogoutHandler extends Mock implements AuthLogoutHandler {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  test('refresh failure triggers logout handler', () async {
    final local = MockAuthLocalDataSource();

    when(() => local.getCachedAccessToken()).thenAnswer((_) async => 'old');
    when(
      () => local.getCachedRefreshToken(),
    ).thenAnswer((_) async => 'bad-refresh');

    // tokenDio will respond with 500 to simulate refresh failure
    final tokenDio = Dio();
    tokenDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path == '/auth/refresh') {
            handler.resolve(Response(requestOptions: options, statusCode: 500));
          } else {
            handler.next(options);
          }
        },
      ),
    );

    final dio = Dio();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.reject(
            DioException(
              requestOptions: options,
              response: Response(requestOptions: options, statusCode: 401),
            ),
          );
        },
      ),
    );

    final logoutHandler = MockLogoutHandler();
    when(() => logoutHandler.handleLogout()).thenAnswer((_) async {});

    final interceptor = AuthInterceptor(
      authLocalDataSource: local,
      tokenDio: tokenDio,
      dio: dio,
      logoutHandler: logoutHandler,
    );
    final result = await interceptor.performRefreshAndReplay(
      RequestOptions(path: '/me'),
    );

    expect(result, isNull);
    verify(() => logoutHandler.handleLogout()).called(1);
  });
}
