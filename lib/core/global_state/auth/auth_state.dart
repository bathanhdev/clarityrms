import 'package:equatable/equatable.dart';

/// Lớp trạng thái cơ sở cho AuthCubit
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object> get props => [];
}

/// Trạng thái ban đầu hoặc trạng thái Đang tải (Loading)
class AuthInitial extends AuthState {
  const AuthInitial();
}

/// Trạng thái khi AuthCubit đang thực hiện một tác vụ
class AuthLoading extends AuthState {
  const AuthLoading();
}

/// Trạng thái khi người dùng ĐÃ xác thực thành công
class AuthAuthenticated extends AuthState {
  // Có thể chứa AuthEntity hoặc ID người dùng nếu cần
  const AuthAuthenticated();
}

/// Trạng thái khi người dùng CHƯA xác thực (Cần đăng nhập)
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

/// Trạng thái khi xảy ra lỗi trong quá trình Auth
class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object> get props => [message];
}
