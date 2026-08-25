import 'package:flutter/material.dart';
import 'dark_theme.dart';
import 'light_theme.dart';

// Export all theme files
export 'app_colors.dart';
export 'app_typography.dart';
export 'app_spacing.dart';
export 'app_shadows.dart';
export 'dark_theme.dart';
export 'light_theme.dart';

/// TS Parking App Theme
/// Provides access to dark and light themes
class AppTheme {
  AppTheme._();

  /// Get luxury dark theme (primary theme)
  static ThemeData dark() => DarkTheme.theme;

  /// Get luxury light theme (secondary option)
  static ThemeData light() => LightTheme.theme;
}
