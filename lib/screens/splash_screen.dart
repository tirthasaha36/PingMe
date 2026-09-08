import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinished;
  const SplashScreen({super.key, this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _decorFade;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _logoScale = Tween<double>(begin: 0.88, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    _logoFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.35, curve: Curves.easeIn),
    );

    _contentSlide = Tween<Offset>(
      begin: const Offset(0, 0.12),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.18, 0.52, curve: Curves.easeOutCubic),
      ),
    );

    _contentFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.18, 0.48, curve: Curves.easeOut),
    );

    _decorFade = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.28, 0.65, curve: Curves.easeOut),
    );

    _progressAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.25, 0.92, curve: Curves.easeInOutCubic),
    );

    _animController.forward();

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(milliseconds: 350), () {
          if (mounted && widget.onFinished != null) {
            widget.onFinished!();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F3),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxHeight < 680;
          final logoSize = isSmallScreen ? 98.0 : 118.0;
          final screenH = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ── 1. Background painter (top circular halo, connecting swoosh, silky waves) ──
              Positioned.fill(
                child: CustomPaint(
                  painter: _SplashBackgroundPainter(),
                ),
              ),

              // ── 2. Top-left floating frosted chat bubble (3 green dots) ──
              Positioned(
                top: screenH * 0.165,
                left: 36,
                child: FadeTransition(
                  opacity: _decorFade,
                  child: _buildTopLeftChatBubble(),
                ),
              ),

              // ── 3. Top-right floating heart bubble + sparkles ──
              Positioned(
                top: screenH * 0.20,
                right: 32,
                child: FadeTransition(
                  opacity: _decorFade,
                  child: _buildHeartBubbleWithSparkles(),
                ),
              ),

              // ── 4. Handwritten quote "Good Conversations Brighter Days" ──
              Positioned(
                right: 28,
                top: screenH * 0.625,
                child: FadeTransition(
                  opacity: _decorFade,
                  child: Transform.rotate(
                    angle: -10 * math.pi / 180,
                    alignment: Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good',
                          style: GoogleFonts.caveat(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFBCA6EA).withValues(alpha: 0.85),
                            height: 1.05,
                          ),
                        ),
                        Text(
                          'Conversations',
                          style: GoogleFonts.caveat(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFBCA6EA).withValues(alpha: 0.85),
                            height: 1.05,
                          ),
                        ),
                        Text(
                          'Brighter Days',
                          style: GoogleFonts.caveat(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFBCA6EA).withValues(alpha: 0.85),
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 2),
                        CustomPaint(
                          size: const Size(88, 10),
                          painter: _UnderlineDoodlePainter(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── 5. Main centered content ──
              Positioned.fill(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Spacer(flex: 8),

                        // Logo with sparkle accents & active beacon badge
                        Center(
                          child: Stack(
                            clipBehavior: Clip.none,
                            alignment: Alignment.center,
                            children: [
                              // Top-left sparkle ticks
                              Positioned(
                                left: -22,
                                top: -18,
                                child: FadeTransition(
                                  opacity: _decorFade,
                                  child: CustomPaint(
                                    size: const Size(26, 26),
                                    painter: _LeftSparklesPainter(),
                                  ),
                                ),
                              ),

                              // Pixel-exact PingMe App Logo
                              FadeTransition(
                                opacity: _logoFade,
                                child: ScaleTransition(
                                  scale: _logoScale,
                                  child: _PingMeLogo(size: logoSize),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Brand Name + Tagline + Accent Pill
                        SlideTransition(
                          position: _contentSlide,
                          child: FadeTransition(
                            opacity: _contentFade,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'PingMe',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: isSmallScreen ? 34 : 40,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.8,
                                    color: const Color(0xFF101014),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Fast, soft & beautifully connected',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF6B6B70),
                                    letterSpacing: 0.1,
                                  ),
                                ),
                                const SizedBox(height: 15),

                                // Signature gradient accent pill
                                Container(
                                  width: 76,
                                  height: 6.5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFFBAF1A4),
                                        Color(0xFFD6C0F7),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const Spacer(flex: 10),

                        // Bottom: gradient progress bar + E2E badge
                        FadeTransition(
                          opacity: _contentFade,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Gradient progress bar
                              Container(
                                width: 126,
                                height: 4.5,
                                clipBehavior: Clip.antiAlias,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE5E5E2),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: AnimatedBuilder(
                                  animation: _progressAnimation,
                                  builder: (context, child) {
                                    return FractionallySizedBox(
                                      alignment: Alignment.centerLeft,
                                      widthFactor: _progressAnimation.value
                                          .clamp(0.0, 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          gradient: const LinearGradient(
                                            colors: [
                                              Color(0xFF38C966),
                                              Color(0xFF4FAAF5),
                                              Color(0xFF9D84F5),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Lock + E2E ENCRYPTED
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.lock_outline_rounded,
                                    size: 12.5,
                                    color: Color(0xFF868688),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'E2E ENCRYPTED',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1.6,
                                      color: const Color(0xFF868688),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Floating frosted chat bubble with 3 green dots ──
  Widget _buildTopLeftChatBubble() {
    return Container(
      width: 50,
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.circular(4),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF90DC76).withValues(alpha: 0.16),
            blurRadius: 16,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return Container(
              width: 5.5,
              height: 5.5,
              margin: const EdgeInsets.symmetric(horizontal: 2.2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFA1E392),
              ),
            );
          }),
        ),
      ),
    );
  }

  // ── Floating heart bubble with sparkle ticks ──
  Widget _buildHeartBubbleWithSparkles() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          top: -10,
          right: -10,
          child: CustomPaint(
            size: const Size(20, 20),
            painter: _RightHeartSparklesPainter(),
          ),
        ),
        Container(
          width: 48,
          height: 38,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.94),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(16),
              bottomRight: Radius.circular(4),
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC7B1F3).withValues(alpha: 0.22),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.favorite_rounded,
              size: 19,
              color: Color(0xFFC7ABF6),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Pixel-accurate PingMe App Logo Widget
// ═══════════════════════════════════════════════════════════════════
class _PingMeLogo extends StatelessWidget {
  final double size;
  const _PingMeLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // ── Gradient Squircle Background ──
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(size * 0.26),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFC8F0A7), // Delicate vibrant lime
                  Color(0xFFE2ECC4),
                  Color(0xFFE5D0F9),
                  Color(0xFFECC9F3), // Soft lavender pink
                ],
                stops: [0.0, 0.35, 0.70, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFFB898EE).withValues(alpha: 0.28),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
          ),

          // ── Overlapping Speech Bubbles ──
          // Rear translucent bubble
          Positioned(
            right: size * 0.17,
            top: size * 0.25,
            child: Container(
              width: size * 0.44,
              height: size * 0.34,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.55),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.13),
                  topRight: Radius.circular(size * 0.13),
                  bottomLeft: Radius.circular(size * 0.13),
                  bottomRight: Radius.circular(size * 0.03),
                ),
              ),
            ),
          ),

          // Front crisp white speech bubble with 3 black dots
          Positioned(
            left: size * 0.18,
            bottom: size * 0.26,
            child: Container(
              width: size * 0.50,
              height: size * 0.38,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(size * 0.14),
                  topRight: Radius.circular(size * 0.14),
                  bottomRight: Radius.circular(size * 0.14),
                  bottomLeft: Radius.circular(size * 0.03),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(3, (index) {
                    return Container(
                      width: size * 0.062,
                      height: size * 0.062,
                      margin: EdgeInsets.symmetric(horizontal: size * 0.016),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF141416),
                      ),
                    );
                  }),
                ),
              ),
            ),
          ),

          // ── Top-Right Active Notification Badge (Green beacon ring) ──
          Positioned(
            top: -size * 0.03,
            right: -size * 0.03,
            child: Container(
              width: size * 0.31,
              height: size * 0.31,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38C722).withValues(alpha: 0.30),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: EdgeInsets.all(size * 0.035),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF3CD124),
                    width: size * 0.035,
                  ),
                ),
                child: Center(
                  child: Container(
                    width: size * 0.09,
                    height: size * 0.09,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFF3CD124),
                    ),
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

