import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../../../domain/entities/notification_entity.dart';
import '../../../../core/enums/notification_type.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

class NotificationTile extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const NotificationTile({
    super.key,
    required this.notification,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconData = _iconForType(notification.type);
    final iconColor = _colorForType(notification.type);

    return Material(
      color: notification.isRead
          ? Colors.transparent
          : iconColor.withValues(alpha: isDark ? 0.06 : 0.04),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.ms,
          ),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                color: notification.isRead ? Colors.transparent : iconColor,
                width: 3,
              ),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  borderRadius: AppRadius.smallRadius,
                ),
                child: Icon(iconData, color: iconColor, size: 20),
              ),
              const SizedBox(width: AppSpacing.ms),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      notification.title,
                      style: AppTypography.bodyMedium.copyWith(
                        fontWeight: notification.isRead
                            ? FontWeight.normal
                            : FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      notification.message,
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      timeago.format(notification.createdAt),
                      style: AppTypography.bodySmall.copyWith(
                        color: colorScheme.onSurface.withValues(alpha: 0.35),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              if (!notification.isRead)
                Padding(
                  padding: const EdgeInsets.only(top: 6, left: AppSpacing.sm),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _iconForType(NotificationType type) {
    if (type.isSubscriptionType) return Icons.card_membership_outlined;
    return switch (type) {
      NotificationType.invoicePaid => Icons.receipt_long_outlined,
      _ => Icons.notifications_outlined,
    };
  }

  Color _colorForType(NotificationType type) {
    if (type.isSubscriptionType) {
      return switch (type) {
        NotificationType.subscriptionActivated ||
        NotificationType.subscriptionRenewed => AppColors.success,
        NotificationType.subscriptionExpired ||
        NotificationType.subscriptionCancelled => AppColors.error,
        _ => AppColors.primary,
      };
    }
    return switch (type) {
      NotificationType.invoicePaid => AppColors.success,
      _ => AppColors.primary,
    };
  }
}
