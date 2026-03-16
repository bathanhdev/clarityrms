/// Lớp cơ sở cho tất cả các Exception tùy chỉnh.
/// Tất cả các exception khác sẽ kế thừa từ lớp này.
abstract class AppException implements Exception {
  final String message;
  final int? statusCode; // Mã trạng thái HTTP (nếu là lỗi server)

  const AppException({required this.message, this.statusCode});

  @override
  String toString() => 'AppException: $message (Status: $statusCode)';
}

// ==========================================================
// 1. EXCEPTIONS CHO SERVER (API)
// ==========================================================

/// Exception xảy ra khi không có phản hồi từ Server (Ví dụ: Timeout, No Internet).
class NoInternetException extends AppException {
  const NoInternetException({super.message = "Không có kết nối Internet."});
}

/// Exception xảy ra khi Server phản hồi lỗi (Mã trạng thái 4xx hoặc 5xx).
class ServerException extends AppException {
  const ServerException({required super.message, super.statusCode});
}

/// Exception cho lỗi 401 (Unauthorized/Token hết hạn).
class UnauthorizedException extends ServerException {
  const UnauthorizedException({
    super.message = "Phiên đăng nhập đã hết hạn. Vui lòng đăng nhập lại.",
    int super.statusCode = 401,
  });
}

/// Exception cho lỗi 404 (Không tìm thấy tài nguyên).
class NotFoundException extends ServerException {
  const NotFoundException({
    super.message = "Không tìm thấy tài nguyên được yêu cầu.",
    int super.statusCode = 404,
  });
}

// ==========================================================
// 2. EXCEPTIONS CHO LOCAL STORAGE (Cache/SecureStorage)
// ==========================================================

/// Exception xảy ra khi không tìm thấy dữ liệu cục bộ trong Cache/Storage.
class CacheException extends AppException {
  const CacheException({
    super.message = "Không tìm thấy dữ liệu trong bộ nhớ đệm.",
  });
}

/// Exception xảy ra khi có lỗi trong quá trình đọc/ghi dữ liệu cục bộ.
class StorageWriteException extends AppException {
  const StorageWriteException({required super.message});
}
