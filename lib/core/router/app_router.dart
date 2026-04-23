import 'package:go_router/go_router.dart';

import 'package:clarityrms/core/router/app_router_config.dart';
import 'package:clarityrms/core/router/app_routes.dart';

/// Public AppRouter wrapper. Actual router configuration is in
/// `app_router_config.dart` to keep concerns separated.
class AppRouter {
  late final GoRouter _router;

  AppRouter() {
    _router = createGoRouter();
  }

  GoRouter get config => _router;

  // Re-export route constants for backward compatibility
  static String get root => AppRoutes.root;
  static String get splash => AppRoutes.splash;
  static String get auth => AppRoutes.auth;
  static String get login => AppRoutes.login;
  static String get register => AppRoutes.register;
  static String get forgotPassword => AppRoutes.forgotPassword;
  static String get home => AppRoutes.home;
}
