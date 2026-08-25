import 'package:flutter/material.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/theme_extensions.dart';
import '../../../../domain/entities/overstay_item_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import 'detail_row.dart';

class OverstayItemCard extends StatelessWidget {
  final OverstayItemEntity overstay;

  const OverstayItemCard({super.key, required this.overstay});

  String _formatPeriod() {
    final from = DateTimeUtils.formatDisplayDate(overstay.periodFrom);
    final to = DateTimeUtils.formatDisplayDate(overstay.periodTo);
    if (from == to) return from;
    return '$from - $to';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.panelColor,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: context.panelBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: Text(
                  'Overstay',
                  style: AppTypography.bodySmallSemiBold.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ),
              Text(
                '\$${overstay.amount.toStringAsFixed(2)}',
                style: AppTypography.bodyLargeSemiBold.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            child: Divider(color: context.panelBorderColor, height: 1),
          ),
          DetailRow(
            icon: Icons.date_range_outlined,
            label: 'Period',
            value: _formatPeriod(),
            isDark: isDark,
          ),
          SizedBox(height: AppSpacing.xs),
          DetailRow(
            icon: Icons.attach_money_rounded,
            label: 'Rate',
            value: '\$${overstay.rate.toStringAsFixed(2)}/day',
            isDark: isDark,
          ),
          if (overstay.note != null && overstay.note!.isNotEmpty) ...[
            SizedBox(height: AppSpacing.xs),
            DetailRow(
              icon: Icons.notes_rounded,
              label: 'Note',
              value: overstay.note!,
              isDark: isDark,
            ),
          ],
        ],
      ),
    );
  }
}
