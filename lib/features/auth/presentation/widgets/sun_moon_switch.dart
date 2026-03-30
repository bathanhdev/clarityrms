import 'package:flutter/material.dart';
import 'package:clarityrms/core/constants/app_durations.dart';

class SunMoonSwitch extends StatelessWidget {
  final bool isDark;
  final double size;
  const SunMoonSwitch({super.key, required this.isDark, this.size = 160});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: AppDurations.slowAnimation,
      switchInCurve: Curves.easeOutBack,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: (child, animation) {
        final rotate = Tween(
          begin: isDark ? -0.2 : 0.2,
          end: 0.0,
        ).animate(animation);
        return RotationTransition(
          turns: rotate,
          child: FadeTransition(
            opacity: animation,
            child: ScaleTransition(scale: animation, child: child),
          ),
        );
      },
      child: Container(
        key: ValueKey<bool>(isDark),
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isDark
              ? Colors.indigo[900]
              : Colors.orangeAccent.withValues(alpha: .6),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.08),
              blurRadius: isDark ? 24 : 10,
              offset: Offset(0, isDark ? 10 : 4),
            ),
          ],
        ),
        child: Center(
          child: Icon(
            isDark ? Icons.nights_stay : Icons.wb_sunny,
            size: size * 0.44,
            color: isDark ? Colors.white : Colors.yellow[800],
          ),
        ),
      ),
    );
  }
}
