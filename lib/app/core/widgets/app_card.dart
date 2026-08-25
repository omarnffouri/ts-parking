import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_shadows.dart';

/// AppCard - Reusable card component with consistent styling
/// Follows DriveFlow design system specifications
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final VoidCallback? onTap;
  final Color? color;
  final String shadowSize;
  final double? borderRadius;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.onTap,
    this.color,
    this.shadowSize = 'small',
    this.borderRadius,
    this.border,
  });

  const AppCard.compact({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.shadowSize = 'small',
    this.borderRadius,
    this.border,
  }) : padding = const EdgeInsets.all(12),
       margin = null;

  const AppCard.padded({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.shadowSize = 'small',
    this.borderRadius,
    this.border,
  }) : padding = const EdgeInsets.all(16),
       margin = null;

  const AppCard.large({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.shadowSize = 'medium',
    this.borderRadius,
    this.border,
  }) : padding = const EdgeInsets.all(24),
       margin = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final cardColor =
        color ?? (isDark ? AppColors.darkSurface : AppColors.lightSurface);

    final cardDecoration = BoxDecoration(
      color: cardColor,
      borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.medium),
      boxShadow: AppShadows.getShadow(
        size: shadowSize,
        brightness: theme.brightness,
      ),
      border: border,
    );

    final content = Container(
      padding: padding ?? EdgeInsets.all(AppSpacing.cardPadding),
      margin: margin,
      decoration: cardDecoration,
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.medium),
        child: content,
      );
    }

    return content;
  }
}

/// Clickable card with hover effect
class AppClickableCard extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const AppClickableCard({
    super.key,
    required this.child,
    required this.onTap,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      color: color ?? (isDark ? AppColors.darkSurface : AppColors.lightSurface),
      borderRadius: AppRadius.mediumRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mediumRadius,
        child: Container(
          padding: padding ?? EdgeInsets.all(AppSpacing.cardPadding),
          decoration: BoxDecoration(
            borderRadius: AppRadius.mediumRadius,
            boxShadow: AppShadows.getShadow(
              size: 'small',
              brightness: theme.brightness,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
