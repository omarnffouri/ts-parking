import 'package:flutter/material.dart';

/// TS Parking Color Palette
/// Design System Colors for Parking Management
class AppColors {
  AppColors._();

  // ============================================================================
  // PRIMARY COLORS
  // ============================================================================

  /// Primary Amber - Main brand color (#FFAA00)
  static const Color primary = Color(0xFFFFAA00);
  static const Color primaryDark = Color(0xFFE69900);
  static const Color primaryLight = Color(0xFFFFBB33);

  /// Secondary Blue Grey - Supporting brand color (#455A64)
  static const Color secondary = Color(0xFF455A64);
  static const Color secondaryDark = Color(0xFF37474F);
  static const Color secondaryLight = Color(0xFF546E7A);

  /// Accent - Same as primary for consistency
  static const Color accent = primary;
  static const Color accentDark = primaryDark;
  static const Color accentLight = primaryLight;

  // ============================================================================
  // DARK THEME COLORS
  // ============================================================================

  /// Background: #242526 (Warm Dark Gray)
  static const Color darkBackground = Color(0xFF242526);

  /// Surface: #18181B (Zinc-900)
  static const Color darkSurface = Color(0xFF18181B);
  static const Color darkSurfaceVariant = Color(0xFF27272A);

  /// Border: #27272A (Zinc-800)
  static const Color darkBorder = Color(0xFF27272A);
  static const Color darkDivider = Color(0xFF27272A);

  /// Text Primary: #FFFFFF
  static const Color darkTextPrimary = Color(0xFFFFFFFF);

  /// Text Secondary: #A1A1AA (Zinc-400)
  static const Color darkTextSecondary = Color(0xFFA1A1AA);
  static const Color darkTextTertiary = Color(0xFF71717A);
  static const Color darkTextDisabled = Color(0xFF52525B);

  // ============================================================================
  // LIGHT THEME COLORS
  // ============================================================================

  /// Background: #EAEAF3 (Soft Lavender Gray)
  static const Color lightBackground = Color(0xFFEAEAF3);

  /// Surface: #F8FAFC
  static const Color lightSurface = Color(0xFFF8FAFC);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);

  /// Border: #E2E8F0
  static const Color lightBorder = Color(0xFFE2E8F0);
  static const Color lightDivider = Color(0xFFE2E8F0);

  /// Text Primary: #0F172A
  static const Color lightTextPrimary = Color(0xFF0F172A);

  /// Text Secondary: #64748B
  static const Color lightTextSecondary = Color(0xFF64748B);
  static const Color lightTextTertiary = Color(0xFF94A3B8);
  static const Color lightTextDisabled = Color(0xFFCBD5E1);

  // ============================================================================
  // STATUS COLORS
  // ============================================================================

  /// Success: Green (#10B981)
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  /// Warning: Orange (#F59E0B)
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  /// Error: Red (#EF4444)
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  /// Info: Blue (#3B82F6)
  static const Color info = Color(0xFF3B82F6);
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // ============================================================================
  // STATUS BADGE COLORS
  // ============================================================================

  /// Active status (parking spots, bookings)
  static const Color statusActive = success;

  /// Inactive status
  static const Color statusInactive = Color(0xFF6B7280);

  /// Pending status
  static const Color statusPending = warning;

  /// Completed status
  static const Color statusCompleted = success;

  /// Cancelled status
  static const Color statusCancelled = error;

  /// Deleted status
  static const Color statusDeleted = error;

  // ============================================================================
  // OVERLAY COLORS
  // ============================================================================

  /// Black overlays for images and modals
  static const Color overlayDark = Color(0x80000000); // 50% black
  static const Color overlayMedium = Color(0x66000000); // 40% black
  static const Color overlayLight = Color(0x33000000); // 20% black

  /// White overlays
  static const Color overlayWhite = Color(0x80FFFFFF); // 50% white
  static const Color overlayWhiteLight = Color(0x33FFFFFF); // 20% white

  // ============================================================================
  // GRADIENT COLORS
  // ============================================================================

  /// Splash screen gradient (Primary → Secondary)
  static const LinearGradient splashGradient = LinearGradient(
    colors: [primary, secondary],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Primary button gradient
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primaryLight, primary, primaryDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Accent gradient (Gold)
  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentLight, accent, accentDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Dark background gradient
  static const LinearGradient darkGradient = LinearGradient(
    colors: [darkBackground, darkSurface],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Page background gradient (dark)
  static const LinearGradient darkPageGradient = LinearGradient(
    colors: [darkBackground, darkSurface, darkBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Page background gradient (light)
  static const LinearGradient lightPageGradient = LinearGradient(
    colors: [lightBackground, lightSurface, lightBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Glass effect gradient
  static const LinearGradient glassGradient = LinearGradient(
    colors: [Color(0x40FFFFFF), Color(0x10FFFFFF)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // ============================================================================
  // SPECIAL EFFECTS
  // ============================================================================

  /// Shimmer loading effect colors (Dark theme)
  static const Color shimmerBaseDark = darkSurface;
  static const Color shimmerHighlightDark = darkSurfaceVariant;

  /// Shimmer loading effect colors (Light theme)
  static const Color shimmerBaseLight = lightSurface;
  static const Color shimmerHighlightLight = lightSurfaceVariant;

  /// Glow effects
  static const Color primaryGlow = Color(0x40FFAA00);
  static const Color accentGlow = Color(0x40FFAA00);
  static const Color successGlow = Color(0x4010B981);
  static const Color errorGlow = Color(0x40EF4444);

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get status color by status string
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return statusActive;
      case 'inactive':
        return statusInactive;
      case 'pending':
        return statusPending; // Warning (Orange)
      case 'confirmed':
        return statusActive; // Success (Green)
      case 'inprogress':
      case 'in progress':
        return info; // Blue
      case 'completed':
        return statusCompleted; // Success (Green)
      case 'cancelled':
        return statusCancelled; // Error (Red)
      case 'noshow':
      case 'no show':
        return error; // Error (Red)
      case 'deleted':
        return statusDeleted; // Error (Red)
      case 'hold':
      case 'on_hold':
        return warning; // Orange
      case 'unpaid':
        return error; // Red
      case 'paid':
        return success; // Green
      default:
        return statusInactive;
    }
  }

  /// Get status background color (lighter version for badges)
  static Color getStatusBackgroundColor(String status, {required bool isDark}) {
    final baseColor = getStatusColor(status);
    return baseColor.withValues(alpha: isDark ? 0.2 : 0.1);
  }

  /// Get text color based on background brightness
  static Color getTextColor(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? lightTextPrimary : darkTextPrimary;
  }

  /// Get shimmer colors based on theme
  static List<Color> getShimmerColors(bool isDark) {
    return isDark
        ? [shimmerBaseDark, shimmerHighlightDark, shimmerBaseDark]
        : [shimmerBaseLight, shimmerHighlightLight, shimmerBaseLight];
  }
}
