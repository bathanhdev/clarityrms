import 'dart:ui';

import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/shared/generated/assets.gen.dart';
import 'package:clarityrms/core/router/app_router.dart';
import 'package:clarityrms/shared/constants/hero_tags.dart';
import 'package:flutter/material.dart';
import 'package:clarityrms/shared/widgets/common_button.dart';
import 'package:go_router/go_router.dart';
import 'package:clarityrms/shared/widgets/network_status.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  colors.primary.withAlpha(30),
                  colors.primaryContainer.withAlpha(18),
                ],
              ),
            ),
          ),

          // Decorative soft circles
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withAlpha(20),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -60,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.secondary.withAlpha(18),
              ),
            ),
          ),

          // Center modal with blur
          Center(
            child: Padding(
              padding: AppSpacing.paddingAllLg,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: AppDimensions.cardMaxWidth,
                ),
                child: ClipRRect(
                  borderRadius: AppRadius.borderRadiusLg,
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surface.withAlpha(220),
                        borderRadius: AppRadius.borderRadiusLg,
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(
                              context,
                            ).colorScheme.shadow.withAlpha(20),
                            blurRadius: AppDimensions.shadowBlurLg,
                            offset: Offset(0, AppDimensions.shadowOffsetMd),
                          ),
                        ],
                      ),
                      padding: AppSpacing.paddingAllLg,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Center(
                            child: Hero(
                              tag: HeroTags.appLogo,
                              child: Assets.images.logo.image(
                                height: AppDimensions.logoSize * 0.7,
                              ),
                            ),
                          ),
                          AppSpacing.verticalSpaceLg,
                          Text(
                            'Chào mừng đến với Clarity RMS',
                            style: textTheme.titleLarge?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          AppSpacing.verticalSpaceSm,
                          Text(
                            'Quản lý bán lẻ thông minh, trực quan — bắt đầu ngay.',
                            style: textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),

                          const NetworkStatus(),

                          AppSpacing.verticalSpaceLg,

                          CommonButton(
                            expanded: true,
                            variant: CommonButtonVariant.filled,
                            label: const Text('Đăng nhập'),
                            onPressed: () =>
                                GoRouter.of(context).push(AppRouter.login),
                          ),
                          AppSpacing.verticalSpaceMd,
                          CommonButton(
                            expanded: true,
                            variant: CommonButtonVariant.outlined,
                            label: const Text('Tạo tài khoản mới'),
                            onPressed: () =>
                                GoRouter.of(context).push(AppRouter.register),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