// ═══════════════════════════════════════════════════════════════════
// Background Painter — Top halo, connecting line, flowing silk waves
// ═══════════════════════════════════════════════════════════════════
class _SplashBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final full = Rect.fromLTWH(0, 0, w, h);

    // ── 1. Top-Left Lime Circular Halo with Contoured Edge ──
    final haloCenter = Offset(w * 0.12, h * 0.05);
    final haloRadius = w * 0.56;

    final haloFillPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.95,
        colors: [
          const Color(0xFFCBF1AC).withValues(alpha: 0.76),
          const Color(0xFFDAF5BE).withValues(alpha: 0.52),
          const Color(0xFFE7F9D6).withValues(alpha: 0.25),
          Colors.transparent,
        ],
        stops: const [0.0, 0.45, 0.80, 1.0],
      ).createShader(Rect.fromCircle(center: haloCenter, radius: haloRadius));
    canvas.drawCircle(haloCenter, haloRadius, haloFillPaint);

    // Delicate translucent white rim defining the top halo
    final haloRimPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.70)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;
    canvas.drawCircle(haloCenter, haloRadius, haloRimPaint);

    // ── 2. Graceful connecting curved line ──
    final arcRight = Path()
      ..moveTo(w * 0.95, h * 0.24)
      ..cubicTo(w * 0.75, h * 0.29, w * 0.48, h * 0.335, w * 0.12, h * 0.36);
    canvas.drawPath(
      arcRight,
      Paint()
        ..color = const Color(0xFFCBB8F5).withValues(alpha: 0.48)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.15
        ..strokeCap = StrokeCap.round,
    );

    final rimWidth = w * 0.0035;

    // ── 3. Wave 1: Soft upper lavender wave ──
    final wave1Top = Path()
      ..moveTo(0, h * 0.62)
      ..cubicTo(w * 0.18, h * 0.66, w * 0.32, h * 0.78, w * 0.52, h * 0.84)
      ..cubicTo(w * 0.70, h * 0.89, w * 0.88, h * 0.88, w, h * 0.91);

    final wave1Fill = Path.from(wave1Top)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(
      wave1Fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFEBDCFB).withValues(alpha: 0.64),
            const Color(0xFFDCC3F8).withValues(alpha: 0.54),
          ],
        ).createShader(full),
    );

    // ── 4. Wave 2: Middle layered lavender ribbon ──
    final wave2Top = Path()
      ..moveTo(0, h * 0.705)
      ..cubicTo(w * 0.16, h * 0.705, w * 0.28, h * 0.815, w * 0.45, h * 0.875)
      ..cubicTo(w * 0.62, h * 0.930, w * 0.78, h * 0.900, w, h * 0.945);

    final wave2Fill = Path.from(wave2Top)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(
      wave2Fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFDFCCF8).withValues(alpha: 0.58),
            const Color(0xFFD1AFF6).withValues(alpha: 0.45),
          ],
        ).createShader(full),
    );

    // ── 5. Wave 3: Bottom-Right Lime Green Swell ──
    final greenTop = Path()
      ..moveTo(w * 0.48, h)
      ..cubicTo(w * 0.60, h * 0.91, w * 0.76, h * 0.81, w * 0.90, h * 0.78)
      ..cubicTo(w * 0.94, h * 0.775, w * 0.97, h * 0.78, w, h * 0.785);

    final greenFill = Path.from(greenTop)
      ..lineTo(w, h)
      ..close();

    canvas.drawPath(
      greenFill,
      Paint()
        ..shader = LinearGradient(
          begin: const Alignment(0.7, 0.4),
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFFCAF4AB).withValues(alpha: 0.66),
            const Color(0xFFDEF7C0).withValues(alpha: 0.52),
          ],
        ).createShader(full),
    );

    // ── 6. Wave 4: Lowest sheer lavender veil ──
    final wave4Top = Path()
      ..moveTo(0, h * 0.80)
      ..cubicTo(w * 0.22, h * 0.83, w * 0.48, h * 0.97, w * 0.78, h * 0.95)
      ..cubicTo(w * 0.88, h * 0.94, w * 0.95, h * 0.96, w, h * 0.975);

    final wave4Fill = Path.from(wave4Top)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    canvas.drawPath(
      wave4Fill,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [
            const Color(0xFFE2D1F8).withValues(alpha: 0.52),
            const Color(0xFFCDB0F3).withValues(alpha: 0.38),
          ],
        ).createShader(full),
    );

    // ── 7. Soft silk highlights along the wave crests ──
    final rimPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = rimWidth
      ..color = Colors.white.withValues(alpha: 0.75);

    canvas.drawPath(wave1Top, rimPaint);
    canvas.drawPath(
      wave2Top,
      rimPaint..color = Colors.white.withValues(alpha: 0.55),
    );
    canvas.drawPath(
      greenTop,
      rimPaint..color = Colors.white.withValues(alpha: 0.80),
    );
    canvas.drawPath(
      wave4Top,
      rimPaint..color = Colors.white.withValues(alpha: 0.40),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════
// Left Sparkle Ticks (upper-left of logo)
// ═══════════════════════════════════════════════════════════════════
class _LeftSparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFB99FEC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round;

    // Lower-left tick
    canvas.drawLine(const Offset(3, 17), const Offset(11, 12), paint);
    // Upper tick
    canvas.drawLine(const Offset(15, 8), const Offset(18, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════
// Right Sparkle Ticks (near heart bubble)
// ═══════════════════════════════════════════════════════════════════
class _RightHeartSparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC7B1F3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(2, 11), const Offset(7, 5), paint);
    canvas.drawLine(const Offset(10, 3), const Offset(16, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════
// Double Curved Underline Doodle (under "Brighter Days")
// ═══════════════════════════════════════════════════════════════════
class _UnderlineDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBCA6EA).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final path1 = Path()
      ..moveTo(2, 3)
      ..quadraticBezierTo(size.width * 0.5, 7.5, size.width - 2, 2.5);
    canvas.drawPath(path1, paint);

    final path2 = Path()
      ..moveTo(12, 7.5)
      ..quadraticBezierTo(size.width * 0.58, 11.5, size.width - 12, 7);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}