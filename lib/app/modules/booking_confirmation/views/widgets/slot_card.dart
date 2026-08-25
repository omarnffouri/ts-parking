import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/booking_confirmation_controller.dart';
import 'slot_config_content.dart';

class SlotCard extends StatelessWidget {
  final BookingConfirmationController controller;
  final int slotIndex;
  final bool isExpanded;
  final bool isDark;

  const SlotCard({
    super.key,
    required this.controller,
    required this.slotIndex,
    required this.isExpanded,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final slot = controller.selectedSlots[slotIndex];

    return Obx(() {
      final selection = controller.selectionFor(slot.id);
      final isConfigured = selection.isConfigured;

      return Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.ms),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: AppRadius.mediumRadius,
          border: Border.all(
            color: isExpanded
                ? AppColors.secondary.withValues(alpha: 0.4)
                : isConfigured
                ? AppColors.primary.withValues(alpha: 0.6)
                : isDark
                ? AppColors.darkBorder
                : AppColors.secondary.withValues(alpha: 0.5),
            width: isExpanded ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => controller.toggleExpanded(slotIndex),
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.sm,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withValues(alpha: 0.1),
                        borderRadius: AppRadius.smallRadius,
                      ),
                      child: Text(
                        slot.slotCode,
                        style: AppTypography.bodySmallSemiBold.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.ms),
                    if (slot.isVip)
                      Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: Icon(
                          Icons.star_rounded,
                          size: 14,
                          color: AppColors.accent,
                        ),
                      ),
                    Expanded(
                      child: Text(
                        isConfigured
                            ? '${slot.planName.toUpperCase()} - ${controller.durationLabelForSlot(slot.id)}'
                            : 'Tap to configure',
                        style: AppTypography.bodySmall.copyWith(
                          color: isConfigured
                              ? isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.lightTextPrimary
                              : isDark
                              ? AppColors.darkTextTertiary
                              : AppColors.lightTextTertiary,
                        ),
                      ),
                    ),
                    if (isConfigured)
                      Text(
                        '\$${controller.totalPriceForSlot(slot.id).toStringAsFixed(0)}',
                        style: AppTypography.bodySmallSemiBold.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    const SizedBox(width: AppSpacing.sm),
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down_rounded,
                        size: 20,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            AnimatedSize(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              child: isExpanded
                  ? SlotConfigContent(
                      controller: controller,
                      slotId: slot.id,
                      slotIndex: slotIndex,
                      isDark: isDark,
                    )
                  : const SizedBox(width: double.infinity),
            ),
          ],
        ),
      );
    });
  }
}
