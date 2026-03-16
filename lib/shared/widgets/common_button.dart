import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum CommonButtonVariant { filled, outlined, ghost }

enum CommonButtonStyle {
  primary,
  success,
  warning,
  error,
  cancel,
  disable,
  info,
}

class CommonButton extends StatelessWidget {
  const CommonButton({
    super.key,
    this.onPressed,
    this.style,
    this.icon,
    required this.label,
    this.commonButtonStyle = CommonButtonStyle.primary,
    this.variant = CommonButtonVariant.filled,
    this.isLoading = false,
    this.reverse = false,
    this.expanded = false,
    this.tooltip,
  });

  final VoidCallback? onPressed;
  final ButtonStyle? style;
  final Widget? icon;
  final Widget label;
  final CommonButtonStyle commonButtonStyle;
  final CommonButtonVariant variant;
  final bool isLoading;
  final bool reverse;
  final bool expanded;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final colors = _getEffectiveColor(context);
    final effectiveStyle = _getEffectiveStyle(context, colors);

    Widget buttonContent = isLoading
        ? SpinKitFadingFour(
            color: (variant == CommonButtonVariant.filled && !reverse)
                ? colors.onMain
                : colors.main,
            size: AppDimensions.iconSizeMd,
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[icon!, const SizedBox(width: 8)],
              label,
            ],
          );

    Widget button;
    switch (variant) {
      case CommonButtonVariant.filled:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: effectiveStyle,
          child: buttonContent,
        );
        break;
      case CommonButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: effectiveStyle,
          child: buttonContent,
        );
        break;
      case CommonButtonVariant.ghost:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: effectiveStyle,
          child: buttonContent,
        );
        break;
    }

    return SizedBox(
      width: expanded ? double.infinity : null,
      child: tooltip != null && tooltip!.isNotEmpty
          ? Tooltip(message: tooltip!, child: button)
          : button,
    );
  }

  /// Lấy màu Semantic dựa trên cấu hình ColorScheme của ứng dụng
  ({Color main, Color onMain}) _getEffectiveColor(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    switch (commonButtonStyle) {
      case CommonButtonStyle.primary:
        return (main: colorScheme.primary, onMain: colorScheme.onPrimary);

      case CommonButtonStyle.success:
        return (main: colorScheme.secondary, onMain: colorScheme.onSecondary);

      case CommonButtonStyle.info:
        return (
          main: colorScheme.primaryContainer,
          onMain: colorScheme.onPrimaryContainer,
        );

      case CommonButtonStyle.warning:
        return (main: colorScheme.tertiary, onMain: colorScheme.onTertiary);

      case CommonButtonStyle.error:
        return (main: colorScheme.error, onMain: colorScheme.onError);

      case CommonButtonStyle.cancel:
        return (
          main: colorScheme.surfaceContainer,
          onMain: colorScheme.onSurfaceVariant,
        );

      case CommonButtonStyle.disable:
        return (
          main: colorScheme.onSurface.withValues(alpha: .12),
          onMain: colorScheme.onSurface.withValues(alpha: .38),
        );
    }
  }

  ButtonStyle _getEffectiveStyle(
    BuildContext context,
    ({Color main, Color onMain}) colors,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    ButtonStyle base;
    if (variant == CommonButtonVariant.filled) {
      base = ElevatedButton.styleFrom(
        backgroundColor: reverse ? colors.onMain : colors.main,
        foregroundColor: reverse ? colors.main : colors.onMain,
        elevation: (commonButtonStyle == CommonButtonStyle.cancel || isDark)
            ? 0
            : 1,
      );
    } else if (variant == CommonButtonVariant.outlined) {
      base = OutlinedButton.styleFrom(
        foregroundColor: colors.main,
        side: BorderSide(
          color: colors.main.withValues(alpha: isDark ? 0.3 : 0.5),
          width: 1.2,
        ),
        backgroundColor: colors.main.withValues(alpha: isDark ? 0.08 : 0.04),
      );
    } else {
      base = TextButton.styleFrom(foregroundColor: colors.main);
    }

    return base
        .copyWith(
          minimumSize: WidgetStatePropertyAll(
            Size.fromHeight(AppDimensions.buttonHeightLg),
          ),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusMd),
          ),
        )
        .merge(style);
  }
}
