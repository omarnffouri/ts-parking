import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/theme_extensions.dart';
import '../../../domain/entities/slot_entity.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../controllers/booking_confirmation_controller.dart';

class BookingSummaryView extends GetView<BookingConfirmationController> {
  const BookingSummaryView({super.key});

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
          'Booking Summary',
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
                  // Yard info
                  _YardHeader(controller: controller, isDark: isDark),
                  const SizedBox(height: AppSpacing.md),

                  // Slots
                  Text(
                    '${controller.slotCount} ${controller.slotCount == 1 ? 'Slot' : 'Slots'}',
                    style: AppTypography.bodySmallSemiBold.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...controller.selectedSlots.map(
                    (slot) => _SlotSummaryCard(
                      controller: controller,
                      slot: slot,
                      isDark: isDark,
                    ),
                  ),

                  const SizedBox(height: AppSpacing.md),

                  // Total
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: isDark
                          ? AppColors.darkSurface
                          : AppColors.lightSurface,
                      borderRadius: AppRadius.mediumRadius,
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: Obx(
                      () => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Grand Total',
                            style: AppTypography.bodyLargeSemiBold.copyWith(
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary,
                            ),
                          ),
                          Text(
                            '\$${controller.grandTotal.toStringAsFixed(0)}',
                            style: AppTypography.h2.copyWith(
                              color: AppColors.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Bottom bar
          _ConfirmBar(controller: controller, isDark: isDark),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Yard Header
// ---------------------------------------------------------------------------

class _YardHeader extends StatelessWidget {
  final BookingConfirmationController controller;
  final bool isDark;

  const _YardHeader({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.mediumRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.yardName,
            style: AppTypography.bodyLargeSemiBold.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          if (controller.yardAddress.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              controller.yardAddress,
              style: AppTypography.overline.copyWith(
                color: isDark
                    ? AppColors.darkTextTertiary
                    : AppColors.lightTextTertiary,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Text(
            controller.zone.name,
            style: AppTypography.bodySmall.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Slot Summary Card
// ---------------------------------------------------------------------------

class _SlotSummaryCard extends StatelessWidget {
  final BookingConfirmationController controller;
  final SlotEntity slot;
  final bool isDark;

  const _SlotSummaryCard({
    required this.controller,
    required this.slot,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final selection = controller.selectionFor(slot.id);
    final vehicle = controller.vehicleForSlot(slot.id);

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Slot code + plan
          Row(
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
              const SizedBox(width: AppSpacing.sm),
              if (slot.isVip)
                Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Icon(
                    Icons.star_rounded,
                    size: 14,
                    color: AppColors.accent,
                  ),
                ),
              Text(
                slot.planName.toUpperCase(),
                style: AppTypography.bodySmallSemiBold.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const Spacer(),
              Obx(
                () => Text(
                  '\$${controller.totalPriceForSlot(slot.id).toStringAsFixed(0)}',
                  style: AppTypography.bodyLargeSemiBold.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.ms),
          Divider(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            height: 1,
          ),
          const SizedBox(height: AppSpacing.ms),

          // Details rows
          _DetailRow(
            icon: Icons.local_shipping_rounded,
            label: vehicle?.licensePlate ?? '—',
            value: vehicle?.licensePlate ?? '',
            isDark: isDark,
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(
            () => _DetailRow(
              icon: Icons.calendar_today_rounded,
              label: controller.formattedStartDateForSlot(slot.id),
              value: 'to ${controller.formattedEndDateForSlot(slot.id)}',
              isDark: isDark,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(
            () => _DetailRow(
              icon: Icons.schedule_rounded,
              label: controller.durationLabelForSlot(slot.id),
              value: selection.autoRenew.value ? 'Auto-renew' : '',
              isDark: isDark,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Obx(
            () => _DetailRow(
              icon: Icons.attach_money_rounded,
              label: slot.hasDiscount
                  ? '\$${slot.priceBeforeDiscount.toStringAsFixed(0)}/mo'
                  : '\$${slot.price.toStringAsFixed(0)}/mo',
              value: '× ${controller.monthsForSlot(slot.id)}',
              isDark: isDark,
              labelDecoration: slot.hasDiscount
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          if (slot.hasDiscount) ...[
            const SizedBox(height: AppSpacing.sm),
            _DetailRow(
              icon: Icons.discount_outlined,
              label: '-\$${slot.discount.toStringAsFixed(0)}/mo discount',
              value: '\$${slot.price.toStringAsFixed(0)}/mo',
              isDark: isDark,
              valueColor: AppColors.success,
            ),
          ],
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Detail Row
// ---------------------------------------------------------------------------

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isDark;
  final TextDecoration? labelDecoration;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.isDark,
    this.labelDecoration,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: isDark
              ? AppColors.darkTextTertiary
              : AppColors.lightTextTertiary,
        ),
        const SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            color: isDark
                ? AppColors.darkTextPrimary
                : AppColors.lightTextPrimary,
            decoration: labelDecoration,
          ),
        ),
        if (value.isNotEmpty) ...[
          const Spacer(),
          Text(
            value,
            style: AppTypography.overline.copyWith(
              color:
                  valueColor ??
                  (isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary),
            ),
          ),
        ],
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Confirm Bar
// ---------------------------------------------------------------------------

class _ConfirmBar extends StatelessWidget {
  final BookingConfirmationController controller;
  final bool isDark;

  const _ConfirmBar({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: bottomPadding + AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
      ),
      child: Obx(() {
        final isSubmitting = controller.isSubmitting;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isSubmitting ? null : controller.onConfirm,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: isDark
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightBorder,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.mediumRadius,
              ),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            ),
            child: isSubmitting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Confirm & Pay',
                    style: AppTypography.buttonMedium.copyWith(
                      color: Colors.white,
                    ),
                  ),
          ),
        );
      }),
    );
  }
}
