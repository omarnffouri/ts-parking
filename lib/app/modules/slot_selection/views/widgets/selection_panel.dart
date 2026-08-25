import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../core/utils/string_extensions.dart';
import '../../../../core/utils/theme_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../domain/entities/slot_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/slot_selection_controller.dart';

class SelectionPanel extends StatelessWidget {
  const SelectionPanel({super.key, required this.controller});

  final SlotSelectionController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.hasSelection) {
        return Container(
          key: const ValueKey('slot_selection_hint'),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.ms,
          ),
          decoration: BoxDecoration(
            color: context.panelColor,
            borderRadius: AppRadius.largeRadius,
            border: Border.all(color: context.panelBorderColor),
          ),
          child: Text(
            'Select a slot to review details and book.',
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        );
      }

      final selected = controller.selectedSlots;
      final primary = controller.primarySelectedSlot!;
      final isMulti = selected.length > 1;
      final total = controller.selectedTotalPrice;
      final ctaLabel = isMulti
          ? 'Book ${selected.length} Slots - ${total.toPrice()}'
          : 'Book ${primary.slotCode} - ${primary.price.toPrice()}';

      return Column(
        children: [
          _SelectionSummaryCard(
            controller: controller,
            selectedSlots: selected,
            primarySlot: primary,
          ),
          const SizedBox(height: AppSpacing.md),
          AppButton.primary(
            label: ctaLabel,
            onPressed: controller.onContinue,
            backgroundColor: AppColors.primary,
            textColor: AppColors.lightTextPrimary,
            borderRadius: BorderRadius.circular(18),
            useGlow: false,
          ),
        ],
      );
    });
  }
}

class _SelectionSummaryCard extends StatelessWidget {
  const _SelectionSummaryCard({
    required this.controller,
    required this.selectedSlots,
    required this.primarySlot,
  });

  final SlotSelectionController controller;
  final List<SlotEntity> selectedSlots;
  final SlotEntity primarySlot;

  @override
  Widget build(BuildContext context) {
    final isMulti = selectedSlots.length > 1;
    final title = isMulti
        ? '${selectedSlots.length} Slots Selected'
        : 'Slot ${primarySlot.slotCode}';
    final subtitle = isMulti
        ? '${primarySlot.slotCode} +${selectedSlots.length - 1} more'
        : primarySlot.zoneName;
    final trailingLabel = isMulti ? 'total' : primarySlot.planName;
    final price = isMulti ? controller.selectedTotalPrice : primarySlot.price;

    return Container(
      key: const ValueKey('selection_summary_card'),
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.panelColor,
        borderRadius: AppRadius.largeRadius,
        border: Border.all(color: context.panelBorderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: context.isDark ? 0.18 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SlotBadge(
            code: isMulti ? '${selectedSlots.length}' : primarySlot.slotCode,
            isHighlighted: true,
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: AppTypography.bodyLargeSemiBold.copyWith(
                              color: context.primaryTextColor,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            subtitle,
                            style: AppTypography.bodyMedium.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          price.toPrice(),
                          style: AppTypography.h3.copyWith(
                            color: context.primaryTextColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          trailingLabel,
                          style: AppTypography.bodySmall.copyWith(
                            color: context.secondaryTextColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.ms),
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.sm,
                  children: [
                    if (primarySlot.planName.isNotEmpty)
                      _DetailChip(
                        icon: Icons.straighten_rounded,
                        label: primarySlot.planName,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlotBadge extends StatelessWidget {
  const _SlotBadge({required this.code, required this.isHighlighted});

  final String code;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isHighlighted
            ? AppColors.success.withValues(alpha: 0.08)
            : context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isHighlighted
              ? AppColors.success.withValues(alpha: 0.8)
              : context.panelBorderColor,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            code,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMediumSemiBold.copyWith(
              color: context.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: context.surfaceVariantColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: context.panelBorderColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: context.secondaryTextColor),
          const SizedBox(width: AppSpacing.xs),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: context.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}
