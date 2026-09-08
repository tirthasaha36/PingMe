import 'package:flutter/material.dart';

/// Centralized Design System Colors for PingMe
/// Visual Style: Soft pastel surfaces + white cards + black typography + rounded components
class AppColors {
  AppColors._();

  // Core Background & Surfaces
  static const Color background = Color(0xFFF7F7F5); // Soft Warm Off-White (70%)
  static const Color surface = Color(0xFFFFFFFF); // White cards / chat surfaces
  static const Color surfaceSecondary = Color(0xFFEEEEEC); // Search bar / pills

  // Pastel Signature & Accent Palette
  static const Color lavender = Color(0xFFE9D8F8); // User messages / selected tabs (15%)
  static const Color limeGreen = Color(0xFFC8F0B0); // Active unread badge / accent (10%)
  static const Color softPink = Color(0xFFF7DFF3); // Small accents / attachment icons (5%)

  // Status & Presence
  static const Color onlineDot = Color(0xFF7BCB57); // Profile online dot
  static const Color onlineText = Color(0xFF5F8F45); // Status text
  static const Color typingText = Color(0xFF76B852); // "typing..." indicator
  static const Color offlineText = Color(0xFF999999);

  // Typography & CTAs
  static const Color textPrimary = Color(0xFF111111); // Deep obsidian/black for headings & main text
  static const Color textSecondary = Color(0xFF6B6B6B); // Subdued metadata / preview
  static const Color textPlaceholder = Color(0xFF999999);
  static const Color ctaBlack = Color(0xFF111111); // Primary buttons / Send / FAB

  // Borders, Dividers & Read Receipts
  static const Color border = Color(0xFFEAEAEA);
  static const Color divider = Color(0xFFF0F0EE);
  static const Color readReceipt = Color(0xFF8E6BA8); // Lavender-tinted violet read ticks

  // Semantic Colors
  static const Color error = Color(0xFFD94C4C);
  static const Color warning = Color(0xFFD99B3D);
  static const Color success = Color(0xFF6BA84F);

  // Brand Gradient: Lime Green -> Lavender -> Soft Pink
  static const LinearGradient brandGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFC8F0B0),
      Color(0xFFE9D8F8),
      Color(0xFFF7DFF3),
    ],
  );

  // ═════════════════════════════════════════════════════════════════
  // Dark Theme Palette Specification
  // ═════════════════════════════════════════════════════════════════
  // Core Levels
  static const Color darkBackground = Color(0xFF111111); // Level 0: Main app background
  static const Color darkSurface = Color(0xFF181818); // Level 1: Cards / chat list
  static const Color darkElevated = Color(0xFF202020); // Level 2: Input / search / menus
  static const Color darkPressed = Color(0xFF282828); // Level 3: Pressed / hover / reactions
  static const Color darkModal = Color(0xFF303030); // Level 4: Modal / popup

  // Dark Accents & Surfaces
  static const Color darkLavenderSurface = Color(0xFF3A2945); // Your message bubble / selected tabs
  static const Color darkLavenderAccent = Color(0xFFDDB9F2); // Primary CTA / Send / Active focus
  static const Color darkGreenSurface = Color(0xFF29402A); // Green accent surface
  static const Color darkLime = Color(0xFFB9E99F); // Active / unread badge / positive accents
  static const Color darkPinkSurface = Color(0xFF3F293B); // Pink secondary surface
  static const Color darkPinkAccent = Color(0xFFE8B9DE); // Pink special accent

  // Dark Typography
  static const Color darkTextPrimary = Color(0xFFF5F5F5); // Main text
  static const Color darkTextSecondary = Color(0xFFB5B5B5); // Metadata
  static const Color darkTextMuted = Color(0xFF777777); // Placeholder / search hint
  static const Color darkDivider = Color(0xFF2D2D2D); // Borders / separators

  // Dark Presence & Status
  static const Color darkOnlineDot = Color(0xFF8ED66C); // Soft recognizable green
  static const Color darkOnlineText = Color(0xFFA9D994);
  static const Color darkOffline = Color(0xFF555555);

  // Dark Focus & Read Receipts
  static const Color darkFocusBorder = Color(0xFF8E6BA8); // Focused input border
  static const Color darkReadReceipt = Color(0xFFBFA1D5); // Subtle read ticks
  static const Color darkDeliveredReceipt = Color(0xFF999999);
  static const Color darkSentReceipt = Color(0xFF777777);

  // Dynamic Theme Color Helper
  static PingMeThemeColors of(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark ? PingMeThemeColors.dark() : PingMeThemeColors.light();
  }
}

