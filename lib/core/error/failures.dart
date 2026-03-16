import 'package:equatable/equatable.dart';

/// Lớp cơ sở cho tất cả các đối tượng Failure.
/// Tất cả các Failure phải kế thừa từ lớp này và sử dụng Equatable.
abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object> get props => [message];
}

// ==========================================================
// 1. FAILURES CHO SERVER
// ==========================================================

/// Failure đại diện cho lỗi từ phía Server.
class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({required super.message, this.statusCode});

  @override
  List<Object> get props => [message, statusCode ?? 0];
}

/// Failure đại diện cho việc không có kết nối Internet.
class NoConnectionFailure extends Failure {
  const NoConnectionFailure({
    super.message = "Vui lòng kiểm tra lại kết nối Internet của bạn.",
  });
}

/// Failure đại diện cho lỗi Token/Unauthorized.
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = "Phiên làm việc đã hết hạn. Vui lòng đăng nhập lại.",
  });
}

// ==========================================================
// 2. FAILURES CHO LOCAL & UNEXPECTED
// ==========================================================

/// Failure đại diện cho lỗi từ Local Storage (Cache/SecureStorage).
class CacheFailure extends Failure {
  const CacheFailure({super.message = "Không thể truy cập dữ liệu cục bộ."});
}

/// Failure đại diện cho các lỗi không lường trước được (Ví dụ: JSON Parsing, Format).
class UnexpectedFailure extends Failure {
  const UnexpectedFailure({super.message = "Đã xảy ra lỗi không xác định."});
}
