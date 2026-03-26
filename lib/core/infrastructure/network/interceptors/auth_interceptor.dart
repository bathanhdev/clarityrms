import 'package:clarityrms/core/constants/api_endpoints_auth.dart';
import 'package:dio/dio.dart';
import 'dart:async';
import 'package:clarityrms/core/error/exceptions.dart';
import 'package:clarityrms/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:clarityrms/core/utils/log_util.dart';
import 'package:clarityrms/core/di/locator.dart';
import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';

// Uses the centralized service locator `sl` (lib/core/di/locator.dart)

class AuthInterceptor extends Interceptor {
  final AuthLocalDataSource authLocalDataSource;
  final Dio tokenDio; // Dio instance DÀNH RIÊNG cho việc làm mới token
  final Dio dio; // main Dio instance (inject để tránh gọi sl() trực tiếp)
  Completer<void>? _refreshCompleter;

  AuthInterceptor({
    required this.authLocalDataSource,
    required this.tokenDio,
    required this.dio,
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
    // Giả sử đường dẫn Auth chứa '/auth'
    if (options.path.contains('/auth/login') ||
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

      // Nếu đã có tiến trình refresh đang chạy, chờ nó hoàn tất (single-flight)
      if (_refreshCompleter != null) {
        Log.d('Waiting for ongoing token refresh...', name: 'AUTH_INTERCEPTOR');
        try {
          await _refreshCompleter!.future;
        } catch (e) {
          Log.e('Ongoing token refresh failed: $e', name: 'AUTH_INTERCEPTOR');
          return handler.next(err);
        }

        // Sau khi chờ, thử lấy token mới từ cache và replay request
        try {
          final newAccessToken = await authLocalDataSource
              .getCachedAccessToken();
          originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
          originalRequest.extra['retried'] = true;
          return handler.resolve(await dio.fetch(originalRequest));
        } catch (e, st) {
          Log.e(
            'Failed to replay request after token refresh: $e',
            error: e,
            stackTrace: st,
            name: 'AUTH_INTERCEPTOR',
          );
          return handler.next(err);
        }
      }

      // Bắt đầu refresh token (single-flight)
      _refreshCompleter = Completer<void>();
      try {
        // 1. Lấy Refresh Token
        final refreshToken = await authLocalDataSource.getCachedRefreshToken();

        // 2. Gọi API Refresh Token bằng tokenDio (ĐỘC LẬP VỚI MAIN DIO)
        final response = await tokenDio.post(
          AuthEndpoints.refreshToken,
          data: {'refreshToken': refreshToken},
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          // 3. Lấy token MỚI và lưu trữ
          final newAccessToken = response.data['access_token'] as String;
          await authLocalDataSource.cacheAccessToken(newAccessToken);

          // Hoàn tất completer để các request chờ khác tiếp tục
          _refreshCompleter?.complete();
          Log.d('Làm mới token thành công.', name: 'AUTH_INTERCEPTOR');

          // 4. Cập nhật header của request gốc và THỰC HIỆN LẠI
          originalRequest.headers['Authorization'] = 'Bearer $newAccessToken';
          originalRequest.extra['retried'] = true;
          Log.d(
            'Thực hiện lại request: ${originalRequest.path}',
            name: 'AUTH_INTERCEPTOR',
          );

          return handler.resolve(await dio.fetch(originalRequest));
        }
      } on DioException catch (e) {
        Log.e('LỖI LÀM MỚI TOKEN: $e', name: 'AUTH_INTERCEPTOR');
        _refreshCompleter?.completeError(e);
      } on CacheException catch (_) {
        Log.e(
          'Không tìm thấy Refresh Token để làm mới. Đăng xuất người dùng.',
          name: 'AUTH_INTERCEPTOR',
        );
        _refreshCompleter?.completeError(Exception('No refresh token'));
      }

      // Nếu đến đây, refresh không thành công
      try {
        await _refreshCompleter?.future;
      } catch (e, st) {
        Log.e(
          'Waiting for refresh completer failed: $e',
          error: e,
          stackTrace: st,
          name: 'AUTH_INTERCEPTOR',
        );
      }

      _refreshCompleter = null;
      // Dispatch a global logout so UI and global state move to unauthenticated.
      try {
        // Fire-and-forget logout to avoid blocking error handling path.
        sl<AuthCubit>().logout();
      } catch (e) {
        Log.e(
          'Failed to dispatch AuthCubit.logout(): $e',
          name: 'AUTH_INTERCEPTOR',
        );
      }

      return handler.next(err);
    }

    return handler.next(err); // Trả về lỗi nếu không phải 401
  }
}
