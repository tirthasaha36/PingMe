import 'dart:math' as math;
import 'package:flutter/material.dart';

class CustomAppLogo extends StatelessWidget {
  final double size;
  const CustomAppLogo({super.key, this.size = 110});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Whimsical spark accent top right
        Positioned(
          top: 0,
          right: 4,
          child: CustomPaint(
            size: const Size(26, 26),
            painter: _RaysPainter(),
          ),
        ),
        // Main rounded squircle
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFF907AFE), // Vibrant soft periwinkle purple
            borderRadius: BorderRadius.circular(size * 0.32),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF907AFE).withValues(alpha: 0.38),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: CustomPaint(
            size: Size(size * 0.58, size * 0.58),
            painter: _WinkingBubblePainter(),
          ),
        ),
      ],
    );
  }
}

class _WinkingBubblePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw smooth organic rounded speech bubble
    final rrect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(size.width * 0.50, size.height * 0.48),
        width: size.width * 0.88,
        height: size.height * 0.80,
      ),
      Radius.circular(size.width * 0.38),
    );

    final path = Path()..addRRect(rrect);

    // Cute curved speech tail at bottom-left
    final tailPath = Path()
      ..moveTo(size.width * 0.28, size.height * 0.76)
      ..quadraticBezierTo(
        size.width * 0.14,
        size.height * 0.88,
        size.width * 0.08,
        size.height * 0.96,
      )
      ..quadraticBezierTo(
        size.width * 0.24,
        size.height * 0.90,
        size.width * 0.44,
        size.height * 0.82,
      )
      ..close();

    path.addPath(tailPath, Offset.zero);
    canvas.drawPath(path, paint);

    // Face ink
    final eyePaint = Paint()
      ..color = const Color(0xFF231C3D)
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.075
      ..strokeCap = StrokeCap.round;

    final fillInk = Paint()
      ..color = const Color(0xFF231C3D)
      ..style = PaintingStyle.fill;

    // Left eye (wink - cute curved line `⌒`)
    final leftWink = Path()
      ..moveTo(size.width * 0.30, size.height * 0.50)
      ..quadraticBezierTo(
        size.width * 0.40,
        size.height * 0.40,
        size.width * 0.48,
        size.height * 0.49,
      );
    canvas.drawPath(leftWink, eyePaint);

    // Right eye (solid happy dot)
    canvas.drawCircle(
      Offset(size.width * 0.68, size.height * 0.46),
      size.width * 0.075,
      fillInk,
    );

    // Cute open smile (curved bottom)
    final mouthPath = Path()
      ..moveTo(size.width * 0.45, size.height * 0.58)
      ..quadraticBezierTo(
        size.width * 0.55,
        size.height * 0.74,
        size.width * 0.65,
        size.height * 0.58,
      )
      ..close();
    canvas.drawPath(mouthPath, fillInk);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RaysPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rayPaint = Paint()
      ..color = const Color(0xFF907AFE)
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    // Ray 1
    canvas.drawLine(
      Offset(size.width * 0.3, size.height * 0.8),
      Offset(size.width * 0.7, size.height * 0.4),
      rayPaint,
    );
    // Ray 2
    canvas.drawLine(
      Offset(size.width * 0.8, size.height * 0.9),
      Offset(size.width * 1.0, size.height * 0.7),
      rayPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
