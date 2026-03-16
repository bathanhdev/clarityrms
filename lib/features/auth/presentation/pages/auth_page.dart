import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/shared/generated/assets.gen.dart';
import 'package:clarityrms/core/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppSpacing.verticalSpaceLg,
              Center(
                child: Assets.images.logo.image(height: AppDimensions.logoSize),
              ),
              AppSpacing.verticalSpaceLg,
              Center(
                child: Text(
                  'Chào mừng đến với Clarity RMS',
                  style: textTheme.headlineSmall?.copyWith(
                    color: colors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.verticalSpaceSm,
              Center(
                child: Text(
                  'Quản lý bán lẻ thông minh — nhanh chóng và đáng tin cậy',
                  style: textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              AppSpacing.verticalSpaceXl,

              // Buttons
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(AppDimensions.buttonHeightMd),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () => GoRouter.of(context).push(AppRouter.login),
                child: const Text('Đăng nhập'),
              ),
              AppSpacing.verticalSpaceMd,
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: Size.fromHeight(AppDimensions.buttonHeightMd),
                  side: BorderSide(color: colors.primary),
                ),
                onPressed: () => GoRouter.of(context).push(AppRouter.register),
                child: Text(
                  'Tạo tài khoản mới',
                  style: TextStyle(color: colors.primary),
                ),
              ),

              const Spacer(),
              Center(
                child: TextButton(
                  onPressed: () {
                    // Optional: continue as guest
                    GoRouter.of(context).go(AppRouter.home);
                  },
                  child: const Text('Tiếp tục không đăng nhập'),
                ),
              ),
              AppSpacing.verticalSpaceSm,
            ],
          ),
        ),
      ),
    );
  }
}
