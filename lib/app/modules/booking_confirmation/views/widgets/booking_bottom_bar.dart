import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/booking_confirmation_controller.dart';

class BookingBottomBar extends StatelessWidget {
  final BookingConfirmationController controller;
  final bool isDark;

  const BookingBottomBar({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: bottomPadding + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Obx(() {
        final canConfirm = controller.canConfirm;
        final isSubmitting = controller.isSubmitting;

        return Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Grand Total',
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : Colors.black,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '\$${controller.grandTotal.toStringAsFixed(0)}',
                    style: AppTypography.h3.copyWith(color: AppColors.accent),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            ElevatedButton(
              onPressed: canConfirm && !isSubmitting
                  ? controller.navigateToSummary
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: Colors.white,
                disabledBackgroundColor: isDark
                    ? AppColors.darkSurfaceVariant
                    : AppColors.lightBorder,
                disabledForegroundColor: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
                shape: RoundedRectangleBorder(
                  borderRadius: AppRadius.mediumRadius,
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.ms,
                ),
              ),
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      canConfirm ? 'Confirm Booking' : 'Configure all slots',
                      style: AppTypography.buttonMedium,
                    ),
            ),
          ],
        );
      }),
    );
  }
}
