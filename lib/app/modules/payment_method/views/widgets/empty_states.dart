import 'package:flutter/material.dart';

import '../../../../core/utils/theme_extensions.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

class EmptyTransactions extends StatelessWidget {
  const EmptyTransactions({super.key, required this.textColor});

  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.darkSurfaceVariant
            : const Color(0xFFF8F7FB),
        borderRadius: AppRadius.largeRadius,
      ),
      child: Text(
        'No transactions yet. New payments will appear here.',
        style: AppTypography.bodyMedium.copyWith(color: textColor),
      ),
    );
  }
}

class EmptyCards extends StatelessWidget {
  const EmptyCards({
    super.key,
    required this.secondaryTextColor,
    required this.surfaceColor,
    required this.isDark,
  });

  final Color secondaryTextColor;
  final Color surfaceColor;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: secondaryTextColor.withValues(alpha: isDark ? 0.25 : 0.18),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.credit_card_off_rounded,
              color: AppColors.primary,
              size: 30,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'No cards added yet',
            style: AppTypography.h3.copyWith(
              color: context.isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Tap the bouncing add card button to save your first payment method.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(color: secondaryTextColor),
          ),
          SizedBox(height: AppSpacing.md),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: AppRadius.pillRadius,
            ),
            child: Text(
              'Your recent transactions can still appear below',
              style: AppTypography.bodySmallSemiBold.copyWith(
                color: AppColors.primaryDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
