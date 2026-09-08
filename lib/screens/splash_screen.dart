import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import '../widgets/app_logo.dart';

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
      begin: const Offset(0, 0.14),
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
      backgroundColor: const Color(0xFFFBFBF9),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxHeight < 680;
          final logoSize = isSmallScreen ? 94.0 : 116.0;
          final screenH = constraints.maxHeight;

          return Stack(
            fit: StackFit.expand,
            children: [
              // ── 1. Full background painter (waves, glow, connecting curves) ──
              Positioned.fill(
                child: CustomPaint(
                  painter: _SplashBackgroundPainter(),
                ),
              ),


              // ── 3. Upper-left floating white chat bubble (3 green dots) ──
              Positioned(
                top: screenH * 0.18,
                left: 30,
                child: FadeTransition(
                  opacity: _decorFade,
                  child: _buildTopLeftChatBubble(),
                ),
              ),

              // ── 4. Upper-right floating heart bubble + sparkles ──
              Positioned(
                top: screenH * 0.20,
                right: 30,
                child: FadeTransition(
                  opacity: _decorFade,
                  child: _buildHeartBubbleWithSparkles(),
                ),
              ),

              // ── 5. Handwritten quote "Good Conversations Brighter Days" ──
              Positioned(
                right: 28,
                top: screenH * 0.61,
                child: FadeTransition(
                  opacity: _decorFade,
                  child: Transform.rotate(
                    angle: -8 * math.pi / 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good',
                          style: GoogleFonts.caveat(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC0ADE8).withValues(alpha: 0.80),
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'Conversations',
                          style: GoogleFonts.caveat(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC0ADE8).withValues(alpha: 0.80),
                            height: 1.1,
                          ),
                        ),
                        Text(
                          'Brighter Days',
                          style: GoogleFonts.caveat(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC0ADE8).withValues(alpha: 0.80),
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 2),
                        CustomPaint(
                          size: const Size(90, 10),
                          painter: _UnderlineDoodlePainter(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ── 6. Main centered content ──
              Positioned.fill(
                child: SafeArea(
                  child: SizedBox(
                    width: double.infinity,
                    height: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Spacer(flex: 7),

                          // Logo with sparkle accents
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                // Left sparkle ticks
                                Positioned(
                                  left: -24,
                                  top: -16,
                                  child: FadeTransition(
                                    opacity: _decorFade,
                                    child: CustomPaint(
                                      size: const Size(28, 28),
                                      painter: _LeftSparklesPainter(),
                                    ),
                                  ),
                                ),
                                // Main PingMe App Logo
                                FadeTransition(
                                  opacity: _logoFade,
                                  child: ScaleTransition(
                                    scale: _logoScale,
                                    child: CustomAppLogo(
                                      size: logoSize,
                                      showBadge: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 28),

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
                                      fontSize: isSmallScreen ? 32 : 38,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: -0.8,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    'Fast, soft & beautifully connected',
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 14.5,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF6E6E6E),
                                      letterSpacing: 0.1,
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Signature gradient accent pill (Green → Lavender)
                                  Container(
                                    width: 82,
                                    height: 7,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFBCEFB0),
                                          Color(0xFFE2CBF8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(flex: 9),

                          // Bottom: gradient progress bar + E2E badge
                          FadeTransition(
                            opacity: _contentFade,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Gradient progress bar
                                Container(
                                  width: 130,
                                  height: 5,
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
                                        widthFactor: _progressAnimation.value.clamp(0.0, 1.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF55C778),
                                                Color(0xFF5CB8E4),
                                                Color(0xFF9F8CF1),
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
                                      size: 13,
                                      color: Color(0xFF888886),
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'E2E ENCRYPTED',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1.4,
                                        color: const Color(0xFF888886),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 18),
                        ],
                      ),
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

  // ── Floating white chat bubble with 3 green dots ──
  Widget _buildTopLeftChatBubble() {
    return Container(
      width: 52,
      height: 42,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.92),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
          bottomLeft: Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF89D66E).withValues(alpha: 0.14),
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
              width: 6,
              height: 6,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFA5E398),
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
        // Sparkle ticks above-right
        Positioned(
          top: -10,
          right: -10,
          child: CustomPaint(
            size: const Size(20, 20),
            painter: _RightHeartSparklesPainter(),
          ),
        ),
        // Heart bubble
        Container(
          width: 50,
          height: 40,
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
                color: const Color(0xFFC7B1F3).withValues(alpha: 0.20),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.favorite_rounded,
              size: 20,
              color: Color(0xFFD2B5F8),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════
// Background Painter — waves, connecting curves, bottom glow
// ═══════════════════════════════════════════════════════════════════
class _SplashBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // ── 1. Soft lime-green ambient glow (top-left quadrant) ──
    final limePaint = Paint()
      ..shader = const RadialGradient(
        center: Alignment(-0.75, -0.75),
        radius: 0.70,
        colors: [
          Color(0x35C8F0B0),
          Color(0x18C8F0B0),
          Color(0x00C8F0B0),
        ],
        stops: [0.0, 0.50, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h), limePaint);

    // ── 2. Connecting curve — left bubble to center ──
    final arcPaintLeft = Paint()
      ..color = const Color(0xFFBFECA3).withValues(alpha: 0.50)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final arcLeft = Path()
      ..moveTo(w * 0.10, h * 0.22)
      ..quadraticBezierTo(w * 0.28, h * 0.26, w * 0.45, h * 0.33);
    canvas.drawPath(arcLeft, arcPaintLeft);

    // ── 3. Connecting curve — center to right bubble ──
    final arcPaintRight = Paint()
      ..color = const Color(0xFFDDD2F5).withValues(alpha: 0.42)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final arcRight = Path()
      ..moveTo(w * 0.55, h * 0.33)
      ..quadraticBezierTo(w * 0.76, h * 0.27, w * 0.92, h * 0.22);
    canvas.drawPath(arcRight, arcPaintRight);

    // ── 4. Bottom wave layer 1 — outermost, lightest, enters from left ──
    final wave1Fill = Path()
      ..moveTo(0, h * 0.72)
      ..cubicTo(w * 0.15, h * 0.78, w * 0.35, h * 0.80, w * 0.55, h * 0.76)
      ..cubicTo(w * 0.75, h * 0.72, w * 0.90, h * 0.78, w, h * 0.82)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final wave1Paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFD8F5C8).withValues(alpha: 0.40),
          const Color(0xFFE8DBFA).withValues(alpha: 0.35),
          const Color(0xFFF3EDFD).withValues(alpha: 0.20),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.68, w, h * 0.32));
    canvas.drawPath(wave1Fill, wave1Paint);

    // Rim highlight on wave 1
    final rim1 = Path()
      ..moveTo(0, h * 0.72)
      ..cubicTo(w * 0.15, h * 0.78, w * 0.35, h * 0.80, w * 0.55, h * 0.76)
      ..cubicTo(w * 0.75, h * 0.72, w * 0.90, h * 0.78, w, h * 0.82);
    canvas.drawPath(
      rim1,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.70)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // ── 5. Bottom wave layer 2 — middle lavender wave ──
    final wave2Fill = Path()
      ..moveTo(0, h * 0.79)
      ..cubicTo(w * 0.20, h * 0.84, w * 0.45, h * 0.91, w * 0.65, h * 0.86)
      ..cubicTo(w * 0.80, h * 0.82, w * 0.92, h * 0.86, w, h * 0.88)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final wave2Paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFE1CEF8).withValues(alpha: 0.55),
          const Color(0xFFF0E5FD).withValues(alpha: 0.35),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.75, w, h * 0.25));
    canvas.drawPath(wave2Fill, wave2Paint);

    // Rim highlight on wave 2
    final rim2 = Path()
      ..moveTo(0, h * 0.79)
      ..cubicTo(w * 0.20, h * 0.84, w * 0.45, h * 0.91, w * 0.65, h * 0.86)
      ..cubicTo(w * 0.80, h * 0.82, w * 0.92, h * 0.86, w, h * 0.88);
    canvas.drawPath(
      rim2,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.85)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.8,
    );

    // ── 6. Bottom wave layer 3 — innermost, deepest color ──
    final wave3Fill = Path()
      ..moveTo(0, h * 0.88)
      ..cubicTo(w * 0.25, h * 0.92, w * 0.50, h * 0.95, w * 0.75, h * 0.91)
      ..cubicTo(w * 0.88, h * 0.89, w * 0.95, h * 0.91, w, h * 0.93)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final wave3Paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          const Color(0xFFDCF0CC).withValues(alpha: 0.50),
          const Color(0xFFE3D6F8).withValues(alpha: 0.40),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.85, w, h * 0.15));
    canvas.drawPath(wave3Fill, wave3Paint);

    // Rim on wave 3
    final rim3 = Path()
      ..moveTo(0, h * 0.88)
      ..cubicTo(w * 0.25, h * 0.92, w * 0.50, h * 0.95, w * 0.75, h * 0.91)
      ..cubicTo(w * 0.88, h * 0.89, w * 0.95, h * 0.91, w, h * 0.93);
    canvas.drawPath(
      rim3,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.60)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.2,
    );


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════
// Left sparkle ticks (upper-left of logo)
// ═══════════════════════════════════════════════════════════════════
class _LeftSparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBCA1EC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;

    // Lower-left tick
    canvas.drawLine(const Offset(4, 18), const Offset(12, 13), paint);
    // Upper tick
    canvas.drawLine(const Offset(16, 9), const Offset(19, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════
// Right sparkle ticks (near heart bubble)
// ═══════════════════════════════════════════════════════════════════
class _RightHeartSparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBB6F2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(2, 12), const Offset(8, 5), paint);
    canvas.drawLine(const Offset(11, 3), const Offset(17, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════════════════════════════
// Double curved underline doodle (under "Brighter Days")
// ═══════════════════════════════════════════════════════════════════
class _UnderlineDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC0ADE8).withValues(alpha: 0.80)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round;

    final path1 = Path()
      ..moveTo(2, 3)
      ..quadraticBezierTo(size.width * 0.5, 7, size.width - 4, 2);
    canvas.drawPath(path1, paint);

    final path2 = Path()
      ..moveTo(10, 7.5)
      ..quadraticBezierTo(size.width * 0.55, 11, size.width - 14, 7);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
