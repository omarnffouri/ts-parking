import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_typography.dart';
import 'app_spacing.dart';
import 'app_radius.dart';

/// TS Parking Light Theme
/// Clean light theme for parking management
class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      // ========================================================================
      // BRIGHTNESS & COLOR SCHEME
      // ========================================================================
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.lightTextPrimary,
        secondary: AppColors.secondary,
        onSecondary: Colors.white,
        tertiary: AppColors.accent,
        onTertiary: Colors.white,
        error: AppColors.error,
        onError: Colors.white,
        surface: AppColors.lightSurface,
        onSurface: AppColors.lightTextPrimary,
        surfaceContainerHighest: AppColors.lightSurfaceVariant,
        outline: AppColors.lightBorder,
        outlineVariant: AppColors.lightDivider,
      ),

      // ========================================================================
      // SCAFFOLD & BACKGROUNDS
      // ========================================================================
      scaffoldBackgroundColor: AppColors.lightBackground,
      canvasColor: AppColors.lightBackground,
      cardColor: AppColors.lightSurface,

      // ========================================================================
      // TYPOGRAPHY
      // ========================================================================
      textTheme: AppTypography.getLightTextTheme().apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),
      primaryTextTheme: AppTypography.getLightTextTheme().apply(
        bodyColor: AppColors.lightTextPrimary,
        displayColor: AppColors.lightTextPrimary,
      ),

      // ========================================================================
      // APP BAR
      // ========================================================================
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: AppTypography.h3.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.lightTextPrimary,
          size: 24,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // ========================================================================
      // CARD
      // ========================================================================
      cardTheme: CardThemeData(
        color: AppColors.lightSurface,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
        margin: EdgeInsets.zero,
      ),

      // ========================================================================
      // ELEVATED BUTTON (Primary CTA)
      // ========================================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black, // Dark text on amber
          disabledBackgroundColor: AppColors.lightTextDisabled,
          disabledForegroundColor: AppColors.lightTextTertiary,
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
          disabledForegroundColor: AppColors.lightTextDisabled,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
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
          disabledForegroundColor: AppColors.lightTextDisabled,
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
        fillColor: AppColors.lightSurface,
        hoverColor: AppColors.lightSurfaceVariant,
        contentPadding: EdgeInsets.symmetric(
          horizontal: AppSpacing.textFieldHorizontal,
          vertical: AppSpacing.textFieldVertical,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.lightBorder, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.mediumRadius,
          borderSide: const BorderSide(color: AppColors.lightBorder, width: 1),
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
          borderSide: const BorderSide(color: AppColors.lightDivider, width: 1),
        ),
        labelStyle: AppTypography.label.copyWith(
          color: AppColors.lightTextSecondary,
        ),
        hintStyle: AppTypography.input.copyWith(
          color: AppColors.lightTextTertiary,
        ),
        errorStyle: AppTypography.caption.copyWith(color: AppColors.error),
        prefixIconColor: AppColors.lightTextSecondary,
        suffixIconColor: AppColors.lightTextSecondary,
      ),

      // ========================================================================
      // DIVIDER
      // ========================================================================
      dividerTheme: const DividerThemeData(
        color: AppColors.lightDivider,
        thickness: 1,
        space: 1,
      ),

      // ========================================================================
      // BOTTOM NAVIGATION BAR
      // ========================================================================
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.lightBackground,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.lightTextTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // ========================================================================
      // BOTTOM SHEET
      // ========================================================================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.lightBackground,
        modalBackgroundColor: AppColors.lightBackground,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.xlargeTopRadius),
        elevation: 8,
      ),

      // ========================================================================
      // DIALOG
      // ========================================================================
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.lightBackground,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
        elevation: 8,
        titleTextStyle: AppTypography.h3.copyWith(
          color: AppColors.lightTextPrimary,
        ),
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightTextSecondary,
        ),
      ),

      // ========================================================================
      // ICON
      // ========================================================================
      iconTheme: const IconThemeData(
        color: AppColors.lightTextPrimary,
        size: 24,
      ),

      // ========================================================================
      // CHIP
      // ========================================================================
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.lightSurface,
        selectedColor: AppColors.primary,
        disabledColor: AppColors.lightTextDisabled,
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
          return AppColors.lightTextTertiary;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary.withValues(alpha: 0.5);
          }
          return AppColors.lightBorder;
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
          return AppColors.lightTextSecondary;
        }),
      ),

      // ========================================================================
      // SNACKBAR
      // ========================================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.lightTextPrimary,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.lightBackground,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppRadius.smallRadius),
        behavior: SnackBarBehavior.floating,
      ),

      // ========================================================================
      // MISC
      // ========================================================================
      dividerColor: AppColors.lightDivider,
      disabledColor: AppColors.lightTextDisabled,
      highlightColor: AppColors.primary.withValues(alpha: 0.1),
      splashColor: AppColors.primary.withValues(alpha: 0.2),
      hoverColor: AppColors.primary.withValues(alpha: 0.05),
      focusColor: AppColors.primary.withValues(alpha: 0.12),
    );
  }
}
