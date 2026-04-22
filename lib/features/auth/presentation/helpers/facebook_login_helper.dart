// UI_TOKENS_IGNORE
import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';
import 'package:clarityrms/features/auth/domain/usecases/params/social_login_params.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

Future<void> performFacebookLogin(
  BuildContext context,
  AuthCubit authCubit,
) async {
  UIHelper.hideKeyboard(context);

  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    UIHelper.showAppSnackBar(
      context,
      'Đăng nhập Facebook hiện chỉ hỗ trợ Android.',
      backgroundColor: Theme.of(context).colorScheme.error,
    );
    return;
  }

  try {
    final loginResult = await FacebookAuth.instance.login(
      permissions: const ['email', 'public_profile'],
    );

    if (loginResult.status != LoginStatus.success) {
      if (loginResult.status == LoginStatus.cancelled) {
        return;
      }

      if (!context.mounted) return;
      UIHelper.showAppSnackBar(
        context,
        loginResult.message ?? 'Đăng nhập Facebook thất bại',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    final accessToken = loginResult.accessToken;
    if (accessToken == null || accessToken.tokenString.isEmpty) {
      if (!context.mounted) return;
      UIHelper.showAppSnackBar(
        context,
        'Không lấy được access token Facebook',
        backgroundColor: Theme.of(context).colorScheme.error,
      );
      return;
    }

    final credential = FacebookAuthProvider.credential(accessToken.tokenString);
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );

    final user = userCredential.user;
    final userData = await FacebookAuth.instance.getUserData(
      fields: 'name,email,picture.width(200)',
    );

    if (!context.mounted) return;
    await authCubit.loginWithSocial(
      SocialAuthProvider.facebook,
      token: accessToken.tokenString,
      email: user?.email ?? userData['email'] as String?,
      displayName: user?.displayName ?? userData['name'] as String?,
    );
  } on FirebaseAuthException catch (error) {
    if (!context.mounted) return;
    UIHelper.showAppSnackBar(
      context,
      error.message ?? error.code,
      backgroundColor: Theme.of(context).colorScheme.error,
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
