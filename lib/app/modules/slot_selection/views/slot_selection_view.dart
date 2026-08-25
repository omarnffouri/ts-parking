import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';

import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../controllers/slot_selection_controller.dart';
import 'widgets/availability_card.dart';
import 'widgets/selection_panel.dart';
import 'widgets/slot_content.dart';
import 'widgets/slot_header.dart';
import 'widgets/vehicle_type_selector.dart';

class SlotSelectionView extends GetView<SlotSelectionController> {
  const SlotSelectionView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? AppColors.darkPageGradient
              : AppColors.lightPageGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.sm),
                const SlotHeader(),
                const SizedBox(height: AppSpacing.md),
                AvailabilityCard(controller: controller),
                const SizedBox(height: AppSpacing.md),
                VehicleTypeSelector(controller: controller),
                const SizedBox(height: AppSpacing.md),
                Expanded(child: SlotContent(controller: controller)),
                const SizedBox(height: AppSpacing.md),
                SelectionPanel(controller: controller),
                const SizedBox(height: AppSpacing.md),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
