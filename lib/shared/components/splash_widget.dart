import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/shared/generated/assets.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class SplashWidget extends StatelessWidget {
  const SplashWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        spacing: AppSpacing.md,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Assets.images.logo.image(
            height: AppDimensions.logoSize * 1.5,
            width: AppDimensions.logoSize * 1.5,
          ),
          Center(
            child: SpinKitDancingSquare(
              color: Theme.of(context).primaryColor,
              size: AppDimensions.iconSizeLg * 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
