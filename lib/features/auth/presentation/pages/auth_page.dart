import 'dart:ui';

import 'package:clarityrms/core/constants/app_durations.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/features/auth/presentation/widgets/update_confirm_dialog.dart';
import 'package:clarityrms/shared/generated/assets.gen.dart';
import 'package:clarityrms/core/router/app_router.dart';
import 'package:clarityrms/shared/constants/hero_tags.dart';
import 'package:flutter/material.dart';
import 'package:clarityrms/shared/widgets/common_button.dart';
import 'package:go_router/go_router.dart';
import 'package:clarityrms/shared/widgets/network_status.dart';
import 'package:clarityrms/shared/widgets/theme_toggle.dart';
import 'package:shorebird_code_push/shorebird_code_push.dart';
import 'package:toastification/toastification.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  void _onUpdate(BuildContext context, ShorebirdUpdater updater) async {
    final confirm =
        await showDialog<bool>(
          context: context,
          builder: (ctx) => UpdateConfirmDialog(),
        ) ??
        false;

    if (!confirm) {
      toastification.show(
        title: const Text("ShoreBird"),
        description: const Text('Cập nhật đã bị hủy.'),
        autoCloseDuration: AppDurations.toastDuration,
        pauseOnHover: false,
      );
      return;
    }

    toastification.show(
      title: const Text("ShoreBird update"),
      description: Text('Đang tải bản cập nhật...'),
      autoCloseDuration: AppDurations.toastDuration,
      pauseOnHover: false,
    );

    try {
      await updater.update();
      toastification.show(
        title: const Text("ShoreBird"),
        description: const Text(
          'Cập nhật đã tải xong. Khởi động lại ứng dụng để áp dụng.',
        ),
        autoCloseDuration: AppDurations.toastDuration,
        pauseOnHover: false,
      );
    } on UpdateException catch (error) {
      toastification.show(
        title: const Text("ShoreBird error"),
        description: Text(error.message),
        autoCloseDuration: AppDurations.toastDuration,
        pauseOnHover: false,
      );
    }
  }

  Future<void> _handleShorebirdUpdate(BuildContext context) async {
    final updater = ShorebirdUpdater();

    if (!updater.isAvailable) {
      toastification.show(
        title: Text("ShoreBird"),
        description: Text('Shorebird is not available in this build.'),
        autoCloseDuration: AppDurations.toastDuration,
        showProgressBar: true,
        pauseOnHover: false,
      );
      return;
    }

    try {
      final status = await updater.checkForUpdate();

      switch (status) {
        case UpdateStatus.outdated:
          if (context.mounted) {
            _onUpdate(context, updater);
          }
          break;

        case UpdateStatus.restartRequired:
          toastification.show(
            title: Text("ShoreBird"),
            description: Text('An update is installed and requires a restart.'),
            autoCloseDuration: AppDurations.toastDuration,
            pauseOnHover: false,
          );
          break;

        case UpdateStatus.upToDate:
          toastification.show(
            title: Text("ShoreBird"),
            description: Text('App is up to date.'),
            autoCloseDuration: AppDurations.toastDuration,
            pauseOnHover: false,
          );
          break;

        case UpdateStatus.unavailable:
          toastification.show(
            title: Text("ShoreBird"),
            description: Text('Updater is unavailable in this build.'),
            autoCloseDuration: AppDurations.toastDuration,
            pauseOnHover: false,
          );
          break;
      }
    } on UpdateException catch (error) {
      toastification.show(
        title: Text("ShoreBird error"),
        description: Text(error.message),
        autoCloseDuration: AppDurations.toastDuration,
        pauseOnHover: false,
      );
    } catch (e) {
      toastification.show(
        title: Text("ShoreBird error"),
        description: Text(e.toString()),
        autoCloseDuration: AppDurations.toastDuration,
        pauseOnHover: false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      floatingActionButton: IconButton(
        onPressed: () => _handleShorebirdUpdate(context),
        icon: Icon(Icons.update),
        color: Theme.of(context).colorScheme.primary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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

          // Vòng tròn trang trí mờ
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

          // Hộp modal chính ở giữa với hiệu ứng blur
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
                          AppSpacing.verticalSpaceSm,
                          Center(child: ThemeToggle()),
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
