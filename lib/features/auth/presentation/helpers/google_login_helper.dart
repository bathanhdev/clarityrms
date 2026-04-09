import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';
import 'package:clarityrms/features/auth/domain/usecases/params/social_login_params.dart';
import 'package:clarityrms/features/auth/presentation/helpers/firebase_auth_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

Future<void> performGoogleLogin(
  BuildContext context,
  AuthCubit authCubit,
) async {
  UIHelper.hideKeyboard(context);

  if (kIsWeb) {
    UIHelper.showAppSnackBar(
      context,
      'Đăng nhập Google hiện chỉ hỗ trợ Android.',
      backgroundColor: Theme.of(context).colorScheme.error,
    );
    return;
  }

  try {
    final result = await FirebaseAuthService.signInWithGoogle();
    if (result == null) {
      return;
    }

    final idToken = result.idToken;
    if (idToken == null || idToken.isEmpty) {
      if (!context.mounted) return;
      UIHelper.showAppSnackBar(
        context,
        'Không lấy được token Firebase',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    if (!context.mounted) return;
    await authCubit.loginWithSocial(
      SocialAuthProvider.google,
      token: idToken,
      email: result.email,
      displayName: result.displayName,
    );
  } catch (error) {
    if (!context.mounted) return;
    UIHelper.showAppSnackBar(
      context,
      error.toString(),
      backgroundColor: Theme.of(context).colorScheme.error,
    );
  }
}
