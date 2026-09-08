import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/app_logo.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback? onFinished;
  const SplashScreen({super.key, this.onFinished});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _progressController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();
    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    );

    _progressAnimation = CurvedAnimation(
      parent: _progressController,
      curve: Curves.easeInOutCubic,
    );

    _progressController.forward();

    _progressController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Timer(const Duration(milliseconds: 400), () {
          if (mounted && widget.onFinished != null) {
            widget.onFinished!();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFECEFF8), // Soft soothing backdrop for wide screens
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 600;
          final content = _buildSplashContent(context);

          if (!isWide) {
            return content;
          }

          // On Tablet / Desktop / Web: Center in phone proportions with subtle shadow
          return Center(
            child: Container(
              width: 440,
              height: constraints.maxHeight.clamp(650.0, 920.0),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: const Color(0xFFFBF8F3),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 36,
                    offset: const Offset(0, 14),
                  ),
                ],
              ),
              child: content,
            ),
          );
        },
      ),
    );
  }

  Widget _buildSplashContent(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      fit: StackFit.expand,
      children: [
          // 1. Background Illustration
          Image.asset(
            'assets/images/splash_bg.jpg',
            fit: BoxFit.cover,
            alignment: Alignment.center,
            errorBuilder: (context, error, stackTrace) {
              // Graceful fallback if asset is loading or missing
              return Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFEBEFFB), Color(0xFFF9F5F0)],
                  ),
                ),
              );
            },
          ),

          // Subtle gradient overlay for header readability
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: size.height * 0.40,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withValues(alpha: 0.55),
                    Colors.white.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // 2. Playful Ambient Floating Text Annotations
          // "Good People Brighter Days :)" on the right (in clear sky above the heart bubble)
          Positioned(
            right: 18,
            top: size.height * 0.31,
            child: Transform.rotate(
              angle: 0.08,
              child: Text(
                'Good\nPeople\nBrighter\nDays\n:)',
                textAlign: TextAlign.center,
                style: GoogleFonts.caveat(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF63564A),
                  height: 1.15,
                ),
              ),
            ),
          ),

          // "Better Conversations Ahead ..." on the wall (moved rightwards and downwards)
          Positioned(
            left: 60,
            top: size.height * 0.71,
            child: Transform.rotate(
              angle: -0.10,
              child: Text(
                'Better\nConversations\nAhead\n...',
                textAlign: TextAlign.left,
                style: GoogleFonts.caveat(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF5F544A).withValues(alpha: 0.92),
                  height: 1.2,
                ),
              ),
            ),
          ),

          // "Same Chats New Stories ♡" pinned paper note (lower right wall)
          Positioned(
            right: 28,
            top: size.height * 0.72,
            child: Transform.rotate(
              angle: 0.04,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 9),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDFBF5).withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 6,
                      offset: const Offset(1, 3),
                    ),
                  ],
                ),
                child: Text(
                  'Same\nChats\nNew\nStories\n♡',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.caveat(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4E4238),
                    height: 1.15,
                  ),
                ),
              ),
            ),
          ),

          // 3. Top Branding Area: Logo, Title, Subtitle
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 84.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Brand Icon
                    const CustomAppLogo(size: 96),
                    const SizedBox(height: 18),

                    // App Name: "PingMe"
                    Text(
                      'PingMe',
                      style: GoogleFonts.fredoka(
                        fontSize: 44,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.5,
                        color: const Color(0xFF1B142D),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Tagline: "Talk. Share. Be You."
                    Text(
                      'Talk. Share. Be You.',
                      style: GoogleFonts.caveat(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF554D60),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // 4. Bottom Loading Bar & "LOADING GOOD VIBES..."
          Positioned(
            bottom: 56,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Custom Rounded Progress Bar
                Container(
                  width: 130,
                  height: 8,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDD7F6).withValues(alpha: 0.7),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: AnimatedBuilder(
                    animation: _progressAnimation,
                    builder: (context, child) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: 130 * _progressAnimation.value,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B72FF), Color(0xFF7052FF)],
                            ),
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B72FF).withValues(alpha: 0.4),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),

                // "LOADING GOOD VIBES..."
                Text(
                  'L O A D I N G   G O O D   V I B E S . . .',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.8,
                    color: const Color(0xFF6B6175).withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}
