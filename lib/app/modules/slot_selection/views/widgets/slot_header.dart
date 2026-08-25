import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/slot_selection_controller.dart';

class SlotHeader extends GetView<SlotSelectionController> {
  const SlotHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final title = 'Book ${controller.selectedVehicleTypeLabel} Parking';

      return Row(
        children: [
          InkWell(
            onTap: Get.back,
            borderRadius: AppRadius.mediumRadius,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: context.panelColor,
                borderRadius: AppRadius.mediumRadius,
                border: Border.all(color: context.panelBorderColor),
              ),
              child: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.primaryTextColor,
                size: 18,
              ),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.bodyMediumSemiBold.copyWith(
                color: context.primaryTextColor,
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(width: 44),
        ],
      );
    });
  }
}
