import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../core/utils/theme_extensions.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/slot_selection_controller.dart';
import 'pricing_plans_sheet.dart';
import 'visual_action_chip.dart';

class AvailabilityCard extends StatelessWidget {
  const AvailabilityCard({super.key, required this.controller});

  final SlotSelectionController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final count = controller.availableCount;
      final label = count == 1 ? '1 slot available' : '$count slots available';

      return Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: context.panelColor,
          borderRadius: AppRadius.largeRadius,
          border: Border.all(color: context.panelBorderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: context.isDark ? 0.2 : 0.06,
              ),
              blurRadius: 20,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Flexible(
                        child: Text(
                          label,
                          style: AppTypography.bodyMediumSemiBold.copyWith(
                            color: context.primaryTextColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    'Peak time: High traffic.',
                    style: AppTypography.bodySmall.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            GestureDetector(
              onTap: () => showPricingPlansSheet(context),
              child: const VisualActionChip(
                label: 'View Plans',
                icon: Icons.sell_outlined,
              ),
            ),
          ],
        ),
      );
    });
  }
}
