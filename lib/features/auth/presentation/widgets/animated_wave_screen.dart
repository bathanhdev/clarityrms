// UI_TOKENS_IGNORE
import 'dart:math' as math;
import 'package:flutter/material.dart';

class AnimatedWaveScreen extends StatefulWidget {
  const AnimatedWaveScreen({super.key});

  @override
  State<AnimatedWaveScreen> createState() => _AnimatedWaveScreenState();
}

class _AnimatedWaveScreenState extends State<AnimatedWaveScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomPaint(size: Size.infinite, painter: WavePainter(context)),
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return CustomPaint(
                size: Size.infinite,
                painter: SineWavePainter(
                  phase: _controller.value * 2 * math.pi,
                  context: context,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SineWavePainter extends CustomPainter {
  final double phase;
  final BuildContext context;

  SineWavePainter({required this.phase, required this.context});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Theme.of(context).colorScheme.primary.withValues(alpha: .8)
      ..style = PaintingStyle.fill;

    final path = Path();

    final double dynamicHeight =
        15.0 + (25 - 5) * ((math.sin(phase * 0.5) + 1) / 2);

    const double waveCount = 1.5;

    final double startY = (size.height * 0.5);

    path.moveTo(0, startY);

    for (double x = 0; x <= size.width; x++) {
      double relativeX = x / size.width;

      double y =
          math.sin((relativeX * waveCount * 2 * math.pi) - phase) *
          dynamicHeight;

      double diagonalOffset = x * 0;

      path.lineTo(x, startY + y + diagonalOffset);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SineWavePainter oldDelegate) => oldDelegate.phase != phase;
}

class WavePainter extends CustomPainter {
  final BuildContext context;
  WavePainter(this.context);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.brown.withAlpha(200)
      ..style = PaintingStyle.fill;

    final path = pathWithConicTo(size);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Path pathWithQuadraticBezierTo(Size size) {
  final path = Path();

  final startY = size.height * 0.4;
  path.moveTo(0, 0);
  path.lineTo(0, startY);

  double waveCount = 2;
  double waveHeight = 50;

  double stepX = size.width / waveCount;
  double stepY = size.height * 0.25 / waveCount;

  for (int i = 0; i < waveCount; i++) {
    double endX = stepX * (i + 1);
    double endY = (startY) + (stepY * (i + 1));

    double midX = (stepX * i + endX) / 2;
    double midY = ((startY) + (stepY * i) + endY) / 2;

    double modifier = (i % 2 != 0) ? 1 : -1;

    path.quadraticBezierTo(
      midX - (waveHeight * modifier),
      midY + (waveHeight * modifier),
      endX,
      endY,
    );
  }

  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();

  return path;
}

Path pathWithCubicTo(Size size) {
  final path = Path();

  path.moveTo(0, size.height * 0.5);

  path.cubicTo(
    size.width * 0.25,
    size.height * 0.4,
    size.width * 0.75,
    size.height * 0.6,
    size.width,
    size.height * 0.5,
  );

  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();

  return path;
}

Path pathWithArcToPoint(Size size) {
  final path = Path();

  path.moveTo(0, size.height * 0.4);

  path.arcToPoint(
    Offset(size.width * 0.5, size.height * 0.5),
    radius: Radius.circular(size.width * 0.5),
    clockwise: false,
  );

  path.arcToPoint(
    Offset(size.width, size.height * 0.6),
    radius: Radius.circular(size.width * 0.5),
    clockwise: true,
  );

  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();

  return path;
}

Path pathWithSineWave(Size size) {
  final path = Path();

  double startY = size.height * 0.5;
  path.moveTo(0, startY);

  for (double i = 0; i <= size.width; i++) {
    double y = math.sin((i / size.width) * 2 * math.pi * 2) * 20 + startY;
    path.lineTo(i, y);
  }

  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();

  return path;
}

Path pathWithConicTo(Size size) {
  final path = Path();

  final double groundLevel = size.height * 0.5;
  final double peak1Height = size.height * 0.2;
  final double peak2Height = size.height * 0.1;
  final double valleyLevel = size.height * 0.4;

  path.moveTo(0, groundLevel);

  path.conicTo(
    size.width * 0.25,
    peak1Height,
    size.width * 0.5,
    valleyLevel,
    2.5,
  );

  path.conicTo(
    size.width * 0.8,
    peak2Height,
    size.width,
    size.height * 0.3,
    3.0,
  );

  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();

  return path;
}
