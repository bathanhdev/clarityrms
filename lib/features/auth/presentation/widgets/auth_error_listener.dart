import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';
import 'package:clarityrms/core/global_state/auth/auth_state.dart';
import 'package:clarityrms/core/infrastructure/helpers/ui_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthErrorListener extends StatelessWidget {
  const AuthErrorListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          UIHelper.showAppSnackBar(
            context,
            state.message,
            backgroundColor: Theme.of(context).colorScheme.error,
          );
        }
      },
      child: child,
    );
  }
}
