import 'package:clarityrms/core/infrastructure/network/interceptors/auth_interceptor.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDataSource extends Mock implements AuthLocalDataSource {}

void main() {
  setUpAll(() {
    registerFallbackValue(RequestOptions(path: '/'));
  });

  test('refreshes token and replays request (helper)', () async {
    final local = MockAuthLocalDataSource();
    String currentAccess = 'old-token';

    when(
      () => local.getCachedAccessToken(),
    ).thenAnswer((_) async => currentAccess);
    when(
      () => local.getCachedRefreshToken(),
    ).thenAnswer((_) async => 'refresh-token');
    when(() => local.cacheAccessToken(any())).thenAnswer((inv) async {
      currentAccess = inv.positionalArguments[0] as String;
    });

    var refreshCalls = 0;
    final tokenDio = Dio();
    tokenDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path == '/auth/refresh') {
            refreshCalls++;
            handler.resolve(
              Response(
                requestOptions: options,
                data: {'access_token': 'new-token'},
                statusCode: 200,
              ),
            );
          } else {
            handler.next(options);
          }
        },
      ),
    );

    final dio = Dio();

    // backend: initial requests return 401 via reject; after token refreshed, returns 200
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final auth = options.headers['Authorization'] as String?;
          if (auth == 'Bearer new-token') {
            handler.resolve(
              Response(
                requestOptions: options,
                data: {'ok': true},
                statusCode: 200,
              ),
            );
          } else {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(requestOptions: options, statusCode: 401),
              ),
            );
          }
        },
      ),
    );

    final interceptor = AuthInterceptor(
      authLocalDataSource: local,
      tokenDio: tokenDio,
      dio: dio,
    );
    await interceptor.performRefreshAndReplay(RequestOptions(path: '/me'));

    expect(refreshCalls, 1);
    expect(currentAccess, 'new-token');
  });

  test('single-flight: concurrent 401s trigger one refresh (helper)', () async {
    final local = MockAuthLocalDataSource();
    String currentAccess = 'old-token';

    when(
      () => local.getCachedAccessToken(),
    ).thenAnswer((_) async => currentAccess);
    when(
      () => local.getCachedRefreshToken(),
    ).thenAnswer((_) async => 'refresh-token');
    when(() => local.cacheAccessToken(any())).thenAnswer((inv) async {
      currentAccess = inv.positionalArguments[0] as String;
    });

    var refreshCalls = 0;
    final tokenDio = Dio();
    tokenDio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path == '/auth/refresh') {
            await Future.delayed(const Duration(milliseconds: 50));
            refreshCalls++;
            handler.resolve(
              Response(
                requestOptions: options,
                data: {'access_token': 'new-token'},
                statusCode: 200,
              ),
            );
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
          final auth = options.headers['Authorization'] as String?;
          if (auth == 'Bearer new-token') {
            handler.resolve(
              Response(
                requestOptions: options,
                data: {'ok': true},
                statusCode: 200,
              ),
            );
          } else {
            handler.reject(
              DioException(
                requestOptions: options,
                response: Response(requestOptions: options, statusCode: 401),
              ),
            );
          }
        },
      ),
    );

    final interceptor = AuthInterceptor(
      authLocalDataSource: local,
      tokenDio: tokenDio,
      dio: dio,
    );
    await Future.wait([
      interceptor.performRefreshAndReplay(RequestOptions(path: '/one')),
      interceptor.performRefreshAndReplay(RequestOptions(path: '/two')),
    ]);

    expect(refreshCalls, 1);
    expect(currentAccess, 'new-token');
  });
}
