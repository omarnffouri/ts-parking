import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/booking_confirmation_controller.dart';
import 'plan_details_sheet.dart';

class SlotPriceBreakdown extends StatelessWidget {
  final BookingConfirmationController controller;
  final int slotId;
  final bool isDark;

  const SlotPriceBreakdown({
    super.key,
    required this.controller,
    required this.slotId,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final slot = controller.slotFor(slotId);
      final plan = controller.planForSlot(slotId);

      return Padding(
        padding: const EdgeInsets.only(top: AppSpacing.sm),
        child: Column(
          children: [
            // Plan badge — tappable
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: plan != null
                  ? () => showPlanDetailsSheet(context, plan)
                  : null,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.ms,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(AppRadius.small),
                    topRight: Radius.circular(AppRadius.small),
                  ),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  children: [
                    if (slot.isVip)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: Icon(
                          Icons.star_rounded,
                          size: 16,
                          color: AppColors.accent,
                        ),
                      ),
                    Text(
                      slot.planName.toUpperCase(),
                      style: AppTypography.bodySmallSemiBold.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                    if (plan != null) ...[
                      const SizedBox(width: 4),
                      Icon(
                        Icons.info_outline_rounded,
                        size: 14,
                        color: AppColors.accent.withValues(alpha: 0.6),
                      ),
                    ],
                    const Spacer(),
                    if (slot.hasDiscount) ...[
                      Text(
                        '\$${slot.priceBeforeDiscount.toStringAsFixed(0)}/mo',
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.lightTextTertiary,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xs),
                    ],
                    Text(
                      '\$${slot.price.toStringAsFixed(0)}/mo',
                      style: AppTypography.bodySmallSemiBold.copyWith(
                        color: slot.hasDiscount
                            ? AppColors.success
                            : AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Discount row
            if (slot.hasDiscount)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.ms,
                  vertical: AppSpacing.xs,
                ),
                color: AppColors.success.withValues(alpha: 0.06),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Discount',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                    Text(
                      '-\$${slot.discount.toStringAsFixed(0)}/mo',
                      style: AppTypography.bodySmallSemiBold.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),

            // Subtotal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.ms,
                vertical: AppSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.darkSurfaceVariant.withValues(alpha: 0.5)
                    : AppColors.lightBackground,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(AppRadius.small),
                  bottomRight: Radius.circular(AppRadius.small),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Subtotal',
                    style: AppTypography.bodySmallSemiBold.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    '\$${controller.totalPriceForSlot(slotId).toStringAsFixed(0)}',
                    style: AppTypography.bodySmallSemiBold.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
