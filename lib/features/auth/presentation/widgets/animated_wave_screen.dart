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
      duration: const Duration(
        seconds: 4,
      ), // Chạy chậm lại một chút để mượt hơn
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
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            size: Size.infinite,
            painter: SineWavePainter(
              // Truyền giá trị animation để tính toán pha của sóng
              phase: _controller.value * 2 * math.pi,
              context: context,
            ),
          );
        },
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

    // --- ĐIỀU CHỈNH BIÊN ĐỘ BIẾN THIÊN (15 - 30) ---
    // math.sin(phase * 0.5) tạo ra giá trị từ -1 đến 1 chạy chậm bằng nửa tốc độ sóng
    // Chúng ta chuẩn hóa nó về 0 đến 1, sau đó map vào khoảng 15 đến 30
    final double dynamicHeight =
        15.0 + (30.0 - 5) * ((math.sin(phase * 0.5) + 1) / 2);

    const double waveCount = 1.5;
    // Điểm bắt đầu (startY) trừ đi một khoảng để đường chéo kết thúc đẹp ở giữa màn hình
    final double startY = (size.height * 0.5);

    path.moveTo(0, startY);

    for (double x = 0; x <= size.width; x++) {
      double relativeX = x / size.width;

      // Hàm Sine chính với biên độ dynamicHeight đã tính ở trên
      double y =
          math.sin((relativeX * waveCount * 2 * math.pi) - phase) *
          dynamicHeight;

      // --- TẠO GÓC CHÉO 45 ĐỘ ---
      // Khi x tăng 1 đơn vị, y tăng 1 đơn vị => Góc 45 độ
      double diagonalOffset = x * 0;

      path.lineTo(x, startY + y + diagonalOffset);
    }

    // Khép kín để đổ màu nửa dưới
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(SineWavePainter oldDelegate) => oldDelegate.phase != phase;
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    final path = pathWithQuadraticBezierTo(size);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

Path pathWithQuadraticBezierTo(Size size) {
  final path = Path();

  // Bắt đầu từ góc trên bên trái (hoặc điểm bạn muốn)
  final startY = size.height * 0.4;
  path.moveTo(0, 0);
  path.lineTo(0, startY); // Đi xuống một chút trước khi bắt đầu sóng

  // Cấu hình sóng
  double waveCount = 2; // Số lượng ngọn sóng
  double waveHeight = 50; // Độ cao của sóng (biên độ)

  // Tính toán khoảng cách di chuyển cho mỗi đoạn sóng
  double stepX = size.width / waveCount;
  double stepY = size.height * 0.25 / waveCount;

  for (int i = 0; i < waveCount; i++) {
    // Điểm kết thúc của đoạn sóng hiện tại
    double endX = stepX * (i + 1);
    double endY = (startY) + (stepY * (i + 1));

    // Điểm giữa của đoạn thẳng (để đặt điểm điều khiển quanh đó)
    double midX = (stepX * i + endX) / 2;
    double midY = ((startY) + (stepY * i) + endY) / 2;

    // Đảo chiều sóng: i chẵn thì lồi lên, i lẻ thì lõm xuống
    double modifier = (i % 2 != 0) ? 1 : -1;

    // Vẽ đường cong:
    // Điểm điều khiển được đẩy vuông góc với trục chéo để tạo độ vồng
    path.quadraticBezierTo(
      midX - (waveHeight * modifier), // Di chuyển X của điểm điều khiển
      midY + (waveHeight * modifier), // Di chuyển Y của điểm điều khiển
      endX,
      endY,
    );
  }

  // Khép kín vùng chọn để đổ màu cho nửa dưới
  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();

  return path;
}

Path pathWithCubicTo(Size size) {
  final path = Path();

  path.moveTo(0, size.height * 0.5); // Điểm bắt đầu

  // cubicTo(cp1x, cp1y, cp2x, cp2y, endX, endY)
  path.cubicTo(
    size.width * 0.25,
    size.height * 0.4, // Điểm điều khiển 1 (kéo lên)
    size.width * 0.75,
    size.height * 0.6, // Điểm điều khiển 2 (kéo xuống)
    size.width,
    size.height * 0.5, // Điểm kết thúc
  );

  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();

  return path;
}

Path pathWithArcToPoint(Size size) {
  final path = Path();

  path.moveTo(0, size.height * 0.4);

  // Vẽ một cung tròn nối đến giữa màn hình
  path.arcToPoint(
    Offset(size.width * 0.5, size.height * 0.5),
    radius: Radius.circular(size.width * 0.5),
    clockwise: false,
  );

  // Vẽ tiếp một cung ngược lại
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
    // Công thức: y = sin(x) * biên độ + độ cao cơ bản
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

  path.moveTo(0, size.height * 0.5);

  // conicTo(cpx, cpy, endX, endY, weight)
  // weight > 1: Nhọn hơn (Hyperbola)
  // weight < 1: Bẹt hơn (Ellipse)
  path.conicTo(
    size.width * 0.5,
    size.height * 0.2,
    size.width,
    size.height * 0.5,
    .5, // Thử thay đổi số này từ 0.5 đến 5.0 để thấy sự khác biệt
  );

  path.lineTo(size.width, size.height);
  path.lineTo(0, size.height);
  path.close();

  return path;
}
