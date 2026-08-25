import 'package:flutter/material.dart';

/// TS Parking Spacing System
/// 8px base unit system for consistent spacing and layout
class AppSpacing {
  AppSpacing._();

  // ============================================================================
  // BASE UNIT (8px)
  // ============================================================================

  /// Base spacing unit (8px) - Foundation of all spacing
  static const double base = 8.0;

  // ============================================================================
  // SPACING VALUES (8px Grid System)
  // ============================================================================

  /// xs: 4px - Extra small spacing
  static const double xs = 4.0;

  /// sm: 8px - Small spacing
  static const double sm = 8.0;

  /// md: 16px - Medium spacing (most common)
  static const double md = 16.0;

  /// lg: 24px - Large spacing
  static const double lg = 24.0;

  /// xl: 32px - Extra large spacing
  static const double xl = 32.0;

  /// 2xl: 48px - Double extra large spacing
  static const double xxl = 48.0;

  // ============================================================================
  // ADDITIONAL SPACING (For specific use cases)
  // ============================================================================

  /// 2px - Micro spacing for very tight layouts
  static const double micro = 2.0;

  /// 12px - Medium-small spacing
  static const double ms = 12.0;

  /// 20px - Medium-large spacing
  static const double ml = 20.0;

  /// 40px - Extra extra large spacing
  static const double xxxl = 40.0;

  /// 64px - Huge spacing for major sections
  static const double huge = 64.0;

  // ============================================================================
  // SCREEN PADDING
  // ============================================================================

  /// Default screen horizontal padding (16px)
  static const double screenHorizontal = md;

  /// Default screen vertical padding (16px)
  static const double screenVertical = md;

  /// Compact screen padding (12px)
  static const double screenHorizontalCompact = ms;

  /// Wide screen padding (24px)
  static const double screenHorizontalWide = lg;

  /// Top screen padding (24px)
  static const double screenTop = lg;

  /// Bottom screen padding (24px)
  static const double screenBottom = lg;

  // ============================================================================
  // CARD & CONTAINER SPACING
  // ============================================================================

  /// Card internal padding (16px)
  static const double cardPadding = md;

  /// Card internal padding compact (12px)
  static const double cardPaddingCompact = ms;

  /// Card internal padding large (24px)
  static const double cardPaddingLarge = lg;

  /// Spacing between cards in a list (8px)
  static const double cardSpacing = sm;

  /// Spacing between major card sections (16px)
  static const double cardSectionSpacing = md;

  // ============================================================================
  // BUTTON SPACING
  // ============================================================================

  /// Button internal horizontal padding (24px)
  static const double buttonHorizontal = lg;

  /// Button internal vertical padding (16px)
  static const double buttonVertical = md;

  /// Button internal padding compact (16px horizontal, 8px vertical)
  static const double buttonHorizontalCompact = md;
  static const double buttonVerticalCompact = sm;

  /// Spacing between buttons in a row (8px)
  static const double buttonSpacing = sm;

  /// Spacing between button and text below it (8px)
  static const double buttonTextSpacing = sm;

  // ============================================================================
  // FORM SPACING
  // ============================================================================

  /// Spacing between form fields (16px)
  static const double formFieldSpacing = md;

  /// Internal padding for text fields (16px horizontal, 16px vertical)
  static const double textFieldHorizontal = md;
  static const double textFieldVertical = md;

  /// Spacing between label and input (8px)
  static const double labelInputSpacing = sm;

  /// Spacing between input and helper text (4px)
  static const double inputHelperSpacing = xs;

  // ============================================================================
  // LIST SPACING
  // ============================================================================

  /// Spacing between list items (8px)
  static const double listItemSpacing = sm;

  /// List item internal padding (16px)
  static const double listItemPadding = md;

  /// Horizontal list spacing (8px)
  static const double listHorizontalSpacing = sm;

  // ============================================================================
  // SECTION SPACING
  // ============================================================================

  /// Spacing between major sections (24px)
  static const double sectionSpacing = lg;

  /// Spacing between section header and content (16px)
  static const double sectionHeaderSpacing = md;

  /// Spacing between section title and description (8px)
  static const double sectionTitleSpacing = sm;

  // ============================================================================
  // ICON & BADGE SPACING
  // ============================================================================

