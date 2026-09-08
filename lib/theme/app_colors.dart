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

  // Subtle Pastel Glow / Shadow
  static List<BoxShadow> softCardShadow = [
    BoxShadow(
      color: const Color(0xFF111111).withValues(alpha: 0.04),
      blurRadius: 16,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];
}
