import 'package:flutter/material.dart';

import '../../../../core/utils/date_utils.dart';
import '../../../../core/widgets/status_badge.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

class InvoiceHeader extends StatelessWidget {
  final String invoiceNumber;
  final DateTime issuedAt;
  final String status;
  final bool isDark;

  const InvoiceHeader({
    super.key,
    required this.invoiceNumber,
    required this.issuedAt,
    required this.status,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              invoiceNumber,
              style: AppTypography.bodyLargeSemiBold.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Issued ${DateTimeUtils.formatDisplayDate(issuedAt)}',
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
        ),
        StatusBadge.small(status: status),
      ],
    );
  }
}
