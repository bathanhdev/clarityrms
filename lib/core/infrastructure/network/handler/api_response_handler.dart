import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_response_handler.freezed.dart';

/// Chi tiết lỗi đồng nhất để sử dụng trong APIResponse.failure
class ApiErrorDetail {
  final int statusCode;
  final String message;
  final String? error;

  ApiErrorDetail({required this.statusCode, required this.message, this.error});
}

@freezed
abstract class APIResponse<T> with _$APIResponse<T> {
  const factory APIResponse.success({
    required T data,
    @Default(200) int statusCode,
  }) = _Success<T>;

  const factory APIResponse.failure({required ApiErrorDetail errorDetail}) =
      _Failure<T>;
}
