import 'package:flutter/material.dart';

/// TS Parking Typography System
/// Font Family: Inter / SF Pro Display
/// Following 8px grid system
class AppTypography {
  AppTypography._();

  // ============================================================================
  // FONT FAMILY
  // ============================================================================

  /// Primary font family
  /// Falls back to: SF Pro Display (iOS), Inter (Android), Segoe UI (Windows)
  static const String primaryFont = 'Inter';

  // ============================================================================
  // HEADINGS
  // ============================================================================

  /// H1: 32px – Bold (700)
  /// Usage: Page titles, main headers
  static const TextStyle h1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w600, // SemiBold for strong impact
    height: 1.25,
    letterSpacing: -1.0, // Tighter tracking for modern display
  );

  /// H2: 24px – Bold (700)
  /// Usage: Section headers
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    height: 1.3,
    letterSpacing: -0.5,
  );

  /// H3: 20px – Medium (500)
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: -0.2,
  );

  /// H4: 18px – Medium (500)
  static const TextStyle h4 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.4,
    letterSpacing: 0,
  );

  // ============================================================================
  // BODY TEXT
  // ============================================================================

  /// Body Large: 16px – Regular (400)
  /// Usage: Main content, primary text
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
    letterSpacing: 0,
  );

  /// Body Medium: 14px – Regular (400)
  /// Usage: Secondary content, descriptions
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
    letterSpacing: 0,
  );

  /// Body Small: 12px – Regular (400)
  /// Usage: Tertiary content, small text
  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    height: 1.5,
    letterSpacing: 0,
  );

  // ============================================================================
  // UI TEXT
  // ============================================================================

  /// Labels: 14px – Medium (500)
  /// Usage: Form labels, input labels
  static const TextStyle label = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500, // Medium
    height: 1.4,
    letterSpacing: 0.1,
  );

  /// Buttons: 16px – SemiBold (600)
  /// Usage: Button text, CTAs
  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// Captions: 12px – Regular (400)
  /// Usage: Captions, footnotes, helper text
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400, // Regular
    height: 1.4,
    letterSpacing: 0.1,
  );

  // ============================================================================
  // VARIANTS (COMMON USE CASES)
  // ============================================================================

  /// Body Large Semi-Bold - Emphasized content
  static const TextStyle bodyLargeSemiBold = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Body Medium Semi-Bold - Emphasized secondary content
  static const TextStyle bodyMediumSemiBold = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Body Small Semi-Bold - Emphasized small text
  static const TextStyle bodySmallSemiBold = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.5,
    letterSpacing: 0.1,
  );

  /// Button Medium: 14px – SemiBold (600)
  /// Usage: Secondary buttons, smaller CTAs
  static const TextStyle buttonMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  /// Button Small: 12px – SemiBold (600)
  /// Usage: Tertiary buttons, chips
  static const TextStyle buttonSmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ============================================================================
  // SPECIAL PURPOSE
  // ============================================================================

  /// Input Text - Text field content
  static const TextStyle input = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 1.5,
    letterSpacing: 0,
  );

  /// Badge Text - Badges and status chips
  static const TextStyle badge = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.3,
  );

  /// Tab Bar Text - Navigation tabs
  static const TextStyle tabBar = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.2,
    letterSpacing: 0.2,
  );

  /// Overline - Small all-caps text
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w600,
    height: 1.6,
    letterSpacing: 1.5,
  );

  // ============================================================================
  // MATERIAL THEME INTEGRATION
  // ============================================================================

  /// Get TextTheme for Material Dark Theme
  static TextTheme getDarkTextTheme() {
    return const TextTheme(
      // Display styles
      displayLarge: h1,
      displayMedium: h2,
      displaySmall: h3,

      // Headline styles
      headlineLarge: h1,
      headlineMedium: h2,
      headlineSmall: h3,

      // Title styles
      titleLarge: h4,
      titleMedium: bodyLargeSemiBold,
      titleSmall: bodyMediumSemiBold,

      // Body styles
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,

      // Label styles
      labelLarge: label,
      labelMedium: caption,
      labelSmall: overline,
    );
  }

  /// Get TextTheme for Material Light Theme
  static TextTheme getLightTextTheme() {
    return const TextTheme(
      // Display styles
      displayLarge: h1,
      displayMedium: h2,
      displaySmall: h3,

      // Headline styles
      headlineLarge: h1,
      headlineMedium: h2,
      headlineSmall: h3,

      // Title styles
      titleLarge: h4,
      titleMedium: bodyLargeSemiBold,
      titleSmall: bodyMediumSemiBold,

      // Body styles
      bodyLarge: bodyLarge,
      bodyMedium: bodyMedium,
      bodySmall: bodySmall,

      // Label styles
      labelLarge: label,
      labelMedium: caption,
      labelSmall: overline,
    );
  }
}
