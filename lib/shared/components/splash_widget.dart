import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/shared/generated/assets.gen.dart';
import 'package:clarityrms/shared/styles/app_colors.dart';
import 'package:clarityrms/shared/constants/hero_tags.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: AppSpacing.paddingAllLg,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: AppSpacing.paddingAllMd,
                    decoration: BoxDecoration(
                      color: AppColors.surface.withAlpha(153),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow.withAlpha(28),
                          blurRadius: AppDimensions.shadowBlurLg,
                          offset: const Offset(0, AppDimensions.shadowOffsetLg),
                        ),
                      ],
                    ),
                    child: Hero(
                      tag: HeroTags.appLogo,
                      child: Assets.images.logo.image(
                        height: AppDimensions.logoSize * 1.15,
                        width: AppDimensions.logoSize * 1.15,
                      ),
                    ),
                  ),

                  AppSpacing.verticalSpaceLg,

                  Text(
                    'Clarity RMS',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: colors.onSurface,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                  AppSpacing.verticalSpaceSm,
                  Text(
                    'Quản lý bán lẻ — nhanh chóng và đáng tin cậy',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurface.withAlpha(200),
                    ),
                  ),

                  AppSpacing.verticalSpaceLg,

                  SpinKitThreeBounce(
                    color: colors.primary,
                    size: AppDimensions.iconSizeLg,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
