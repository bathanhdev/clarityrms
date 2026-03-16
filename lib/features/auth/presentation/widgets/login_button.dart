import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';

/// Reusable login button for the auth feature.
class LoginButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String label;

  const LoginButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.label = 'Đăng nhập',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? SpinKitChasingDots(
                color: Theme.of(context).colorScheme.onPrimary,
                size: AppDimensions.iconSizeMd,
              )
            : Text(label),
      ),
    );
  }
}
