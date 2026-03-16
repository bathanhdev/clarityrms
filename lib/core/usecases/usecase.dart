import 'package:equatable/equatable.dart';
import 'package:clarityrms/core/infrastructure/network/api_response_handler.dart';

// Lớp trừu tượng cơ sở cho tất cả các Use Case.
// Phương thức 'call' trả về APIResponse<T> cho các tác vụ có thể thất bại (Mạng).
abstract class UseCase<T, Params> {
  Future<APIResponse<T>> call(Params params);
}

// Tạo một interface mới cho các Use Case không bao giờ thất bại (hoặc đã xử lý lỗi)
// ví dụ: CheckAuthStatusUseCase (trả về bool)
abstract class SimpleUseCase<T, Params> {
  Future<T> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
