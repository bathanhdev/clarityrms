import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/shared/constants/hero_tags.dart';
import 'package:clarityrms/shared/generated/assets.gen.dart';
import 'package:flutter/material.dart';

class AuthPageHeader extends StatelessWidget {
  const AuthPageHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Hero(
            tag: HeroTags.appLogo,
            child: Assets.images.logo.image(
              height: AppDimensions.logoSize * 0.75,
            ),
          ),
          AppSpacing.verticalSpaceSm,
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
          AppSpacing.verticalSpaceXs,
          Text(
            subtitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
