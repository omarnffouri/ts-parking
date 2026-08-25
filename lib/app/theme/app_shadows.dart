import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';

/// TS Parking Shadow System
/// Elevation and depth definitions for dark and light themes
class AppShadows {
  AppShadows._();

  // ============================================================================
  // DARK THEME SHADOWS
  // ============================================================================

  /// Small shadow for dark theme
  /// Shadow: 0 2px 8px rgba(0,0,0,0.4)
  /// Usage: Cards, small elevated elements
  static const List<BoxShadow> darkSmall = [
    BoxShadow(
      color: Color(0x33000000), // 20% black
      offset: Offset(0, 2),
      blurRadius: 4,
      spreadRadius: 0,
    ),
  ];

  /// Medium shadow for dark theme
  /// Shadow: 0 4px 16px rgba(0,0,0,0.5)
  /// Usage: Modals, raised cards, floating buttons
  static const List<BoxShadow> darkMedium = [
    BoxShadow(
      color: Color(0x4D000000), // 30% black
      offset: Offset(0, 4),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  /// Large shadow for dark theme
  /// Shadow: 0 8px 24px rgba(0,0,0,0.6)
  /// Usage: Bottom sheets, dialogs, dropdowns
  static const List<BoxShadow> darkLarge = [
    BoxShadow(
      color: Color(0x99000000), // 60% black (0.6)
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // ============================================================================
  // LIGHT THEME SHADOWS
  // ============================================================================

  /// Small shadow for light theme
  /// Shadow: 0 2px 8px rgba(0,0,0,0.08)
  /// Usage: Cards, small elevated elements
  static const List<BoxShadow> lightSmall = [
    BoxShadow(
      color: Color(0x14000000), // 8% black (0.08)
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: 0,
    ),
  ];

  /// Medium shadow for light theme
  /// Shadow: 0 4px 16px rgba(0,0,0,0.12)
  /// Usage: Modals, raised cards, floating buttons
  static const List<BoxShadow> lightMedium = [
    BoxShadow(
      color: Color(0x1F000000), // 12% black (0.12)
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// Large shadow for light theme
  /// Shadow: 0 8px 24px rgba(0,0,0,0.16)
  /// Usage: Bottom sheets, dialogs, dropdowns
  static const List<BoxShadow> lightLarge = [
    BoxShadow(
      color: Color(0x29000000), // 16% black (0.16)
      offset: Offset(0, 8),
      blurRadius: 24,
      spreadRadius: 0,
    ),
  ];

  // ============================================================================
  // SPECIAL EFFECT SHADOWS
  // ============================================================================

  /// Subtle glow effect for buttons
  static const List<BoxShadow> buttonGlow = [
    BoxShadow(
      color: Color(0x33000000), // 20% black
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: 0,
    ),
  ];

  /// Primary Glow for amber buttons
  static const List<BoxShadow> primaryGlow = [
    BoxShadow(
      color: Color(0x4DFFAA00), // 30% amber
      offset: Offset(0, 0),
      blurRadius: 20,
      spreadRadius: 0,
    ),
  ];

  /// Success glow for successful actions
  static const List<BoxShadow> successGlow = [
    BoxShadow(
      color: Color(0x3310B981), // 20% green
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// Error glow for error states
  static const List<BoxShadow> errorGlow = [
    BoxShadow(
      color: Color(0x33EF4444), // 20% red
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// Warning glow for warning states
  static const List<BoxShadow> warningGlow = [
    BoxShadow(
      color: Color(0x33FFAA00), // 20% amber
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// Info glow for info states
  static const List<BoxShadow> infoGlow = [
    BoxShadow(
      color: Color(0x333B82F6), // 20% blue
      offset: Offset(0, 4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get shadow based on size and theme brightness
  ///
  /// Size options: 'small', 'medium', 'large'
  static List<BoxShadow> getShadow({
    required String size,
    required Brightness brightness,
  }) {
    assert(
      size == 'small' || size == 'medium' || size == 'large',
      'Size must be "small", "medium", or "large"',
    );

    if (brightness == Brightness.dark) {
      switch (size) {
        case 'small':
          return darkSmall;
        case 'medium':
          return darkMedium;
        case 'large':
          return darkLarge;
        default:
          return darkSmall;
      }
    } else {
      switch (size) {
        case 'small':
          return lightSmall;
        case 'medium':
          return lightMedium;
        case 'large':
          return lightLarge;
        default:
          return lightSmall;
      }
    }
  }

  /// Get shadow from context
  static List<BoxShadow> fromContext(
    BuildContext context, {
    String size = 'small',
  }) {
    final brightness = Theme.of(context).brightness;
    return getShadow(size: size, brightness: brightness);
  }

  /// Get BoxDecoration with shadow for dark theme
  static BoxDecoration darkDecoration({
    String shadow = 'small',
    Color? color,
    double borderRadius = 12,
    Border? border,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: getShadow(size: shadow, brightness: Brightness.dark),
      border: border,
    );
  }

  /// Get BoxDecoration with shadow for light theme
  static BoxDecoration lightDecoration({
    String shadow = 'small',
    Color? color,
    double borderRadius = 12,
    Border? border,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: getShadow(size: shadow, brightness: Brightness.light),
      border: border,
    );
  }

  /// Get card decoration for current theme
  static BoxDecoration cardDecoration(
    BuildContext context, {
    String shadow = 'small',
    Color? color,
    double borderRadius = 12,
    Border? border,
  }) {
    final isDark = context.isDark;
    return isDark
        ? darkDecoration(
            shadow: shadow,
            color: color,
            borderRadius: borderRadius,
            border: border,
          )
        : lightDecoration(
            shadow: shadow,
            color: color,
            borderRadius: borderRadius,
            border: border,
          );
  }
}
