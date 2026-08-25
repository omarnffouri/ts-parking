import 'package:flutter/material.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../../domain/entities/payment_transaction_entity.dart';

class TransactionTile extends StatelessWidget {
  const TransactionTile({
    super.key,
    required this.transaction,
    required this.textColor,
    required this.secondaryTextColor,
    required this.isDark,
  });

  final PaymentTransactionEntity transaction;
  final Color textColor;
  final Color secondaryTextColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = transaction.status.toLowerCase();
    final accentColor = switch (normalizedStatus) {
      'paid' => AppColors.success,
      'failed' => AppColors.error,
      _ => transaction.isCredit ? AppColors.success : AppColors.secondary,
    };

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF8F7FB),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.14),
              borderRadius: AppRadius.mediumRadius,
            ),
            child: Icon(
              normalizedStatus == 'failed'
                  ? Icons.close_rounded
                  : (transaction.isCredit
                        ? Icons.south_west_rounded
                        : Icons.north_east_rounded),
              color: accentColor,
            ),
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.title,
                  style: AppTypography.bodyLargeSemiBold.copyWith(
                    color: textColor,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  transaction.subtitle,
                  style: AppTypography.bodyMedium.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  transaction.timeLabel,
                  style: AppTypography.bodySmall.copyWith(
                    color: secondaryTextColor,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Text(
            transaction.amount,
            style: AppTypography.bodyLargeSemiBold.copyWith(
              color: transaction.isCredit ? AppColors.success : textColor,
            ),
          ),
        ],
      ),
    );
  }
}