  /// Spacing between icon and text (8px)
  static const double iconTextSpacing = sm;

  /// Badge internal padding (8px horizontal, 4px vertical)
  static const double badgeHorizontal = sm;
  static const double badgeVertical = xs;

  /// Spacing between badges (8px)
  static const double badgeSpacing = sm;

  // ============================================================================
  // BOTTOM NAV & APP BAR
  // ============================================================================

  /// App bar height (56px)
  static const double appBarHeight = 56.0;

  /// Bottom navigation height (64px)
  static const double bottomNavHeight = 64.0;

  /// Bottom nav icon spacing (4px)
  static const double bottomNavIconSpacing = xs;

  // ============================================================================
  // AVATAR & IMAGE SIZES
  // ============================================================================

  /// Avatar size small (32px)
  static const double avatarSm = xl;

  /// Avatar size medium (48px)
  static const double avatarMd = 48.0;

  /// Avatar size large (64px)
  static const double avatarLg = 64.0;

  /// Avatar size extra large (96px)
  static const double avatarXl = 96.0;

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Get EdgeInsets for screen padding
  static EdgeInsets get screenPadding => const EdgeInsets.symmetric(
    horizontal: screenHorizontal,
    vertical: screenVertical,
  );

  /// Get EdgeInsets for screen padding (horizontal only)
  static EdgeInsets get screenPaddingHorizontal =>
      const EdgeInsets.symmetric(horizontal: screenHorizontal);

  /// Get EdgeInsets for screen padding (vertical only)
  static EdgeInsets get screenPaddingVertical =>
      const EdgeInsets.symmetric(vertical: screenVertical);

  /// Get EdgeInsets for card padding
  static EdgeInsets get cardPaddingInsets => const EdgeInsets.all(cardPadding);

  /// Get EdgeInsets for button padding
  static EdgeInsets get buttonPadding => const EdgeInsets.symmetric(
    horizontal: buttonHorizontal,
    vertical: buttonVertical,
  );

  /// Get EdgeInsets for list item padding
  static EdgeInsets get listItemPaddingInsets =>
      const EdgeInsets.all(listItemPadding);

  /// Get EdgeInsets for all sides
  static EdgeInsets all(double value) => EdgeInsets.all(value);

  /// Get EdgeInsets symmetric
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  /// Get EdgeInsets only
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  // ============================================================================
  // VERTICAL SPACERS
  // ============================================================================

  /// Vertical space: 4px
  static SizedBox get verticalSpaceXs => const SizedBox(height: xs);

  /// Vertical space: 8px
  static SizedBox get verticalSpaceSm => const SizedBox(height: sm);

  /// Vertical space: 16px
  static SizedBox get verticalSpaceMd => const SizedBox(height: md);

  /// Vertical space: 24px
  static SizedBox get verticalSpaceLg => const SizedBox(height: lg);

  /// Vertical space: 32px
  static SizedBox get verticalSpaceXl => const SizedBox(height: xl);

  /// Vertical space: 48px
  static SizedBox get verticalSpaceXxl => const SizedBox(height: xxl);

  // ============================================================================
  // HORIZONTAL SPACERS
  // ============================================================================

  /// Horizontal space: 4px
  static SizedBox get horizontalSpaceXs => const SizedBox(width: xs);

  /// Horizontal space: 8px
  static SizedBox get horizontalSpaceSm => const SizedBox(width: sm);

  /// Horizontal space: 16px
  static SizedBox get horizontalSpaceMd => const SizedBox(width: md);

  /// Horizontal space: 24px
  static SizedBox get horizontalSpaceLg => const SizedBox(width: lg);

  /// Horizontal space: 32px
  static SizedBox get horizontalSpaceXl => const SizedBox(width: xl);

  /// Horizontal space: 48px
  static SizedBox get horizontalSpaceXxl => const SizedBox(width: xxl);

  // ============================================================================
  // CUSTOM SPACERS
  // ============================================================================

  /// Get SizedBox for custom vertical spacing
  static SizedBox verticalSpace(double height) => SizedBox(height: height);

  /// Get SizedBox for custom horizontal spacing
  static SizedBox horizontalSpace(double width) => SizedBox(width: width);
}
