import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';
import 'package:ts_parking/app/theme/app_colors.dart';

extension ColorExtensions on Color {
  /// Modern replacement for withOpacity using withValues
  Color withAlpha(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withValues(alpha: opacity);
  }

  /// Creates a color with the given opacity value
  Color opacity(double opacity) {
    assert(opacity >= 0.0 && opacity <= 1.0);
    return withValues(alpha: opacity);
  }
}

extension ContextColorExtensions on BuildContext {
  Color get surfaceColor => isDark ? AppColors.darkSurface : Colors.white;

  Color get panelColor =>
      isDark ? AppColors.darkSurface : AppColors.lightSurface;

  Color get panelBorderColor =>
      isDark ? AppColors.darkBorder : AppColors.lightBorder;

  Color get tileColor => isDark ? const Color(0xFF13161A) : Colors.white;

  Color get backgroundColor =>
      isDark ? AppColors.darkBackground : AppColors.lightBackground;

  Color get primaryTextColor =>
      isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;

  Color get secondaryTextColor =>
      isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

  Color get tertiaryTextColor =>
      isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary;

  Color get surfaceVariantColor =>
      isDark ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant;

  Color get legendIdleBackground => isDark
      ? AppColors.darkSurfaceVariant.withValues(alpha: 0.35)
      : AppColors.lightSurfaceVariant;

  Color get legendIdleBorder => isDark
      ? AppColors.darkBorder.withValues(alpha: 0.9)
      : AppColors.lightBorder;
}
