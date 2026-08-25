import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/booking_confirmation_controller.dart';

class SlotDatePicker extends StatelessWidget {
  final BookingConfirmationController controller;
  final int slotId;
  final bool isDark;

  const SlotDatePicker({
    super.key,
    required this.controller,
    required this.slotId,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selection = controller.selectionFor(slotId);

    return Obx(() {
      final hasDate = selection.startDate.value != null;

      return GestureDetector(
        onTap: () => controller.pickDateForSlot(context, slotId),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.ms,
          ),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.darkSurfaceVariant
                : AppColors.lightBackground,
            borderRadius: AppRadius.mediumRadius,
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
          child: Row(
            children: [
              Icon(
                Icons.calendar_today_rounded,
                size: 16,
                color: hasDate
                    ? AppColors.accent
                    : isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                hasDate
                    ? controller.formattedStartDateForSlot(slotId)
                    : 'Start date',
                style: AppTypography.bodySmall.copyWith(
                  color: hasDate
                      ? isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary
                      : isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
