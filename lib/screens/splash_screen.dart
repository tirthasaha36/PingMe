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

          return Stack(
            fit: StackFit.expand,
            children: [
              // 1. Background Organic Pastel Waves & Light Dotted Connection Path
              Positioned.fill(
                child: CustomPaint(
                  painter: _SplashBackgroundPainter(),
                ),
              ),

              // 2. Upper-Left White Chat Bubble Floating in Lime Aura
              Positioned(
                top: constraints.maxHeight * 0.16,
                left: 36,
                child: FadeTransition(
                  opacity: _decorFade,
                  child: _buildTopLeftChatBubble(),
                ),
              ),

              // 3. Upper-Right Floating Lavender Heart Bubble with Sparkles
              Positioned(
                top: constraints.maxHeight * 0.19,
                right: 34,
                child: FadeTransition(
                  opacity: _decorFade,
                  child: _buildHeartBubbleWithSparkles(),
                ),
              ),

              // 4. Handwritten Artistic Quote ("Good Conversations Brighter Days")
              Positioned(
                right: 32,
                top: constraints.maxHeight * 0.61,
                child: FadeTransition(
                  opacity: _decorFade,
                  child: Transform.rotate(
                    angle: -11 * math.pi / 180,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good',
                          style: GoogleFonts.caveat(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC0ADE8).withValues(alpha: 0.85),
                            height: 1.05,
                          ),
                        ),
                        Text(
                          'Conversations',
                          style: GoogleFonts.caveat(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC0ADE8).withValues(alpha: 0.85),
                            height: 1.05,
                          ),
                        ),
                        Text(
                          'Brighter Days',
                          style: GoogleFonts.caveat(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFC0ADE8).withValues(alpha: 0.85),
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 3),
                        // Double underline doodle
                        CustomPaint(
                          size: const Size(82, 10),
                          painter: _UnderlineDoodlePainter(),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // 5. Main Center Content (Logo, PingMe, Tagline, Upper Pill, Bottom Loader)
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

                          // Logo with Left Splash Sparkles
                          Center(
                            child: Stack(
                              clipBehavior: Clip.none,
                              alignment: Alignment.center,
                              children: [
                                // Left 2 decorative sparkle tick lines
                                Positioned(
                                  left: -22,
                                  top: -14,
                                  child: FadeTransition(
                                    opacity: _decorFade,
                                    child: CustomPaint(
                                      size: const Size(26, 26),
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

                          const SizedBox(height: 30),

                          // Brand Name "PingMe"
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

                                  const SizedBox(height: 18),

                                  // Signature Gradient Accent Pill
                                  Container(
                                    width: 78,
                                    height: 7.5,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFBCEFB0), // Pastel Lime Green
                                          Color(0xFFE2CBF8), // Soft Lavender
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const Spacer(flex: 9),

                          // Bottom E2E Encrypted Section & Gradient Progress Bar
                          FadeTransition(
                            opacity: _contentFade,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Gradient animated progress bar
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
                                        widthFactor: _progressAnimation.value.clamp(0.0, 1.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF55C778), // Fresh Green
                                                Color(0xFF5CB8E4), // Soft Cyan
                                                Color(0xFF9F8CF1), // Soft Purple
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),

                                const SizedBox(height: 14),

                                // E2E Encrypted label with outline lock icon
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

  Widget _buildTopLeftChatBubble() {
    return Container(
      width: 50,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.90),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(18),
          topRight: Radius.circular(18),
          bottomRight: Radius.circular(18),
          bottomLeft: Radius.circular(5),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF89D66E).withValues(alpha: 0.16),
            blurRadius: 14,
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
              margin: const EdgeInsets.symmetric(horizontal: 1.8),
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

  Widget _buildHeartBubbleWithSparkles() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Decorative tick rays above heart bubble
        Positioned(
          top: -9,
          right: -8,
          child: CustomPaint(
            size: const Size(18, 18),
            painter: _RightHeartSparklesPainter(),
          ),
        ),

        // Heart Bubble
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
                blurRadius: 12,
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

/// Paints the organic pastel lime/lavender background glow, sweeping silk waves,
/// and the subtle connecting trail line between the upper bubbles.
class _SplashBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Top-Left Lime Green Ambient Glow
    final limePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.85, -0.75),
        radius: 0.88,
        colors: [
          const Color(0xFFC5F3A8).withValues(alpha: 0.70),
          const Color(0xFFDAF7C5).withValues(alpha: 0.40),
          Colors.transparent,
        ],
        stops: const [0.0, 0.55, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, w, h * 0.5));
    canvas.drawRect(Rect.fromLTWH(0, 0, w, h * 0.5), limePaint);

    // 2. Subtle connection curve between top left bubble and center
    final arcPaint = Paint()
      ..color = const Color(0xFFBFECA3).withValues(alpha: 0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final arcPath = Path()
      ..moveTo(0, h * 0.22)
      ..quadraticBezierTo(w * 0.20, h * 0.23, w * 0.42, h * 0.32);
    canvas.drawPath(arcPath, arcPaint);

    // Secondary curve toward top-right heart bubble
    final arcPaintRight = Paint()
      ..color = const Color(0xFFDDD2F5).withValues(alpha: 0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final arcPathRight = Path()
      ..moveTo(w * 0.55, h * 0.32)
      ..quadraticBezierTo(w * 0.78, h * 0.27, w, h * 0.21);
    canvas.drawPath(arcPathRight, arcPaintRight);

    // 3. Flowing Silk Waves at the bottom (Lavender / Soft Purple layers)
    final wavePath1 = Path()
      ..moveTo(0, h * 0.60)
      ..cubicTo(w * 0.25, h * 0.70, w * 0.65, h * 0.85, w, h * 0.74)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final wavePaint1 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFE8DBFA).withValues(alpha: 0.50),
          const Color(0xFFF3EDFD).withValues(alpha: 0.25),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.55, w, h * 0.45));
    canvas.drawPath(wavePath1, wavePaint1);

    // Wave 2 with soft highlighted border line
    final wavePath2 = Path()
      ..moveTo(0, h * 0.68)
      ..cubicTo(w * 0.20, h * 0.81, w * 0.55, h * 0.88, w, h * 0.81)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();

    final wavePaint2 = Paint()
      ..shader = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFFE1CEF8).withValues(alpha: 0.55),
          const Color(0xFFF0E5FD).withValues(alpha: 0.30),
        ],
      ).createShader(Rect.fromLTWH(0, h * 0.65, w, h * 0.35));
    canvas.drawPath(wavePath2, wavePaint2);

    // Crisp subtle highlight rim on top of wave 2
    final waveRimPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8;

    final rimPath = Path()
      ..moveTo(0, h * 0.68)
      ..cubicTo(w * 0.20, h * 0.81, w * 0.55, h * 0.88, w, h * 0.81);
    canvas.drawPath(rimPath, waveRimPaint);

    // 4. Subtle Lime Green ambient light on bottom-right edge
    final bottomLimePaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(1.1, 0.95),
        radius: 0.7,
        colors: [
          const Color(0xFFDCF8CB).withValues(alpha: 0.60),
          Colors.transparent,
        ],
      ).createShader(Rect.fromLTWH(w * 0.4, h * 0.7, w * 0.6, h * 0.3));
    canvas.drawRect(Rect.fromLTWH(w * 0.4, h * 0.7, w * 0.6, h * 0.3), bottomLimePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints the 2 lavender sparkle ticks to the upper-left of the main logo
class _LeftSparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBCA1EC)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    // Outer tick
    canvas.drawLine(const Offset(4, 16), const Offset(12, 12), paint);
    // Upper tick
    canvas.drawLine(const Offset(16, 8), const Offset(18, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints the small sparkle ticks near the top-right heart bubble
class _RightHeartSparklesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFCBB6F2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(2, 10), const Offset(8, 4), paint);
    canvas.drawLine(const Offset(10, 2), const Offset(16, 0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Paints the double curved underline under "Brighter Days"
class _UnderlineDoodlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC0ADE8).withValues(alpha: 0.85)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round;

    final path1 = Path()
      ..moveTo(2, 3)
      ..quadraticBezierTo(size.width * 0.5, 6, size.width - 4, 2);
    canvas.drawPath(path1, paint);

    final path2 = Path()
      ..moveTo(8, 7.5)
      ..quadraticBezierTo(size.width * 0.55, 10, size.width - 12, 7);
    canvas.drawPath(path2, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
