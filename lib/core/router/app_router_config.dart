import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:clarityrms/core/di/locator.dart';
// Route logging uses a NavigatorObserver; kept imports minimal here.

import 'package:clarityrms/features/auth/presentation/pages/auth_page.dart';
import 'package:clarityrms/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:clarityrms/features/auth/presentation/pages/register_page.dart';
import 'package:clarityrms/shared/components/splash_widget.dart';
import 'package:clarityrms/features/auth/presentation/pages/login_page.dart';
import 'package:clarityrms/features/home/presentation/pages/home_page.dart';
import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/global_state/auth/auth_state.dart';
import 'package:clarityrms/core/router/auth_listenable.dart';
import 'package:clarityrms/core/router/app_routes.dart';
import 'package:clarityrms/core/utils/route_logger.dart';

// Uses centralized service locator `sl` (lib/core/di/locator.dart)

/// Create and configure the GoRouter instance used by the app.
GoRouter createGoRouter() {
  final AuthCubit authCubit = sl<AuthCubit>();

  final router = GoRouter(
    refreshListenable: AuthListenable(authCubit),
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashWidget(),
      ),
      GoRoute(
        path: AppRoutes.auth,
        builder: (context, state) => const AuthPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(child: Text('404 - Không tìm thấy trang: ${state.uri}')),
    ),
    redirect: (BuildContext context, GoRouterState state) {
      final isAuthenticated = authCubit.state is AuthAuthenticated;
      final isChecking =
          authCubit.state is AuthInitial || authCubit.state is AuthLoading;

      final isGoingToAuth = [
        AppRoutes.auth,
        AppRoutes.login,
        AppRoutes.register,
        AppRoutes.forgotPassword,
      ].any((r) => state.matchedLocation.startsWith(r));

      if (isChecking) return null;
      if (isAuthenticated && isGoingToAuth || isAuthenticated) {
        return AppRoutes.home;
      }
      if (!isAuthenticated && !isGoingToAuth) return AppRoutes.auth;
      return null;
    },
    observers: [RouteLoggingObserver()],
  );

  return router;
}
