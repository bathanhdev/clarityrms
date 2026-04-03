import 'package:clarityrms/core/constants/api_endpoints_auth.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:clarityrms/core/error/exceptions.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:clarityrms/core/utils/log_util.dart';
import 'package:clarityrms/core/di/locator.dart';
import 'package:clarityrms/core/infrastructure/network/interceptors/auth_logout_handler.dart';
import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';

// Uses the centralized service locator `sl` (lib/core/di/locator.dart)

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource authLocalDataSource;
  final Dio tokenDio; // Dio instance DÀNH RIÊNG cho việc làm mới token
  final Dio dio; // main Dio instance (inject để tránh gọi sl() trực tiếp)
  final AuthLogoutHandler? logoutHandler;
  Completer<void>? _refreshCompleter;

  AuthInterceptor({
    required this.authLocalDataSource,
    required this.tokenDio,
    required this.dio,
    this.logoutHandler,
  });

  // ==========================================================
  // 1. GẮN ACCESS TOKEN VÀO REQUEST (onRequest)
  // ==========================================================
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // BỎ QUA việc gắn token cho các endpoint Auth công khai (ví dụ: /login)
    // Hỗ trợ cả cơ chế: kiểm tra path hoặc flag `ignoredToken` trong options.extra
    final ignored = options.extra['ignoredToken'] == true;
    if (ignored ||
        options.path.contains('/auth/login') ||
        options.path.contains('/auth/refresh')) {
      return handler.next(options);
    }

    try {
      final accessToken = await authLocalDataSource.getCachedAccessToken();
      // Gắn Bearer Token vào Header
      options.headers['Authorization'] = 'Bearer $accessToken';
      Log.d(
        'Gắn Access Token vào request: ${options.path}',
        name: 'AUTH_INTERCEPTOR',
      );
      return handler.next(options);
    } on CacheException {
      // Nếu không có token, vẫn tiếp tục request. Server sẽ trả về 401.
      Log.w(
        'Không tìm thấy Access Token. Tiếp tục request không token.',
        name: 'AUTH_INTERCEPTOR',
      );
      return handler.next(options);
    } catch (e) {
      Log.e('Lỗi khi cố gắng gắn token: $e', name: 'AUTH_INTERCEPTOR');
      return handler.next(options);
    }
  }

  // ==========================================================
  // 2. XỬ LÝ LỖI 401 & LÀM MỚI TOKEN (onError)
  // ==========================================================
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    Log.d(
      'onError invoked, status=${err.response?.statusCode}',
      name: 'AUTH_INTERCEPTOR',
    );
    final originalRequest = err.response?.requestOptions;

    // Chỉ xử lý lỗi 401 (Unauthorized) và đảm bảo có request gốc
    if (err.response?.statusCode == 401 && originalRequest != null) {
      Log.w(
        'Nhận lỗi 401 Unauthorized. Bắt đầu quy trình làm mới token...',
        name: 'AUTH_INTERCEPTOR',
      );

      // Nếu request đã được thử lại, không tiếp tục làm mới để tránh vòng lặp
      if (originalRequest.extra['retried'] == true) {
        return handler.next(err);
      }

      // Delegate to shared refresh + replay helper (testable)
      try {
        final replayed = await performRefreshAndReplay(originalRequest);
        if (replayed != null) {
          return handler.resolve(replayed);
        }
      } catch (e) {
        Log.e('performRefreshAndReplay failed: $e', name: 'AUTH_INTERCEPTOR');
      }

      return handler.next(err);
    }

    return handler.next(err); // Trả về lỗi nếu không phải 401
  }

  // ==========================================================
  // 3. HỖ TRỢ TRƯỜNG HỢP SERVER TRẢ VỀ 401 NHƯ 1 Response
  //    (một số mock/test có thể resolve(Response(statusCode:401)))
  // ==========================================================
  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    // Nếu server trả 401 dưới dạng Response, xử lý tương tự onError
    if (response.statusCode == 401) {
      final originalRequest = response.requestOptions;

      Log.w(
        'Received 401 response. Handling refresh (onResponse).',
        name: 'AUTH_INTERCEPTOR',
      );

      if (originalRequest.extra['retried'] == true) {
        return handler.next(response);
      }

      if (_refreshCompleter != null) {
        try {
          await _refreshCompleter!.future;
        } catch (e) {
          return handler.next(response);
        }

        try {
          final newAccessToken = await authLocalDataSource
              .getCachedAccessToken();
          originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
          originalRequest.extra['retried'] = true;
          return handler.resolve(await dio.fetch(originalRequest));
        } catch (e) {
          return handler.next(response);
        }
      }

      _refreshCompleter = Completer<void>();
      try {
        final refreshToken = await authLocalDataSource.getCachedRefreshToken();
        final resp = await tokenDio.post(
          AuthEndpoints.refreshToken,
          data: {'refreshToken': refreshToken},
        );
        if (resp.statusCode == 200 || resp.statusCode == 201) {
          final newAccessToken = resp.data['access_token'] as String;
          await authLocalDataSource.cacheAccessToken(newAccessToken);
          _refreshCompleter?.complete();

          originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
          originalRequest.extra['retried'] = true;
          return handler.resolve(await dio.fetch(originalRequest));
        }
      } on DioException catch (e) {
        _refreshCompleter?.completeError(e);
      } on CacheException catch (_) {
        _refreshCompleter?.completeError(Exception('No refresh token'));
      }

      try {
        await _refreshCompleter?.future;
      } catch (_) {}

      _refreshCompleter = null;
      try {
        if (logoutHandler != null) {
          logoutHandler!.handleLogout();
        } else {
          sl<AuthCubit>().logout();
        }
      } catch (_) {}

      return handler.next(response);
    }

    return handler.next(response);
  }

  /// Testable method: perform token refresh (single-flight) and replay the original request.
  /// Returns the replayed Response on success, or null on failure.
  Future<Response?> performRefreshAndReplay(
    RequestOptions originalRequest,
  ) async {
    // If already refreshing, wait and then attempt replay
    if (_refreshCompleter != null) {
      try {
        await _refreshCompleter!.future;
      } catch (e) {
        return null;
      }

      try {
        final newAccessToken = await authLocalDataSource.getCachedAccessToken();
        originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
        originalRequest.extra['retried'] = true;
        return await dio.fetch(originalRequest);
      } catch (e) {
        return null;
      }
    }

    _refreshCompleter = Completer<void>();
    try {
      final refreshToken = await authLocalDataSource.getCachedRefreshToken();
      final response = await tokenDio.post(
        AuthEndpoints.refreshToken,
        data: {'refreshToken': refreshToken},
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final newAccessToken = response.data['access_token'] as String;
        await authLocalDataSource.cacheAccessToken(newAccessToken);
        _refreshCompleter?.complete();

        originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
        originalRequest.extra['retried'] = true;
        final replayed = await dio.fetch(originalRequest);
        _refreshCompleter = null;
        return replayed;
      } else {
        _refreshCompleter?.completeError(
          Exception('Refresh failed: ${response.statusCode}'),
        );
      }
    } on DioException catch (e) {
      _refreshCompleter?.completeError(e);
    } on CacheException catch (_) {
      _refreshCompleter?.completeError(Exception('No refresh token'));
    }

    try {
      await _refreshCompleter?.future;
    } catch (_) {}

    _refreshCompleter = null;
    try {
      if (logoutHandler != null) {
        await logoutHandler!.handleLogout();
      } else {
        sl<AuthCubit>().logout();
      }
    } catch (_) {}

    return null;
  }
}
