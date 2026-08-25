import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_floating_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../domain/entities/vehicle_type_entity.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../controllers/add_vehicle_controller.dart';

class AddVehicleView extends GetView<AddVehicleController> {
  const AddVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return PopScope(
      canPop: !controller.isGateMode,
      child: Scaffold(
        backgroundColor: colorScheme.primary,
        body: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screenHorizontal,
                  AppSpacing.md,
                  AppSpacing.screenHorizontal,
                  AppSpacing.md,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => Get.back(),
                            borderRadius: AppRadius.smallRadius,
                            child: const Padding(
                              padding: EdgeInsets.all(4),
                              child: Icon(
                                Icons.arrow_back_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            controller.isEditMode
                                ? 'Edit Vehicle'
                                : 'Add Your Vehicle',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (controller.isGateMode)
                          Material(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: AppRadius.smallRadius,
                            child: InkWell(
                              onTap: controller.switchAccount,
                              borderRadius: AppRadius.smallRadius,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: AppSpacing.ms,
                                  vertical: AppSpacing.xs,
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.swap_horiz_rounded,
                                      color: Colors.white,
                                      size: 18,
                                    ),
                                    SizedBox(width: AppSpacing.xs),
                                    Text(
                                      'Switch Account',
                                      style: theme.textTheme.bodySmall
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (controller.isGateMode) ...[
                      SizedBox(height: AppSpacing.sm),
                      Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.local_shipping,
                              size: 64,
                              color: Colors.white.withValues(alpha: 0.85),
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              'Register your vehicle to start booking parking',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      SizedBox(height: AppSpacing.xs),
                      Padding(
                        padding: EdgeInsets.only(left: 36),
                        child: Text(
                          controller.isEditMode
                              ? 'Update your vehicle details'
                              : 'Enter your vehicle information',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: context.backgroundColor,
                  borderRadius: AppRadius.xlargeTopRadius,
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.screenHorizontal,
                    vertical: AppSpacing.lg,
                  ),
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Vehicle Type
                        const SectionHeader(label: 'Vehicle Type'),
                        SizedBox(height: AppSpacing.ms),
                        Obx(() {
                          if (controller.isLoadingTypes) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: controller.vehicleTypes
                                  .map(
                                    (type) => Padding(
                                      padding: EdgeInsets.only(
                                        right:
                                            type == controller.vehicleTypes.last
                                            ? 0
                                            : AppSpacing.ms,
                                      ),
                                      child: _VehicleTypeCard(
                                        type: type,
                                        isSelected:
                                            controller.selectedTypeId ==
                                            type.id,
                                        onTap: () =>
                                            controller.selectType(type.id),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          );
                        }),

                        // Vehicle Details
                        SizedBox(height: AppSpacing.lg),
                        const SectionHeader(label: 'Vehicle Details'),
                        SizedBox(height: AppSpacing.ms),
                        AppFloatingField(
                          label: 'License Plate',
                          controller: controller.plateController,
                          validator: controller.validatePlate,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.credit_card_outlined),
                        ),

                        SizedBox(height: AppSpacing.formFieldSpacing),

                        AppFloatingField(
                          label: 'Nickname (Optional)',
                          controller: controller.nicknameController,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.label_outline),
                        ),

                        SizedBox(height: AppSpacing.formFieldSpacing),

                        AppFloatingField(
                          label: 'Model (Optional)',
                          controller: controller.modelController,
                          textInputAction: TextInputAction.next,
                          prefixIcon: const Icon(Icons.directions_car_outlined),
                        ),

                        SizedBox(height: AppSpacing.formFieldSpacing),

                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: AppFloatingField(
                                label: 'Color',
                                controller: controller.colorController,
                                textInputAction: TextInputAction.next,
                                prefixIcon: const Icon(Icons.palette_outlined),
                              ),
                            ),
                            SizedBox(width: AppSpacing.ms),
                            Expanded(
                              child: AppFloatingField(
                                label: 'Year',
                                controller: controller.yearController,
                                textInputAction: TextInputAction.done,
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                                prefixIcon: const Icon(
                                  Icons.calendar_today_outlined,
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: AppSpacing.xl),

                        Obx(
                          () => AppButton.primary(
                            label: controller.isEditMode
                                ? 'Save Changes'
                                : 'Add Vehicle',
                            icon: controller.isEditMode
                                ? Icons.check_rounded
                                : Icons.add_rounded,
                            isLoading: controller.isLoading,
                            useGlow: false,
                            onPressed: controller.isLoading
                                ? null
                                : controller.submit,
                          ),
                        ),
                        SizedBox(
                          height:
                              MediaQuery.of(context).padding.bottom +
                              AppSpacing.md,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VehicleTypeCard extends StatelessWidget {
  final VehicleTypeEntity type;
  final bool isSelected;
  final VoidCallback onTap;

  const _VehicleTypeCard({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  IconData get _icon {
    return switch (type.name.toLowerCase()) {
      'truck' => Icons.local_shipping_outlined,
      'trailer' => Icons.airport_shuttle_outlined,
      'bobtail' => Icons.fire_truck_outlined,
      _ => Icons.directions_car_outlined,
    };
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    final selectedBg = AppColors.primary.withValues(alpha: 0.1);
    final unselectedBg = colorScheme.surface;
    final selectedBorder = AppColors.primary;
    final unselectedBorder = colorScheme.outlineVariant;
    final selectedColor = AppColors.primary;
    final unselectedColor = theme.hintColor;

    return Material(
      color: isSelected ? selectedBg : unselectedBg,
      borderRadius: AppRadius.mediumRadius,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mediumRadius,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 110,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.ms),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected ? selectedBorder : unselectedBorder,
              width: isSelected ? 2.0 : 1.0,
            ),
            borderRadius: AppRadius.mediumRadius,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                _icon,
                size: 32,
                color: isSelected ? selectedColor : unselectedColor,
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                type.name[0].toUpperCase() + type.name.substring(1),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected ? selectedColor : unselectedColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
