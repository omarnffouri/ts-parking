import 'package:flutter/material.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_typography.dart';

/// StatusBadge - Displays status with color-coded badges
/// Used for parking status, booking status, etc.
class StatusBadge extends StatelessWidget {
  final String status;
  final StatusBadgeSize size;
  final bool uppercase;
  final FontWeight? fontWeight;
  final double? borderRadius;

  const StatusBadge({
    super.key,
    required this.status,
    this.size = StatusBadgeSize.medium,
    this.uppercase = true,
    this.fontWeight = FontWeight.bold,
    this.borderRadius,
  });

  const StatusBadge.small({
    super.key,
    required this.status,
    this.uppercase = true,
    this.fontWeight = FontWeight.bold,
    this.borderRadius,
  }) : size = StatusBadgeSize.small;

  const StatusBadge.medium({
    super.key,
    required this.status,
    this.uppercase = true,
    this.fontWeight = FontWeight.bold,
    this.borderRadius,
  }) : size = StatusBadgeSize.medium;

  const StatusBadge.large({
    super.key,
    required this.status,
    this.uppercase = true,
    this.fontWeight = FontWeight.bold,
    this.borderRadius,
  }) : size = StatusBadgeSize.large;

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final statusColor = AppColors.getStatusColor(status);
    final backgroundColor = AppColors.getStatusBackgroundColor(
      status,
      isDark: isDark,
    );

    return Container(
      padding: _getPadding(),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius ?? AppRadius.small),
        border: Border.all(color: statusColor.withValues(alpha: 0.3), width: 1),
      ),
      child: Text(
        _getStatusText(),
        style: _getTextStyle().copyWith(
          color: statusColor,
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case StatusBadgeSize.small:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        );
      case StatusBadgeSize.medium:
        return EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 4,
        ); // Match old design padding
      case StatusBadgeSize.large:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        );
    }
  }

  TextStyle _getTextStyle() {
    switch (size) {
      case StatusBadgeSize.small:
        return AppTypography.overline;
      case StatusBadgeSize.medium:
        return AppTypography.badge;
      case StatusBadgeSize.large:
        return AppTypography.caption;
    }
  }

  String _getStatusText() {
    if (uppercase) {
      return status.toUpperCase();
    }
    // Capitalize first letter of each word
    return status
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }
}

enum StatusBadgeSize { small, medium, large }

/// Predefined status badges for common use cases
class ActiveBadge extends StatelessWidget {
  final StatusBadgeSize size;

  const ActiveBadge({super.key, this.size = StatusBadgeSize.medium});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(status: 'active', size: size);
  }
}

class InactiveBadge extends StatelessWidget {
  final StatusBadgeSize size;

  const InactiveBadge({super.key, this.size = StatusBadgeSize.medium});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(status: 'inactive', size: size);
  }
}

class PendingBadge extends StatelessWidget {
  final StatusBadgeSize size;

  const PendingBadge({super.key, this.size = StatusBadgeSize.medium});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(status: 'pending', size: size);
  }
}

class CompletedBadge extends StatelessWidget {
  final StatusBadgeSize size;

  const CompletedBadge({super.key, this.size = StatusBadgeSize.medium});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(status: 'completed', size: size);
  }
}

class CancelledBadge extends StatelessWidget {
  final StatusBadgeSize size;

  const CancelledBadge({super.key, this.size = StatusBadgeSize.medium});

  @override
  Widget build(BuildContext context) {
    return StatusBadge(status: 'cancelled', size: size);
  }
}
