import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/widgets/loading_widget.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';
import '../../theme/app_shadows.dart';

/// AppButton - Reusable button component with multiple variants
/// Follows DriveFlow design system specifications
enum AppButtonVariant { primary, secondary, outlined, text }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool fullWidth;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? borderColor;
  final bool useGlow;
  final BorderRadius? borderRadius;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.useGlow = true,
    this.borderRadius,
  });

  /// Primary button
  const AppButton.primary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.fullWidth = true,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.useGlow = true,
    this.borderRadius,
  }) : variant = AppButtonVariant.primary;

  /// Secondary button
  const AppButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.fullWidth = true,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.useGlow = false,
    this.borderRadius,
  }) : variant = AppButtonVariant.secondary;

  /// Outlined button (Purple border, transparent background)
  const AppButton.outlined({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.size = AppButtonSize.large,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.useGlow = true,
    this.borderRadius,
  }) : variant = AppButtonVariant.outlined;

  /// Text button (No background, no border)
  const AppButton.text({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.fullWidth = false,
    this.padding,
    this.width,
    this.height,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.useGlow = true,
    this.borderRadius,
  }) : variant = AppButtonVariant.text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Get padding based on size
    EdgeInsetsGeometry buttonPadding = padding ?? _getPadding();

    // Get text style based on size
    TextStyle textStyle = _getTextStyle();

    Widget child = Row(
      mainAxisSize: fullWidth ? MainAxisSize.max : MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading)
          SizedBox(
            width: 20,
            height: 20,
            child: LoadingWidget(size: 2, color: _getLoadingColor(isDark)),
          )
        else if (icon != null)
          Icon(icon, size: _getIconSize()),
        if ((isLoading || icon != null)) SizedBox(width: AppSpacing.sm),
        if (!isLoading || icon == null)
          Flexible(
            child: Text(
              label,
              style: textStyle,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
      ],
    );

    Widget button = _buildButton(context, child, buttonPadding, isDark);

    if (fullWidth && width == null) {
      return SizedBox(
        width: double.infinity,
        height: height ?? _getHeight(),
        child: button,
      );
    }

    return SizedBox(
      width: width,
      height: height ?? _getHeight(),
      child: button,
    );
  }

  Widget _buildButton(
    BuildContext context,
    Widget child,
    EdgeInsetsGeometry buttonPadding,
    bool isDark,
  ) {
    final theme = Theme.of(context);

    switch (variant) {
      case AppButtonVariant.primary:
        final isEnabled = onPressed != null && !isLoading;
        final resolvedBg =
            backgroundColor ??
            (isDark ? AppColors.secondary : AppColors.primary);
        final useGradient = isEnabled && !isDark && backgroundColor == null;
        return Container(
          decoration: BoxDecoration(
            gradient: useGradient ? AppColors.primaryGradient : null,
            color: useGradient
                ? null
                : (isEnabled ? resolvedBg : theme.disabledColor),
            borderRadius: borderRadius ?? AppRadius.mediumRadius,
            boxShadow: isEnabled && useGlow ? AppShadows.primaryGlow : null,
          ),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: textColor ?? Colors.white,
              disabledBackgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.mediumRadius,
              ),
              padding: buttonPadding,
            ),
            child: child,
          ),
        );

      case AppButtonVariant.secondary:
        final resolvedSecondaryBg =
            backgroundColor ??
            (isDark ? AppColors.primary : AppColors.secondary);
        return ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: resolvedSecondaryBg,
            foregroundColor: textColor ?? Colors.white,
            disabledBackgroundColor: theme.disabledColor,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumRadius),
            padding: buttonPadding,
          ),
          child: child,
        );

      case AppButtonVariant.outlined:
        final resolvedOutlineColor = isDark
            ? AppColors.primary
            : AppColors.secondary;
        return OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: textColor ?? resolvedOutlineColor,
            side: BorderSide(
              color: isLoading || onPressed == null
                  ? theme.disabledColor
                  : (borderColor ?? resolvedOutlineColor),
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.mediumRadius),
            padding: buttonPadding,
          ),
          child: child,
        );

      case AppButtonVariant.text:
        final resolvedTextColor = isDark
            ? AppColors.primary
            : AppColors.secondary;
        return TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: textColor ?? resolvedTextColor,
            padding: buttonPadding,
          ),
          child: child,
        );
    }
  }

  EdgeInsetsGeometry _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonHorizontalCompact,
          vertical: AppSpacing.buttonVerticalCompact,
        );
      case AppButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.buttonHorizontal,
          vertical: AppSpacing.buttonVertical,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case AppButtonSize.small:
        return AppTypography.buttonSmall;
      case AppButtonSize.medium:
        return AppTypography.buttonMedium;
      case AppButtonSize.large:
        return AppTypography.button;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 18;
      case AppButtonSize.large:
        return 20;
    }
  }

  double? _getHeight() {
    // Return null to let the button size naturally based on padding
    return null;
  }

  Color _getLoadingColor(bool isDark) {
    switch (variant) {
      case AppButtonVariant.primary:
        return Colors.white;
      case AppButtonVariant.secondary:
        return Colors.white;
      case AppButtonVariant.outlined:
        return Colors.red;
      case AppButtonVariant.text:
        return AppColors.primary;
    }
  }
}
