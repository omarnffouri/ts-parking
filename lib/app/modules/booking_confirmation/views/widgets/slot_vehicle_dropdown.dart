import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_dropdown.dart';
import '../../../../core/enums/parking_vehicle_type.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/booking_confirmation_controller.dart';

class SlotVehicleDropdown extends StatelessWidget {
  final BookingConfirmationController controller;
  final int slotId;
  final bool isDark;

  const SlotVehicleDropdown({
    super.key,
    required this.controller,
    required this.slotId,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selection = controller.selectionFor(slotId);

    return Obx(() {
      if (controller.vehiclesLoading) {
        return Container(
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
              SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Loading vehicles...',
                style: AppTypography.bodySmall.copyWith(
                  color: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                ),
              ),
            ],
          ),
        );
      }

      final filtered = controller.availableVehiclesForSlot(slotId);

      if (filtered.isEmpty) {
        return Container(
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
          child: Text(
            'No ${controller.vehicleType.label.toLowerCase()}s available',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextTertiary
                  : AppColors.lightTextTertiary,
            ),
          ),
        );
      }

      return AppDropdown<String>(
        value: selection.vehicleId.value,
        hint: 'Select a vehicle',
        items: filtered
            .map(
              (vehicle) => DropdownMenuItem<String>(
                value: vehicle.id,
                child: Row(
                  children: [
                    Icon(
                      Icons.local_shipping_rounded,
                      size: 16,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        vehicle.licensePlate,
                        style: AppTypography.bodySmall.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Text(
                      vehicle.licensePlate,
                      style: AppTypography.overline.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
        onChanged: (id) => controller.selectVehicleForSlot(slotId, id),
      );
    });
  }
}
