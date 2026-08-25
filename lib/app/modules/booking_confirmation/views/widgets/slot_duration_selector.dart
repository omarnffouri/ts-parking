import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/widgets/app_dropdown.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/booking_confirmation_controller.dart';

class SlotDurationSelector extends StatelessWidget {
  final BookingConfirmationController controller;
  final int slotId;
  final bool isDark;

  const SlotDurationSelector({
    super.key,
    required this.controller,
    required this.slotId,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selection = controller.selectionFor(slotId);
    final items = List.generate(12, (i) {
      final months = i + 1;
      return DropdownMenuItem<int>(
        value: months,
        child: Text(
          BookingConfirmationController.monthLabel(months),
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
      );
    });

    return Obx(
      () => AppDropdown<int>(
        value: selection.durationMonths.value,
        items: items,
        onChanged: (months) {
          if (months != null) {
            controller.selectDurationForSlot(slotId, months);
          }
        },
      ),
    );
  }
}
