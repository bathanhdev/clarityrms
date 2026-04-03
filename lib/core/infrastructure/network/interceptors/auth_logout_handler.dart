import 'package:clarityrms/core/di/locator.dart';
import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/utils/log_util.dart';

abstract class AuthLogoutHandler {
  Future<void> handleLogout();
}

/// Default implementation that forwards to `AuthCubit.logout()` via DI.
class DefaultAuthLogoutHandler implements AuthLogoutHandler {
  @override
  Future<void> handleLogout() async {
    try {
      sl<AuthCubit>().logout();
    } catch (e) {
      Log.e('DefaultAuthLogoutHandler failed: $e', name: 'AUTH_LOGOUT');
    }
  }
}
