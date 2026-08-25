import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/theme_extensions.dart';
import '../../../../core/widgets/accent_card.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../domain/entities/vehicle_charge_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';

class OverstayChargeCard extends StatelessWidget {
  final VehicleChargeEntity charge;
  final VoidCallback? onTap;

  const OverstayChargeCard({super.key, required this.charge, this.onTap});

  String _formatPeriod() {
    final from = DateTimeUtils.formatDisplayDate(charge.periodFrom);
    final to = DateTimeUtils.formatDisplayDate(charge.periodTo);
    if (from == to) return from;
    return '$from  \u2192  $to';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.isDark;
    final statusColor = charge.isUnpaid ? AppColors.error : AppColors.success;

    return GestureDetector(
      onTap: onTap,
      child: AccentCard(
        accentColor: statusColor,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withValues(
                        alpha: isDark ? 0.2 : 0.08,
                      ),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.local_shipping_outlined,
                          size: 14,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.secondary,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Text(
                          charge.licensePlate ?? 'Unknown',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.secondary,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  StatusBadge.small(status: charge.status),
                ],
              ),
              SizedBox(height: AppSpacing.ms),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '\$${charge.amount.toStringAsFixed(2)}',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: charge.isUnpaid
                          ? AppColors.error
                          : context.primaryTextColor,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'overstay fee',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: context.tertiaryTextColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppSpacing.ms),
              Divider(height: 1, color: context.panelBorderColor),
              SizedBox(height: AppSpacing.ms),
              _DetailRow(
                icon: Icons.date_range_outlined,
                label: 'Overstay Period',
                value: _formatPeriod(),
              ),
              SizedBox(height: AppSpacing.sm),
              _DetailRow(
                icon: Icons.confirmation_number_outlined,
                label: 'Subscription',
                value: charge.subscriptionRef ?? '-',
              ),
              if (charge.billingCycle != null) ...[
                SizedBox(height: AppSpacing.sm),
                _DetailRow(
                  icon: Icons.autorenew_rounded,
                  label: 'Billing Cycle',
                  value: charge.billingCycle!.capitalize ?? '-',
                ),
              ],
              if (charge.note != null && charge.note!.isNotEmpty) ...[
                SizedBox(height: AppSpacing.ms),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
                        : AppColors.lightSurfaceVariant,
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.notes_rounded,
                        size: 14,
                        color: context.tertiaryTextColor,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Text(
                          charge.note!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: context.secondaryTextColor,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 15, color: context.tertiaryTextColor),
        SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: context.secondaryTextColor,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: theme.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: context.primaryTextColor,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
