import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/slot_selection_controller.dart';
import 'parking_map.dart';

class SlotContent extends StatelessWidget {
  const SlotContent({super.key, required this.controller});

  final SlotSelectionController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(
          child: LoadingWidget(
            key: ValueKey('slot_selection_loading'),
            size: 42,
            color: AppColors.primary,
            message: 'Loading slots...',
          ),
        );
      }

      if (controller.error.isNotEmpty) {
        return Center(
          child: Container(
            key: const ValueKey('slot_selection_error'),
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: context.panelColor,
              borderRadius: AppRadius.largeRadius,
              border: Border.all(color: context.panelBorderColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.error_outline_rounded,
                  color: AppColors.error,
                  size: 44,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  'Couldn\'t load slots',
                  style: AppTypography.h4.copyWith(
                    color: context.primaryTextColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  controller.error,
                  textAlign: TextAlign.center,
                  style: AppTypography.bodyMedium.copyWith(
                    color: context.secondaryTextColor,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton.primary(
                  label: 'Try again',
                  onPressed: controller.retry,
                  fullWidth: false,
                  backgroundColor: AppColors.primary,
                  textColor: AppColors.lightTextPrimary,
                  useGlow: false,
                ),
              ],
            ),
          ),
        );
      }

      if (controller.slots.isEmpty) {
        return const EmptyState(
          key: ValueKey('slot_selection_empty'),
          icon: Icons.local_shipping_outlined,
          title: 'No slots for this vehicle',
          message: 'Try another vehicle type or come back later.',
        );
      }

      return ParkingMap(controller: controller);
    });
  }
}
