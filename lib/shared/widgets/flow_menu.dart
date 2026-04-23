import 'package:clarityrms/core/constants/app_durations.dart';
import 'package:clarityrms/core/ui/app_dimensions.dart';
import 'package:clarityrms/core/ui/app_radius.dart';
import 'package:clarityrms/core/ui/app_spacing.dart';
import 'package:flutter/material.dart';

class FlowMenuAction {
  const FlowMenuAction({
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.backgroundColor,
    this.foregroundColor,
  });

  final Widget icon;
  final VoidCallback onPressed;
  final String? tooltip;
  final Color? backgroundColor;
  final Color? foregroundColor;
}

class _FlowMenuDelegate extends FlowDelegate {
  final Animation<double> animation;
  final double itemSpacing;
  final double anchorOffset;

  _FlowMenuDelegate({
    required this.animation,
    required this.itemSpacing,
    required this.anchorOffset,
  }) : super(repaint: animation);

  @override
  void paintChildren(FlowPaintingContext context) {
    final double x = context.size.width - anchorOffset;
    final double y = context.size.height - anchorOffset;

    for (int i = 0; i < context.childCount; i++) {
      final isLastItem = i == context.childCount - 1;
      final double space = isLastItem
          ? AppSpacing.none
          : (i + 1) * itemSpacing * animation.value;

      context.paintChild(
        i,
        transform: Matrix4.translationValues(x, y - space, 0),
      );
    }
  }

  @override
  bool shouldRepaint(_FlowMenuDelegate oldDelegate) =>
      animation != oldDelegate.animation;
}

class FlowMenu extends StatefulWidget {
  const FlowMenu({
    super.key,
    required this.actions,
    this.mainButtonTooltip = 'Menu',
    this.mainButtonBackgroundColor,
    this.mainButtonForegroundColor,
    this.mainButtonIcon,
    this.buttonSize = AppDimensions.buttonHeightMd,
    this.iconSize = AppDimensions.iconSizeMd,
    this.itemSpacing = AppDimensions.buttonHeightMd + AppSpacing.md,
    this.anchorOffset = AppDimensions.buttonHeightMd,
  });

  final List<FlowMenuAction> actions;
  final String mainButtonTooltip;
  final Color? mainButtonBackgroundColor;
  final Color? mainButtonForegroundColor;
  final Widget? mainButtonIcon;
  final double buttonSize;
  final double iconSize;
  final double itemSpacing;
  final double anchorOffset;

  @override
  State<FlowMenu> createState() => _FlowMenuState();
}

class _FlowMenuState extends State<FlowMenu>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AppDurations.fastAnimation,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildActionButton({
    required Widget icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    Color? foregroundColor,
    String? tooltip,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: IconTheme.merge(
        data: IconThemeData(size: widget.iconSize, color: foregroundColor),
        child: icon,
      ),
      tooltip: tooltip,
      style: ButtonStyle(
        fixedSize: WidgetStatePropertyAll(Size.square(widget.buttonSize)),
        backgroundColor: WidgetStatePropertyAll(backgroundColor),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: AppRadius.borderRadiusCircular),
        ),
      ),
    );
  }

  void _toggleMenu() {
    if (_controller.isDismissed) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Flow(
      delegate: _FlowMenuDelegate(
        animation: _controller,
        itemSpacing: widget.itemSpacing,
        anchorOffset: widget.anchorOffset,
      ),
      children: [
        ...widget.actions.map(
          (action) => _buildActionButton(
            icon: action.icon,
            onPressed: action.onPressed,
            backgroundColor: action.backgroundColor ?? colors.surface,
            foregroundColor: action.foregroundColor ?? colors.onSurface,
            tooltip: action.tooltip,
          ),
        ),
        _buildActionButton(
          icon:
              widget.mainButtonIcon ??
              AnimatedIcon(
                icon: AnimatedIcons.menu_close,
                color: colors.onPrimary,
                size: widget.iconSize,
                progress: _controller,
              ),
          onPressed: _toggleMenu,
          backgroundColor: widget.mainButtonBackgroundColor ?? colors.primary,
          foregroundColor: widget.mainButtonForegroundColor ?? colors.onPrimary,
          tooltip: widget.mainButtonTooltip,
        ),
      ],
    );
  }
}
