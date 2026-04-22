// UI_TOKENS_IGNORE
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthPageShell extends StatelessWidget {
  const AuthPageShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary.withAlpha(28),
            Theme.of(context).colorScheme.primaryContainer.withAlpha(18),
          ],
        ),
      ),
      child: Center(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Stack(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.borderRadiusMd,
                ),
                elevation: 8,
                child: Padding(padding: AppSpacing.screenPadding, child: child),
              ),
              Positioned(
                child: Padding(
                  padding: AppSpacing.screenPadding,
                  child: IconButton(
                    onPressed: () {
                      if (GoRouter.of(context).canPop()) {
                        GoRouter.of(context).pop();
                      }
                    },
                    icon: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    tooltip: 'Quay lại',
                    style: ButtonStyle(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
