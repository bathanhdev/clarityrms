import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// AppBar trong suốt tái sử dụng nhỏ gọn, có `title` tuỳ chọn và
/// hành động quay lại tích hợp sử dụng `GoRouter`.
class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TransparentAppBar({
    super.key,
    this.title,
    this.showBack = true,
    this.elevation = 0,
  });

  final Widget? title;
  final bool showBack;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: elevation,
      leading: showBack
          ? IconButton(
              onPressed: () => GoRouter.of(context).pop(),
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: 'Quay lại',
            )
          : null,
      title: title,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
