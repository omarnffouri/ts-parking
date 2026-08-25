import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/theme_extensions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../controllers/booking_confirmation_controller.dart';
import 'widgets/booking_bottom_bar.dart';
import 'widgets/slot_card.dart';
import 'widgets/summary_card.dart';

class BookingConfirmationView extends GetView<BookingConfirmationController> {
  const BookingConfirmationView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        title: Text(
          'Confirm Booking',
          style: AppTypography.h3.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back,
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SummaryCard(controller: controller, isDark: isDark),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    'Configure each slot',
                    style: AppTypography.bodyMedium.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.ms),
                  ...List.generate(
                    controller.selectedSlots.length,
                    (index) => Obx(
                      () => SlotCard(
                        controller: controller,
                        slotIndex: index,
                        isExpanded: controller.expandedSlotIndex.value == index,
                        isDark: isDark,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          BookingBottomBar(controller: controller, isDark: isDark),
        ],
      ),
    );
  }
}