/// Helper container providing uniform color access according to active theme
class PingMeThemeColors {
  static PingMeThemeColors of(BuildContext context) => AppColors.of(context);

  final bool isDark;
  final Color background;
  final Color surface;
  final Color surfaceSecondary;
  final Color surfacePressed;
  final Color yourBubble;
  final Color theirBubble;
  final Color primaryAccent;
  final Color greenAccent;
  final Color greenSurface;
  final Color pinkAccent;
  final Color pinkSurface;
  final Color ctaBackground;
  final Color ctaForeground;
  final Color textPrimary;
  final Color textSecondary;
  final Color textPlaceholder;
  final Color border;
  final Color onlineDot;
  final Color onlineText;
  final Color offline;
  final Color readReceipt;
  final Color focusedBorder;

  const PingMeThemeColors({
    required this.isDark,
    required this.background,
    required this.surface,
    required this.surfaceSecondary,
    required this.surfacePressed,
    required this.yourBubble,
    required this.theirBubble,
    required this.primaryAccent,
    required this.greenAccent,
    required this.greenSurface,
    required this.pinkAccent,
    required this.pinkSurface,
    required this.ctaBackground,
    required this.ctaForeground,
    required this.textPrimary,
    required this.textSecondary,
    required this.textPlaceholder,
    required this.border,
    required this.onlineDot,
    required this.onlineText,
    required this.offline,
    required this.readReceipt,
    required this.focusedBorder,
  });

  factory PingMeThemeColors.light() => const PingMeThemeColors(
        isDark: false,
        background: AppColors.background,
        surface: AppColors.surface,
        surfaceSecondary: AppColors.surfaceSecondary,
        surfacePressed: Color(0xFFE4E4E0),
        yourBubble: AppColors.lavender,
        theirBubble: AppColors.surface,
        primaryAccent: AppColors.lavender,
        greenAccent: AppColors.limeGreen,
        greenSurface: Color(0xFFE8F8D8),
        pinkAccent: AppColors.softPink,
        pinkSurface: Color(0xFFFBEBF9),
        ctaBackground: AppColors.ctaBlack,
        ctaForeground: Colors.white,
        textPrimary: AppColors.textPrimary,
        textSecondary: AppColors.textSecondary,
        textPlaceholder: AppColors.textPlaceholder,
        border: AppColors.border,
        onlineDot: AppColors.onlineDot,
        onlineText: AppColors.onlineText,
        offline: AppColors.offlineText,
        readReceipt: AppColors.readReceipt,
        focusedBorder: AppColors.lavender,
      );

  factory PingMeThemeColors.dark() => const PingMeThemeColors(
        isDark: true,
        background: AppColors.darkBackground,
        surface: AppColors.darkSurface,
        surfaceSecondary: AppColors.darkElevated,
        surfacePressed: AppColors.darkPressed,
        yourBubble: AppColors.darkLavenderSurface,
        theirBubble: AppColors.darkElevated,
        primaryAccent: AppColors.darkLavenderAccent,
        greenAccent: AppColors.darkLime,
        greenSurface: AppColors.darkGreenSurface,
        pinkAccent: AppColors.darkPinkAccent,
        pinkSurface: AppColors.darkPinkSurface,
        ctaBackground: AppColors.darkLavenderAccent,
        ctaForeground: Color(0xFF111111),
        textPrimary: AppColors.darkTextPrimary,
        textSecondary: AppColors.darkTextSecondary,
        textPlaceholder: AppColors.darkTextMuted,
        border: AppColors.darkDivider,
        onlineDot: AppColors.darkOnlineDot,
        onlineText: AppColors.darkOnlineText,
        offline: AppColors.darkOffline,
        readReceipt: AppColors.darkReadReceipt,
        focusedBorder: AppColors.darkFocusBorder,
      );
}
