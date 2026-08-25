import 'package:flutter/material.dart';

/// TS Parking Border Radius System
/// Consistent border radius values for UI elements
class AppRadius {
  AppRadius._();

  // ============================================================================
  // BORDER RADIUS VALUES
  // ============================================================================

  /// Small: 8px
  /// Usage: Small buttons, chips, badges
  static const double small = 8.0;

  /// Medium: 12px
  /// Usage: Cards, standard buttons, inputs
  static const double medium = 12.0;

  /// Large: 16px
  /// Usage: Large cards, modals, prominent elements
  static const double large = 16.0;

  /// XLarge: 24px
  /// Usage: Bottom sheets, special containers
  static const double xlarge = 24.0;

  /// Pill: 999px
  /// Usage: Pill-shaped buttons, badges, tags
  static const double pill = 999.0;

  /// None: 0px
  /// Usage: Sharp corners, no rounding
  static const double none = 0.0;

  // ============================================================================
  // BORDER RADIUS OBJECTS
  // ============================================================================

  /// Small radius
  static BorderRadius get smallRadius => BorderRadius.circular(small);

  /// Medium radius
  static BorderRadius get mediumRadius => BorderRadius.circular(medium);

  /// Large radius
  static BorderRadius get largeRadius => BorderRadius.circular(large);

  /// XLarge radius
  static BorderRadius get xlargeRadius => BorderRadius.circular(xlarge);

  /// Pill radius
  static BorderRadius get pillRadius => BorderRadius.circular(pill);

  /// No radius
  static BorderRadius get noneRadius => BorderRadius.circular(none);

  // ============================================================================
  // TOP-ONLY BORDER RADIUS
  // ============================================================================

  /// Small radius (top only) - for bottom sheets
  static BorderRadius get smallTopRadius => BorderRadius.only(
    topLeft: Radius.circular(small),
    topRight: Radius.circular(small),
  );

  /// Medium radius (top only) - for bottom sheets
  static BorderRadius get mediumTopRadius => BorderRadius.only(
    topLeft: Radius.circular(medium),
    topRight: Radius.circular(medium),
  );

  /// Large radius (top only) - for bottom sheets
  static BorderRadius get largeTopRadius => BorderRadius.only(
    topLeft: Radius.circular(large),
    topRight: Radius.circular(large),
  );

  /// XLarge radius (top only) - for bottom sheets
  static BorderRadius get xlargeTopRadius => BorderRadius.only(
    topLeft: Radius.circular(xlarge),
    topRight: Radius.circular(xlarge),
  );

  // ============================================================================
  // BOTTOM-ONLY BORDER RADIUS
  // ============================================================================

  /// Small radius (bottom only)
  static BorderRadius get smallBottomRadius => BorderRadius.only(
    bottomLeft: Radius.circular(small),
    bottomRight: Radius.circular(small),
  );

  /// Medium radius (bottom only)
  static BorderRadius get mediumBottomRadius => BorderRadius.only(
    bottomLeft: Radius.circular(medium),
    bottomRight: Radius.circular(medium),
  );

  /// Large radius (bottom only)
  static BorderRadius get largeBottomRadius => BorderRadius.only(
    bottomLeft: Radius.circular(large),
    bottomRight: Radius.circular(large),
  );

  /// XLarge radius (bottom only)
  static BorderRadius get xlargeBottomRadius => BorderRadius.only(
    bottomLeft: Radius.circular(xlarge),
    bottomRight: Radius.circular(xlarge),
  );

  // ============================================================================
  // LEFT-ONLY BORDER RADIUS
  // ============================================================================

  /// Small radius (left only)
  static BorderRadius get smallLeftRadius => BorderRadius.only(
    topLeft: Radius.circular(small),
    bottomLeft: Radius.circular(small),
  );

  /// Medium radius (left only)
  static BorderRadius get mediumLeftRadius => BorderRadius.only(
    topLeft: Radius.circular(medium),
    bottomLeft: Radius.circular(medium),
  );

  /// Large radius (left only)
  static BorderRadius get largeLeftRadius => BorderRadius.only(
    topLeft: Radius.circular(large),
    bottomLeft: Radius.circular(large),
  );

  // ============================================================================
  // RIGHT-ONLY BORDER RADIUS
  // ============================================================================

  /// Small radius (right only)
  static BorderRadius get smallRightRadius => BorderRadius.only(
    topRight: Radius.circular(small),
    bottomRight: Radius.circular(small),
  );

  /// Medium radius (right only)
  static BorderRadius get mediumRightRadius => BorderRadius.only(
    topRight: Radius.circular(medium),
    bottomRight: Radius.circular(medium),
  );

  /// Large radius (right only)
  static BorderRadius get largeRightRadius => BorderRadius.only(
    topRight: Radius.circular(large),
    bottomRight: Radius.circular(large),
  );

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get custom radius
  static BorderRadius circular(double radius) => BorderRadius.circular(radius);

  /// Get custom radius for specific corners
  static BorderRadius only({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) => BorderRadius.only(
    topLeft: Radius.circular(topLeft),
    topRight: Radius.circular(topRight),
    bottomLeft: Radius.circular(bottomLeft),
    bottomRight: Radius.circular(bottomRight),
  );

  /// Get radius from string
  static BorderRadius fromString(String size) {
    switch (size.toLowerCase()) {
      case 'small':
        return smallRadius;
      case 'medium':
        return mediumRadius;
      case 'large':
        return largeRadius;
      case 'xlarge':
        return xlargeRadius;
      case 'pill':
        return pillRadius;
      case 'none':
        return noneRadius;
      default:
        return mediumRadius;
    }
  }

  /// Get radius value from string
  static double valueFromString(String size) {
    switch (size.toLowerCase()) {
      case 'small':
        return small;
      case 'medium':
        return medium;
      case 'large':
        return large;
      case 'xlarge':
        return xlarge;
      case 'pill':
        return pill;
      case 'none':
        return none;
      default:
        return medium;
    }
  }
}
