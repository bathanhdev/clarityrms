import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/features/auth/presentation/helpers/facebook_login_helper.dart';
import 'package:clarityrms/features/auth/presentation/helpers/google_login_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthSocialLoginButtons extends StatelessWidget {
  const AuthSocialLoginButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () =>
                performGoogleLogin(context, context.read<AuthCubit>()),
            icon: const Icon(Icons.login),
            label: const Text('Google'),
          ),
        ),
        AppSpacing.horizontalSpaceMd,
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () =>
                performFacebookLogin(context, context.read<AuthCubit>()),
            icon: const Icon(Icons.login),
            label: const Text('Facebook'),
          ),
        ),
      ],
    );
  }
}
