import 'package:flutter/material.dart';

import '../../domain/entities/invoice_entity.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';
import 'label_value_row.dart';

class InvoiceSummaryCard extends StatelessWidget {
  final InvoiceEntity invoice;
  final String? yardName;
  final String totalLabel;
  final bool isDark;

  const InvoiceSummaryCard({
    super.key,
    required this.invoice,
    this.yardName,
    this.totalLabel = 'Total',
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
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
          if (yardName != null && yardName!.isNotEmpty) ...[
            Text(
              yardName!,
              style: AppTypography.bodyLargeSemiBold.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Invoice #${invoice.invoiceNumber}',
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.ms),
              child: Divider(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                height: 1,
              ),
            ),
          ],
          LabelValueRow(
            label: 'Subtotal',
            value: '\$${invoice.subtotal.toStringAsFixed(2)}',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.xs),
          if (invoice.discountAmount > 0) ...[
            LabelValueRow(
              label: 'Discount',
              value: '-\$${invoice.discountAmount.toStringAsFixed(2)}',
              isDark: isDark,
              valueColor: AppColors.success,
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          if (invoice.tax > 0) ...[
            LabelValueRow(
              label: 'Tax',
              value: '\$${invoice.tax.toStringAsFixed(2)}',
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.xs),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
            child: Divider(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              height: 1,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                totalLabel,
                style: AppTypography.bodyLargeSemiBold.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              Text(
                '\$${invoice.total.toStringAsFixed(2)}',
                style: AppTypography.bodyLargeSemiBold.copyWith(
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
