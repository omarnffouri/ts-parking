import 'package:flutter/material.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'app_button.dart';

/// EmptyState - Display when lists or data are empty
/// Provides helpful messages and optional actions
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final double? iconSize;
  final Color? iconColor;
  final Color? iconBackgroundColor;
  final double? iconContainerSize;
  final BorderRadius? iconBorderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? titleStyle;
  final TextStyle? messageStyle;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconSize,
    this.iconColor,
    this.iconBackgroundColor,
    this.iconContainerSize,
    this.iconBorderRadius,
    this.padding,
    this.titleStyle,
    this.messageStyle,
  });

  /// Empty state for when there are no parking spots
  const EmptyState.noParkingSpots({
    super.key,
    this.actionLabel = 'Add Parking',
    this.onAction,
  }) : icon = Icons.local_parking_rounded,
       title = 'No Parking Spots Yet',
       message = 'Get started by adding your first parking spot to the system.',
       iconSize = null,
       iconColor = null,
       iconBackgroundColor = null,
       iconContainerSize = null,
       iconBorderRadius = null,
       padding = null,
       titleStyle = null,
       messageStyle = null;

  /// Empty state for when there are no bookings
  const EmptyState.noBookings({
    super.key,
    this.actionLabel = 'Create Booking',
    this.onAction,
  }) : icon = Icons.event_note_outlined,
       title = 'No Bookings',
       message =
           'You don\'t have any lesson bookings yet. Create your first booking to get started.',
       iconSize = null,
       iconColor = null,
       iconBackgroundColor = null,
       iconContainerSize = null,
       iconBorderRadius = null,
       padding = null,
       titleStyle = null,
       messageStyle = null;

  /// Empty state for search results
  const EmptyState.noResults({super.key, this.actionLabel, this.onAction})
    : icon = Icons.search_off_rounded,
      title = 'No Results Found',
      message =
          'We couldn\'t find any matches for your search. Try different keywords.',
      iconSize = null,
      iconColor = null,
      iconBackgroundColor = null,
      iconContainerSize = null,
      iconBorderRadius = null,
      padding = null,
      titleStyle = null,
      messageStyle = null;

  /// Empty state for reports
  const EmptyState.noData({super.key, this.actionLabel, this.onAction})
    : icon = Icons.insert_chart_outlined_rounded,
      title = 'No Data Available',
      message = 'There\'s no data to display for the selected period.',
      iconSize = null,
      iconColor = null,
      iconBackgroundColor = null,
      iconContainerSize = null,
      iconBorderRadius = null,
      padding = null,
      titleStyle = null,
      messageStyle = null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final resolvedIconColor =
        iconColor ??
        (isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary);
    final iconWidget = Icon(
      icon,
      size: iconSize ?? 80,
      color: resolvedIconColor,
    );

    return Center(
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (iconBackgroundColor != null)
              Container(
                width: iconContainerSize ?? 72,
                height: iconContainerSize ?? 72,
                decoration: BoxDecoration(
                  color: iconBackgroundColor,
                  borderRadius: iconBorderRadius ?? AppRadius.xlargeRadius,
                ),
                child: Center(child: iconWidget),
              )
            else
              iconWidget,

            SizedBox(height: AppSpacing.lg),

            Text(
              title,
              style:
                  titleStyle ??
                  AppTypography.h3.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppSpacing.sm),

            Text(
              message,
              style:
                  messageStyle ??
                  AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
              textAlign: TextAlign.center,
            ),

            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                label: actionLabel!,
                onPressed: onAction!,
                fullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
