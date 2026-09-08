import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// A brand logo for PingMe featuring the signature pastel brand gradient:
/// Lime Green (#C8F0B0) -> Lavender (#E9D8F8) -> Soft Pink (#F7DFF3).
/// Includes layered speech glyphs, soft diffusion glow, and active presence ping.
class CustomAppLogo extends StatelessWidget {
  final double size;
  final bool showBadge;

  const CustomAppLogo({
    super.key,
    this.size = 100,
    this.showBadge = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Ambient back pastel glow
          Positioned.fill(
            child: Container(
              margin: EdgeInsets.all(size * 0.08),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(size * 0.30),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE9D8F8).withValues(alpha: 0.8),
                    blurRadius: size * 0.35,
                    spreadRadius: 2,
                    offset: Offset(0, size * 0.10),
                  ),
                  BoxShadow(
                    color: const Color(0xFFC8F0B0).withValues(alpha: 0.4),
                    blurRadius: size * 0.25,
                    spreadRadius: 1,
                    offset: Offset(-size * 0.06, -size * 0.06),
                  ),
                ],
              ),
            ),
          ),

          // Primary Gradient Squircle Icon Tile
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(size * 0.28),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.8),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomPaint(
              painter: _PingMeGlyphPainter(),
            ),
          ),

          // Active "Ping" Status Indicator
          if (showBadge)
            Positioned(
              top: -size * 0.03,
              right: -size * 0.03,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.onlineDot,
                  border: Border.all(
                    color: Colors.white,
                    width: size * 0.035,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onlineDot.withValues(alpha: 0.45),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ],
                ),
                child: Center(
                  child: Container(
                    width: size * 0.09,
                    height: size * 0.09,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _PingMeGlyphPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Frosted upper sheen
    final sheenPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.4),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.55));

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, w, h * 0.52),
        Radius.circular(w * 0.28),
      ),
      sheenPaint,
    );

    // 2. Secondary/Back speech bubble (clean soft translucent white)
    final backBubblePaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.55)
      ..style = PaintingStyle.fill;

    final backRRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(w * 0.60, h * 0.42),
        width: w * 0.44,
        height: h * 0.36,
      ),
      Radius.circular(w * 0.14),
    );
    canvas.drawRRect(backRRect, backBubblePaint);

    // 3. Primary Front Chat Bubble (Crisp Solid White with delicate shadow)
    final frontBubblePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

    final frontRect = Rect.fromCenter(
      center: Offset(w * 0.44, h * 0.56),
      width: w * 0.52,
      height: h * 0.42,
    );
    final frontRRect = RRect.fromRectAndRadius(
      frontRect,
      Radius.circular(w * 0.16),
    );

    // Rounded speech tail
    final tailPath = Path()
      ..moveTo(frontRect.left + w * 0.08, frontRect.bottom - h * 0.02)
      ..lineTo(frontRect.left - w * 0.04, frontRect.bottom + h * 0.07)
      ..quadraticBezierTo(
        frontRect.left + w * 0.02,
        frontRect.bottom + h * 0.04,
        frontRect.left + w * 0.18,
        frontRect.bottom,
      )
      ..close();

    final fullFrontPath = Path()
      ..addRRect(frontRRect)
      ..addPath(tailPath, Offset.zero);

    canvas.drawPath(fullFrontPath.shift(Offset(0, h * 0.02)), shadowPaint);
    canvas.drawPath(fullFrontPath, frontBubblePaint);

    // 4. Three minimal dark dots inside front bubble (AppColors.textPrimary)
    final dotPaint = Paint()
      ..color = const Color(0xFF111111)
      ..style = PaintingStyle.fill;

    final dotY = frontRect.center.dy;
    final dotSpacing = w * 0.10;
    final dotRadius = w * 0.032;

    canvas.drawCircle(Offset(frontRect.center.dx - dotSpacing, dotY), dotRadius, dotPaint);
    canvas.drawCircle(Offset(frontRect.center.dx, dotY), dotRadius, dotPaint);
    canvas.drawCircle(Offset(frontRect.center.dx + dotSpacing, dotY), dotRadius, dotPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
