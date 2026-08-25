import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../core/utils/string_extensions.dart';
import '../../../../core/enums/parking_vehicle_type.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/slot_selection_controller.dart';

class VehicleTypeSelector extends StatelessWidget {
  const VehicleTypeSelector({super.key, required this.controller});

  final SlotSelectionController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final types = controller.availableVehicleTypes;
      final selectedTypeId = controller.selectedVehicleTypeId.value;

      if (types.isEmpty) {
        return const SizedBox.shrink();
      }

      return SizedBox(
        height: 44,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: types.length,
          separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
          itemBuilder: (context, index) {
            final type = types[index];
            final isSelected = type.id == selectedTypeId;
            final icon = ParkingVehicleTypeX.fromApiName(type.name).iconAsset;

            return InkWell(
              onTap: () => controller.selectVehicleType(type),
              borderRadius: AppRadius.pillRadius,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : context.panelColor,
                  borderRadius: AppRadius.pillRadius,
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : context.panelBorderColor,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      icon,
                      width: 18,
                      color: isSelected
                          ? AppColors.lightTextPrimary
                          : context.primaryTextColor,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      type.name.toTitleCase(),
                      style: AppTypography.bodySmallSemiBold.copyWith(
                        color: isSelected
                            ? AppColors.lightTextPrimary
                            : context.primaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
