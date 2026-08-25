import 'package:flutter/material.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../domain/entities/subscription_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import 'detail_row.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionEntity subscription;
  final bool isDark;
  final VoidCallback? onDelete;
  final bool isDeleting;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.isDark,
    this.onDelete,
    this.isDeleting = false,
  });

  static final _unavailableBg = AppColors.error.withValues(alpha: 0.08);
  static final _unavailableBorder = AppColors.error.withValues(alpha: 0.25);
  static final _unavailableSplash = AppColors.error.withValues(alpha: 0.12);
  static final _unavailableHighlight = AppColors.error.withValues(alpha: 0.06);
  static final _unavailableRadius = BorderRadius.circular(AppRadius.small);

  String _formatPlanType(String? type) {
    if (type == null || type.trim().isEmpty) return 'Standard';
    final lower = type.trim().toLowerCase();
    if (lower == 'vip') return 'VIP';
    return type[0].toUpperCase() + type.substring(1).toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    final isVip = subscription.subscriptionType?.toLowerCase() == 'vip';
    final isSlotUnavailable = subscription.isSlotUnavailable;
    final startedAt = subscription.startedAt;
    final endDate = startedAt != null && subscription.duration > 0
        ? DateTime(
            startedAt.year,
            startedAt.month + subscription.duration,
            startedAt.day,
          )
        : subscription.nextBillingDate;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isVip
                          ? AppColors.primary.withValues(alpha: 0.15)
                          : AppColors.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Text(
                      subscription.slotCode ?? '-',
                      style: AppTypography.bodySmallSemiBold.copyWith(
                        color: isVip ? AppColors.primary : AppColors.secondary,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    _formatPlanType(subscription.subscriptionType),
                    style: AppTypography.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                '\$${subscription.totalAmount.toStringAsFixed(0)}',
                style: AppTypography.bodyLargeSemiBold.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          if (isSlotUnavailable && onDelete != null) ...[
            SizedBox(height: AppSpacing.sm),
            Material(
              color: _unavailableBg,
              shape: RoundedRectangleBorder(
                side: BorderSide(color: _unavailableBorder),
                borderRadius: _unavailableRadius,
              ),
              child: InkWell(
                onTap: isDeleting ? null : onDelete,
                borderRadius: _unavailableRadius,
                splashColor: _unavailableSplash,
                highlightColor: _unavailableHighlight,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline_rounded,
                        size: 16,
                        color: AppColors.error,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          'Slot just booked by someone else. Tap to remove and update the total.',
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.error,
                            height: 1.35,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      isDeleting
                          ? LoadingWidget(size: 18, color: AppColors.error)
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Remove',
                                  style: AppTypography.buttonSmall.copyWith(
                                    color: AppColors.error,
                                  ),
                                ),
                                SizedBox(width: AppSpacing.xs),
                                Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 14,
                                  color: AppColors.error,
                                ),
                              ],
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              height: 1,
            ),
          ),
          DetailRow(
            icon: Icons.calendar_today_rounded,
            label: DateTimeUtils.formatDisplayDateOrDash(
              subscription.startedAt,
            ),
            value: 'to ${DateTimeUtils.formatDisplayDateOrDash(endDate)}',
            isDark: isDark,
          ),
          SizedBox(height: AppSpacing.xs),
          DetailRow(
            icon: Icons.schedule_rounded,
            label:
                '${subscription.duration} ${subscription.duration == 1 ? 'Month' : 'Months'}',
            value: subscription.autoRenew ? 'Auto-renew' : 'No renewal',
            isDark: isDark,
          ),
          if (subscription.planPrice != null) ...[
            SizedBox(height: AppSpacing.xs),
            DetailRow(
              icon: Icons.attach_money_rounded,
              label: '\$${subscription.planPrice!.toStringAsFixed(0)}/mo',
              value: '× ${subscription.duration}',
              isDark: isDark,
            ),
          ],
          if (subscription.discount != null && subscription.discount! > 0) ...[
            SizedBox(height: AppSpacing.xs),
            DetailRow(
              icon: Icons.discount_outlined,
              label: 'Discount',
              value: '-\$${subscription.discount!.toStringAsFixed(0)}',
              isDark: isDark,
              valueColor: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }
}
