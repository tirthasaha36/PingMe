import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';

/// Controller & Wrapper for Telegram-style radial ripple theme transitions.
///
/// When the theme is toggled, it snapshots the current screen, flips the app's
/// theme instantly underneath, and expands the new theme outward in a smooth
/// circular clip centered at the tap coordinates (or toggle button), sweeping
/// across the entire screen without any layout shifts or flicker.
class CircularThemeTransition extends StatefulWidget {
  final Widget child;

  const CircularThemeTransition({
    super.key,
    required this.child,
  });

  static CircularThemeTransitionState? of(BuildContext context) {
    return context.findAncestorStateOfType<CircularThemeTransitionState>();
  }

  @override
  State<CircularThemeTransition> createState() => CircularThemeTransitionState();
}

class CircularThemeTransitionState extends State<CircularThemeTransition>
    with SingleTickerProviderStateMixin {
  final GlobalKey _repaintBoundaryKey = GlobalKey();
  late AnimationController _animController;

  ui.Image? _snapshotImage;
  Offset _origin = Offset.zero;
  bool _isTransitioning = false;
  bool _isTransitioningToDark = true;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isTransitioning = false;
          _snapshotImage?.dispose();
          _snapshotImage = null;
        });
        _animController.reset();
      }
    });
  }

  @override
  void dispose() {
    _animController.dispose();
    _snapshotImage?.dispose();
    super.dispose();
  }

  /// Triggers a Telegram-like radial ripple transition starting from [globalPosition].
  /// Light -> Dark expands outward in a sweeping radial reveal.
  /// Dark -> Light contracts the dark theme inward back into the origin point.
  Future<void> toggleThemeFrom({Offset? globalPosition}) async {
    if (_isTransitioning) return;

    // Haptic feedback for tactile feel
    HapticFeedback.lightImpact();

    try {
      final boundary = _repaintBoundaryKey.currentContext
          ?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null || !boundary.hasSize) {
        ThemeController.instance.toggleTheme();
        return;
      }

      final pixelRatio = MediaQuery.of(context).devicePixelRatio;
      final image = await boundary.toImage(pixelRatio: pixelRatio);

      final size = MediaQuery.of(context).size;
      final center = globalPosition ?? Offset(size.width - 40, 50);
      final willBeDark = !ThemeController.instance.isDarkMode;

      setState(() {
        _snapshotImage = image;
        _origin = center;
        _isTransitioning = true;
        _isTransitioningToDark = willBeDark;
      });

      // Ensure snapshot is drawn before switching theme underneath to guarantee zero flicker
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ThemeController.instance.toggleTheme();
        _animController.forward(from: 0.0);
      });
    } catch (e) {
      // Fallback in case image snapshot fails
      ThemeController.instance.toggleTheme();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // The active app tree inside RepaintBoundary
        RepaintBoundary(
          key: _repaintBoundaryKey,
          child: widget.child,
        ),

        // Radial reveal overlay
        if (_isTransitioning && _snapshotImage != null)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _animController,
                builder: (context, _) {
                  final curvedValue = Curves.easeInOutCubic.transform(
                    _animController.value,
                  );
                  return CustomPaint(
                    painter: _RadialRevealPainter(
                      oldSnapshot: _snapshotImage!,
                      center: _origin,
                      progress: curvedValue,
                      isTransitioningToDark: _isTransitioningToDark,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

class _RadialRevealPainter extends CustomPainter {
  final ui.Image oldSnapshot;
  final Offset center;
  final double progress;
  final bool isTransitioningToDark;

  _RadialRevealPainter({
    required this.oldSnapshot,
    required this.center,
    required this.progress,
    required this.isTransitioningToDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Calculate maximum distance to the 4 viewport corners from the origin
    final double dTopLeft = (center - Offset.zero).distance;
    final double dTopRight = (center - Offset(size.width, 0)).distance;
    final double dBottomLeft = (center - Offset(0, size.height)).distance;
    final double dBottomRight =
        (center - Offset(size.width, size.height)).distance;

    final double maxRadius = math.max(
      math.max(dTopLeft, dTopRight),
      math.max(dBottomLeft, dBottomRight),
    );

    canvas.save();

    final Path clipPath = Path();

    if (isTransitioningToDark) {
      // Light -> Dark: Expanding circle reveals the new dark theme underneath
      // We draw the old snapshot outside of the expanding circle
      final double currentRadius = maxRadius * progress;

      clipPath
        ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
        ..addOval(Rect.fromCircle(center: center, radius: currentRadius))
        ..fillType = PathFillType.evenOdd;

      canvas.clipPath(clipPath);

      final srcRect = Rect.fromLTWH(
        0,
        0,
        oldSnapshot.width.toDouble(),
        oldSnapshot.height.toDouble(),
      );
      final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);

      final paint = Paint()
        ..filterQuality = FilterQuality.medium
        ..isAntiAlias = true;

      canvas.drawImageRect(oldSnapshot, srcRect, dstRect, paint);

      canvas.restore();

      // Subtle luminous ripple ring on the expanding edge
      if (progress > 0.02 && progress < 0.98) {
        final ringPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..color = const Color(0xFFC8F0B0).withValues(alpha: (1.0 - progress) * 0.45);

        canvas.drawCircle(center, currentRadius, ringPaint);
      }
    } else {
      // Dark -> Light: The dark theme (snapshot) shrinks/collapses back into the origin circle!
      // The new light theme is already underneath, unveiled from the outer edges inward.
      final double currentRadius = maxRadius * (1.0 - progress);

      // Clip strictly inside the shrinking circle so the old dark snapshot only shows inside it
      clipPath.addOval(Rect.fromCircle(center: center, radius: currentRadius));

      canvas.clipPath(clipPath);

      final srcRect = Rect.fromLTWH(
        0,
        0,
        oldSnapshot.width.toDouble(),
        oldSnapshot.height.toDouble(),
      );
      final dstRect = Rect.fromLTWH(0, 0, size.width, size.height);

      final paint = Paint()
        ..filterQuality = FilterQuality.medium
        ..isAntiAlias = true;

      canvas.drawImageRect(oldSnapshot, srcRect, dstRect, paint);

      canvas.restore();

      // Subtle lavender-tinted contracting ring on the collapsing edge
      if (progress > 0.02 && progress < 0.98) {
        final ringPaint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0
          ..color = const Color(0xFF8E6BA8).withValues(alpha: (1.0 - progress) * 0.45);

        canvas.drawCircle(center, currentRadius, ringPaint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _RadialRevealPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.center != center ||
        oldDelegate.oldSnapshot != oldSnapshot ||
        oldDelegate.isTransitioningToDark != isTransitioningToDark;
  }
}
