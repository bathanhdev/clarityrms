import 'package:clarityrms/core/infrastructure/network/network.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:clarityrms/core/usecases/usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/login_user_usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/logout_user_usecase.dart';
import 'package:clarityrms/features/auth/domain/usecases/params/login_params.dart';
import 'package:clarityrms/core/global_state/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUserUseCase loginUser;
  final CheckAuthStatusUseCase checkAuthStatus;
  final LogoutUserUseCase logoutUser;

  AuthCubit({
    required this.loginUser,
    required this.checkAuthStatus,
    required this.logoutUser,
  }) : super(const AuthInitial());

  // ==========================================================
  // HÀM KIỂM TRA TRẠNG THÁI KHỞI ĐỘNG
  // ==========================================================

  /// Kiểm tra xem người dùng có token hợp lệ hay không khi ứng dụng khởi động.
  Future<void> appStarted() async {
    emit(const AuthLoading());

    // checkAuthStatus giờ trả về Future<bool>
    final isAuthenticated = await checkAuthStatus(NoParams());

    await Future.delayed(Duration(seconds: 2));

    // XÓA .fold() - Chỉ cần kiểm tra kết quả bool
    if (isAuthenticated) {
      emit(const AuthAuthenticated());
    } else {
      emit(const AuthUnauthenticated());
    }
  }

  // ==========================================================
  // HÀM LOGIN
  // ==========================================================

  Future<void> login(String username, String password) async {
    emit(const AuthLoading());

    final params = LoginParams(username: username, password: password);
    // result là APIResponse<AuthEntity>
    final result = await loginUser(params);

    await Future.delayed(Duration(seconds: 2));

    // SỬ DỤNG .when() CỦA FREEZED
    result.when(
      success: (authEntity, statusCode) {
        emit(const AuthAuthenticated());
      },
      failure: (errorDetail) {
        emit(AuthError(errorDetail.message));
      },
    );
  }

  // ==========================================================
  // HÀM LOGOUT
  // ==========================================================

  Future<void> logout() async {
    emit(const AuthLoading());

    // result là APIResponse<void>
    final result = await logoutUser(NoParams());

    // SỬ DỤNG .when() CỦA FREEZED
    result.when(
      success: (_, statusCode) {
        // Đăng xuất thành công
        emit(const AuthUnauthenticated());
      },
      failure: (errorDetail) {
        // Dù có lỗi khi đăng xuất, chúng ta vẫn nên đưa người dùng ra màn hình đăng nhập
        emit(AuthError('Đăng xuất thất bại: ${errorDetail.message}'));
        emit(const AuthUnauthenticated());
      },
    );
  }
}
