import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'app_radius.dart';

/// TS Parking Dark Theme
/// Professional dark theme for parking management
class DarkTheme {
  static ThemeData get theme {
    return ThemeData(
      // ========================================================================
      // BRIGHTNESS & COLOR SCHEME
      // ========================================================================
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.black, // Dark text on amber
        primaryContainer: AppColors.primaryDark,
        onPrimaryContainer: Colors.white,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        tertiary: AppColors.accent,
        onTertiary: Colors.black,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.darkSurface,
        onSurface: AppColors.darkTextPrimary,
        surfaceContainerHighest: AppColors.darkSurfaceVariant,
        outline: AppColors.darkBorder,
        outlineVariant: AppColors.darkDivider,
      ),

      // ========================================================================
      // SCAFFOLD & BACKGROUNDS
      // ========================================================================
      scaffoldBackgroundColor: AppColors.darkBackground,
      canvasColor: AppColors.darkBackground,
      cardColor: AppColors.darkSurface,

      // ========================================================================
      // TYPOGRAPHY
      // ========================================================================
      textTheme: AppTypography.getDarkTextTheme().apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),
      primaryTextTheme: AppTypography.getDarkTextTheme().apply(
        bodyColor: AppColors.darkTextPrimary,
        displayColor: AppColors.darkTextPrimary,
      ),

      // ========================================================================
      // APP BAR
      // ========================================================================
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.darkBackground,
        foregroundColor: AppColors.darkTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.h3.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.darkTextPrimary,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // ========================================================================
      // CARD
      // ========================================================================
      cardTheme: CardThemeData(
        color: AppColors.darkSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.largeRadius,
          side: BorderSide(color: AppColors.darkBorder),
        ),
        margin: EdgeInsets.zero,
      ),

      // ========================================================================
      // ELEVATED BUTTON (Primary CTA)
      // ========================================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black, // Dark text on amber
          disabledBackgroundColor: AppColors.darkTextDisabled,
          disabledForegroundColor: AppColors.darkTextTertiary,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumRadius),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonHorizontal,
            vertical: AppSpacing.buttonVertical,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // ========================================================================
      // OUTLINED BUTTON (Secondary)
      // ========================================================================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.darkTextDisabled,
          side: const BorderSide(color: AppColors.primary, width: 1.0),
          shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumRadius),
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.buttonHorizontal,
            vertical: AppSpacing.buttonVertical,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // ========================================================================
      // TEXT BUTTON (Tertiary)
      // ========================================================================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          disabledForegroundColor: AppColors.darkTextDisabled,
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          textStyle: AppTypography.buttonMedium,
        ),
      ),

      // ========================================================================
      // INPUT DECORATION (Text Fields)
      // ========================================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.darkSurface,
        hoverColor: AppColors.darkSurfaceVariant,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.textFieldHorizontal,
          vertical: AppSpacing.textFieldVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.darkBorder, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.darkDivider, width: 1),
        ),
        labelStyle: AppTypography.label.copyWith(
          color: AppColors.darkTextSecondary,
        ),
        hintStyle: AppTypography.input.copyWith(
          color: AppColors.darkTextTertiary,
        ),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
        prefixIconColor: AppColors.darkTextSecondary,
        suffixIconColor: AppColors.darkTextSecondary,
      ),

      // ========================================================================
      // DIVIDER
      // ========================================================================
      dividerTheme: const DividerThemeData(
        color: AppColors.darkDivider,
        thickness: 1,
        space: 1,
      ),

      // ========================================================================
      // BOTTOM NAVIGATION BAR
      // ========================================================================
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.darkTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ========================================================================
      // BOTTOM SHEET
      // ========================================================================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.darkSurface,
        modalBackgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlargeTopRadius),
        elevation: 8,
      ),

      // ========================================================================
      // DIALOG
      // ========================================================================
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.darkSurface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
        elevation: 8,
        titleTextStyle: AppTypography.h3.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkTextSecondary,
        ),
      ),

      // ========================================================================
      // ICON
      // ========================================================================
      iconTheme: const IconThemeData(
        color: AppColors.darkTextPrimary,
        size: 24,
      ),

      // ========================================================================
      // CHIP
      // ========================================================================
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.darkSurface,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.darkTextDisabled,
        labelStyle: AppTypography.badge,
        secondaryLabelStyle: AppTypography.badge,
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.badgeHorizontal,
          vertical: AppSpacing.badgeVertical,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.pillRadius),
      ),

      // ========================================================================
      // FLOATING ACTION BUTTON
      // ========================================================================
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 4,
      ),

      // ========================================================================
      // PROGRESS INDICATOR
      // ========================================================================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.primary,
      ),

      // ========================================================================
      // SWITCH
      // ========================================================================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.darkTextTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.5);
          }
          return AppColors.darkBorder;
        }),
      ),

      // ========================================================================
      // CHECKBOX & RADIO
      // ========================================================================
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return Colors.transparent;
        }),
        checkColor: WidgetStateProperty.all(Colors.white),
      ),

      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }
          return AppColors.darkTextSecondary;
        }),
      ),

      // ========================================================================
      // SNACKBAR
      // ========================================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.darkSurfaceVariant,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.darkTextPrimary,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.smallRadius),
        behavior: SnackBarBehavior.floating,
      ),

      // ========================================================================
      // MISC
      // ========================================================================
      dividerColor: AppColors.darkDivider,
      disabledColor: AppColors.darkTextDisabled,
      highlightColor: AppColors.primary.withValues(alpha: 0.1),
      splashColor: AppColors.primary.withValues(alpha: 0.2),
      hoverColor: AppColors.primary.withValues(alpha: 0.05),
      focusColor: AppColors.primary.withValues(alpha: 0.12),
    );
  }
}
