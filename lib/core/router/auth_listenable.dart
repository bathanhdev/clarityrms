import 'dart:async';
import 'package:flutter/material.dart';
import 'package:clarityrms/core/global_state/auth/auth_cubit.dart';

/// Adapter that allows GoRouter to listen to an [AuthCubit] stream.
class AuthListenable extends ChangeNotifier {
  final AuthCubit authCubit;
  late final StreamSubscription subscription;

  AuthListenable(this.authCubit) {
    subscription = authCubit.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
}
