import 'package:dio/dio.dart';
import 'package:clarityrms/core/infrastructure/network/handler/api_response_handler.dart';
import 'package:clarityrms/core/infrastructure/network/info/network_info.dart';

import 'package:clarityrms/core/error/exceptions.dart';

/// Mapping exceptions to `APIResponse`
APIResponse<T> _mapExceptionToAPIResponse<T>(Object e) {
  if (e is ServerException) {
    return APIResponse.failure(
      errorDetail: ApiErrorDetail(
        statusCode: e.statusCode ?? 500,
        message: e.message,
        error: null,
      ),
    );
  }

  if (e is DioException) {
    return APIResponse.failure(
      errorDetail: ApiErrorDetail(
        statusCode: 503,
        message: 'Lỗi kết nối hoặc timeout. Vui lòng thử lại.',
        error: e.message,
      ),
    );
  }

  if (e is CacheException) {
    return APIResponse.failure(
      errorDetail: ApiErrorDetail(
        statusCode: 400,
        message: e.message,
        error: 'CacheError',
      ),
    );
  }

  return APIResponse.failure(
    errorDetail: ApiErrorDetail(
      statusCode: 500,
      message: 'Đã xảy ra lỗi không xác định.',
      error: e.toString(),
    ),
  );
}

/// Main wrapper to perform network calls with connectivity check and unified error mapping.
Future<APIResponse<T>> handleNetworkCall<T>({
  required NetworkInfo networkInfo,
  required Future<T> Function() apiCall,
}) async {
  if (!await networkInfo.isConnected) {
    return APIResponse.failure(
      errorDetail: ApiErrorDetail(
        statusCode: 600,
        message: 'Không có kết nối mạng. Vui lòng kiểm tra lại.',
        error: 'NoConnectionError',
      ),
    );
  }

  try {
    final result = await apiCall();
    return APIResponse.success(data: result);
  } catch (e) {
    return _mapExceptionToAPIResponse(e);
  }
}
