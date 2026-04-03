import 'dart:io';

import 'package:dio/dio.dart';
import 'package:clarityrms/core/error/exceptions.dart';
import 'package:clarityrms/core/infrastructure/network/factories/api_client_factory.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:clarityrms/core/infrastructure/network/interceptors/auth_interceptor.dart';
import 'package:clarityrms/core/infrastructure/network/interceptors/auth_logout_handler.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_service_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:shelf/shelf_io.dart' as shelf_io;
import 'helpers/mock_server.dart';

class TestAuthLocalDataSource implements AuthLocalDataSource {
  String? _access;
  String? _refresh;

  @override
  Future<void> cacheAccessToken(String token) async => _access = token;

  @override
  Future<void> cacheRefreshToken(String token) async => _refresh = token;

  @override
  Future<String> getCachedAccessToken() async {
    if (_access == null) throw const CacheException(message: 'No access');
    return _access!;
  }

  @override
  Future<String> getCachedRefreshToken() async {
    if (_refresh == null) throw const CacheException(message: 'No refresh');
    return _refresh!;
  }

  @override
  Future<void> clearAuthData() async {
    _access = null;
    _refresh = null;
  }
}

class TestLogoutHandler implements AuthLogoutHandler {
  bool called = false;
  @override
  Future<void> handleLogout() async {
    called = true;
  }
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Auth integration', () {
    late HttpServer server;
    late Uri baseUri;
    late AuthServiceClient testAuthClient;
    late TestAuthLocalDataSource testLocal;
    late TestLogoutHandler testLogout;

    setUpAll(() async {
      final mock = MockAuthServer();
      server = await shelf_io.serve(mock.router.call, 'localhost', 0);
      baseUri = Uri.parse('http://localhost:${server.port}');

      final tokenDio = Dio(BaseOptions(baseUrl: baseUri.toString()));
      final local = TestAuthLocalDataSource();
      final logoutHandler = TestLogoutHandler();
      final factory = ApiClientFactory(
        authInterceptorFactory: (dio) => AuthInterceptor(
          authLocalDataSource: local,
          tokenDio: tokenDio,
          dio: dio,
          logoutHandler: logoutHandler,
        ),
      );

      final authApiClient = factory.createApiClient(
        baseUrl: baseUri.toString(),
        authRequired: true,
      );
      final authClient = AuthServiceClient.fromDio(authApiClient.client);

      testAuthClient = authClient;
      testLocal = local;
      testLogout = logoutHandler;
    });

    tearDownAll(() async {
      await server.close();
    });

    testWidgets(
      'full auth flow: login -> access protected -> refresh on 401',
      (tester) async {
        final auth = await testAuthClient.login(
          username: 'test',
          password: 'pass',
        );

        await testLocal.cacheAccessToken(auth.accessToken);
        await testLocal.cacheRefreshToken(auth.refreshToken);

        final me = await testAuthClient.getMe();
        expect(me['name'], 'Test User');

        final finalAccess = await testLocal.getCachedAccessToken();
        expect(finalAccess, 'access-2');

        expect(testLogout.called, isFalse);
      },
      timeout: const Timeout(Duration(seconds: 30)),
    );
  });
}
