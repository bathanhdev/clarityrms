// UI_TOKENS_IGNORE
import 'dart:ui';

import 'package:clarityrms/core/di/locator.dart';
import 'package:clarityrms/core/infrastructure/update/shorebird_update_service.dart';
import 'package:clarityrms/core/global_state/theme/theme_cubit.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/features/auth/presentation/widgets/animated_wave_screen.dart';
import 'package:clarityrms/features/auth/presentation/helpers/shorebird_update_helper.dart';
import 'package:clarityrms/shared/extensions/theme_cubit_extensions.dart';
import 'package:clarityrms/features/auth/presentation/widgets/sun_moon_switch.dart';
import 'package:clarityrms/shared/generated/assets.gen.dart';
import 'package:clarityrms/core/router/app_router.dart';
import 'package:clarityrms/shared/constants/hero_tags.dart';
import 'package:flutter/material.dart';
import 'package:clarityrms/shared/widgets/common_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:clarityrms/shared/widgets/network_status.dart';
import 'package:clarityrms/shared/widgets/theme_toggle.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final shorebirdUpdateService = sl<ShorebirdUpdateService>();

    Future<void> onShorebirdUpdatePressed() async {
      await performShorebirdUpdate(context, shorebirdUpdateService);
    }

    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: onShorebirdUpdatePressed,
        icon: Icon(Icons.update),
        color: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Stack(
        children: [
          _buildBackground(colors),
          _buildDecorativeOrb(context),
          _buildAuthCard(context, colors, textTheme),
        ],
      ),
    );
  }

  Widget _buildBackground(ColorScheme colors) {
    return Stack(
      children: [
        AnimatedWaveScreen(),
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
      ],
    );
  }

  Widget _buildDecorativeOrb(BuildContext context) {
    return Positioned(
      top: -45,
      right: -45,
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, mode) {
          final bool isDark =
              mode.getRealBrightness(context) == Brightness.dark;

          return SunMoonSwitch(isDark: isDark, size: 160);
        },
      ),
    );
  }

  Widget _buildAuthCard(
    BuildContext context,
    ColorScheme colors,
    TextTheme textTheme,
  ) {
    return Center(
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
                  color: Theme.of(context).colorScheme.surface.withAlpha(120),
                  borderRadius: AppRadius.borderRadiusLg,
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.shadow.withAlpha(20),
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
                      'Clarity RMS',
                      style: textTheme.titleLarge?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    AppSpacing.verticalSpaceSm,
                    Text(
                      'Quản lý bán lẻ thông minh, trực quan\nBắt đầu ngay',
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
                      commonButtonStyle: CommonButtonStyle.primary,
                      label: const Text('Tạo tài khoản mới'),
                      onPressed: () =>
                          GoRouter.of(context).push(AppRouter.register),
                    ),
                    AppSpacing.verticalSpaceMd,
                    const Center(child: ThemeToggle()),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
