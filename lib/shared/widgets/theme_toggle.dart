// UI_TOKENS_IGNORE
import 'package:clarityrms/core/global_state/theme/theme_cubit.dart';
import 'package:clarityrms/shared/styles/app_typography.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, mode) {
        final isLight = mode == ThemeMode.light;
        final isDark = mode == ThemeMode.dark;
        final isSystem = mode == ThemeMode.system;

        return Container(
          padding: AppSpacing.paddingAllXs,
          decoration: BoxDecoration(
            color: colors.surface.withAlpha((0.6 * 255).round()),
            borderRadius: AppRadius.borderRadiusMd,
            border: Border.all(color: colors.outline.withAlpha(60)),
          ),
          child: Wrap(
            spacing: AppSpacing.sm,
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              _SegmentButton(
                icon: Icons.wb_sunny_outlined,
                label: 'Sáng',
                selected: isLight,
                onTap: () =>
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.light),
              ),
              _SegmentButton(
                icon: Icons.dark_mode_outlined,
                label: 'Tối',
                selected: isDark,
                onTap: () =>
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.dark),
              ),
              _SegmentButton(
                icon: Icons.smartphone_outlined,
                label: 'Hệ Thống',
                selected: isSystem,
                onTap: () =>
                    context.read<ThemeCubit>().setThemeMode(ThemeMode.system),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SegmentButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _SegmentButton({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = AppTypography.labelSmall;
    final selectedColor = Theme.of(context).colorScheme.primary;

    return Material(
      color: selected
          ? selectedColor.withAlpha((0.15 * 255).round())
          : Colors.transparent,
      borderRadius: AppRadius.borderRadiusSm,
      child: InkWell(
        borderRadius: AppRadius.borderRadiusSm,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.s12,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: AppDimensions.iconSizeSm,
                color: selected
                    ? selectedColor
                    : Theme.of(context).iconTheme.color,
              ),
              AppSpacing.horizontalSpaceSm,
              Text(
                label,
                style: textStyle.copyWith(
                  color: selected ? selectedColor : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
