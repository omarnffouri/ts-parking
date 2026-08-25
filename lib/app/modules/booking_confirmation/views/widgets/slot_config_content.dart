import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/booking_confirmation_controller.dart';
import 'slot_date_picker.dart';
import 'slot_duration_selector.dart';
import 'slot_price_breakdown.dart';
import 'slot_vehicle_dropdown.dart';

class SlotConfigContent extends StatelessWidget {
  final BookingConfirmationController controller;
  final int slotId;
  final int slotIndex;
  final bool isDark;

  const SlotConfigContent({
    super.key,
    required this.controller,
    required this.slotId,
    required this.slotIndex,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.ms,
        right: AppSpacing.ms,
        bottom: AppSpacing.ms,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Divider(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            height: 1,
          ),
          const SizedBox(height: AppSpacing.sm),

          SlotVehicleDropdown(
            controller: controller,
            slotId: slotId,
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),

          Row(
            children: [
              Expanded(
                child: SlotDatePicker(
                  controller: controller,
                  slotId: slotId,
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: SlotDurationSelector(
                  controller: controller,
                  slotId: slotId,
                  isDark: isDark,
                ),
              ),
            ],
          ),
          Obx(() {
            final endDate = controller.formattedEndDateForSlot(slotId);
            if (endDate.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                'Ends $endDate',
                style: AppTypography.overline.copyWith(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
            );
          }),
          const SizedBox(height: AppSpacing.sm),

          Obx(() {
            final selection = controller.selectionFor(slotId);
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Auto-renew',
                  style: AppTypography.bodySmall.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                SizedBox(
                  height: 24,
                  child: Switch(
                    value: selection.autoRenew.value,
                    onChanged: (value) {
                      selection.autoRenew.value = value;
                      controller.slotSelections.refresh();
                    },
                    activeThumbColor: AppColors.accent,
                  ),
                ),
              ],
            );
          }),

          SlotPriceBreakdown(
            controller: controller,
            slotId: slotId,
            isDark: isDark,
          ),

          if (controller.slotCount > 1)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.sm),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => controller.applyToAll(slotId),
                  icon: const Icon(Icons.copy_all_rounded, size: 16),
                  label: const Text('Apply to all slots'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: BorderSide(
                      color: AppColors.accent.withValues(alpha: 0.4),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppRadius.mediumRadius,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.ms,
                    ),
                    textStyle: AppTypography.bodySmallSemiBold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
