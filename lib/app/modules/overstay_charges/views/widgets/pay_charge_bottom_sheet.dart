import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../core/utils/theme_extensions.dart';
import '../../../../domain/entities/vehicle_charge_entity.dart';
import '../../../../domain/params/pay_overstay_charge_params.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../../payment/views/widgets/payment_method_option.dart';
import '../../controllers/overstay_charges_controller.dart';

void showPayChargeBottomSheet({
  required VehicleChargeEntity charge,
  required OverstayChargesController controller,
}) {
  Get.bottomSheet(
    _PayChargeSheet(charge: charge, controller: controller),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class _PayChargeSheet extends StatelessWidget {
  final VehicleChargeEntity charge;
  final OverstayChargesController controller;

  const _PayChargeSheet({required this.charge, required this.controller});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: context.panelColor,
        borderRadius: AppRadius.xlargeTopRadius,
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.lg,
        bottom: bottomPadding + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.panelBorderColor,
                borderRadius: AppRadius.pillRadius,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Pay Overstay Charge',
                style: AppTypography.h3.copyWith(
                  color: context.primaryTextColor,
                ),
              ),
              Text(
                '\$${charge.amount.toStringAsFixed(2)}',
                style: AppTypography.h3.copyWith(
                  color: AppColors.error,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            '${charge.licensePlate ?? 'Vehicle'} \u2022 ${charge.subscriptionRef ?? ''}',
            style: AppTypography.bodySmall.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            'Payment method',
            style: AppTypography.bodyMediumSemiBold.copyWith(
              color: context.primaryTextColor,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: PaymentMethodOption(
                    label: 'Card',
                    icon: Icons.credit_card_rounded,
                    isSelected:
                        controller.paymentMethod.value ==
                        PayOverstayChargeParams.methodCard,
                    onTap: () => controller.selectPaymentMethod(
                      PayOverstayChargeParams.methodCard,
                    ),
                    isDark: isDark,
                  ),
                ),
                SizedBox(width: AppSpacing.ms),
                Expanded(
                  child: PaymentMethodOption(
                    label: 'Cash',
                    icon: Icons.payments_outlined,
                    isSelected:
                        controller.paymentMethod.value ==
                        PayOverstayChargeParams.methodCash,
                    onTap: () => controller.selectPaymentMethod(
                      PayOverstayChargeParams.methodCash,
                    ),
                    isDark: isDark,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Obx(() {
            if (controller.isCash) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.ms),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.08),
                  borderRadius: AppRadius.mediumRadius,
                  border: Border.all(
                    color: AppColors.success.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline_rounded,
                      color: AppColors.success,
                      size: 20,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        'You will pay in cash at the parking location',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            if (controller.isLoadingCards) {
              return const Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (controller.cards.isEmpty) {
              return _EmptyCards(controller: controller);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...controller.cards.map(
                  (card) => _CardTile(
                    brand: card.brand,
                    last4: card.last4,
                    expiry: card.expiry,
                    isSelected: controller.selectedCardId.value == card.id,
                    onTap: () => controller.selectCard(card.id),
                  ),
                ),
                GestureDetector(
                  onTap: controller.openAddCardSheet,
                  child: Row(
                    children: [
                      Icon(
                        Icons.add_circle_outline_rounded,
                        size: 18,
                        color: AppColors.accent,
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        'Add new card',
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
          SizedBox(height: AppSpacing.lg),
          Obx(() {
            final canPay = controller.canPay;
            final isPaying = controller.isPaying;

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canPay
                    ? () {
                        Get.back();
                        controller.payCharge(charge);
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: isDark
                      ? AppColors.darkSurfaceVariant
                      : AppColors.lightBorder,
                  disabledForegroundColor: isDark
                      ? AppColors.darkTextTertiary
                      : AppColors.lightTextTertiary,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.mediumRadius,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.ms),
                ),
                child: isPaying
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        'Pay \$${charge.amount.toStringAsFixed(2)}',
                        style: AppTypography.buttonMedium,
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CardTile extends StatelessWidget {
  final String brand;
  final String last4;
  final String expiry;
  final bool isSelected;
  final VoidCallback onTap;

  const _CardTile({
    required this.brand,
    required this.last4,
    required this.expiry,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.ms),
        decoration: BoxDecoration(
          color: context.isDark
              ? AppColors.darkBackground
              : AppColors.lightSurfaceVariant,
          borderRadius: AppRadius.mediumRadius,
          border: Border.all(
            color: isSelected ? AppColors.accent : context.panelBorderColor,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.credit_card_rounded,
              size: 24,
              color: isSelected ? AppColors.accent : context.secondaryTextColor,
            ),
            SizedBox(width: AppSpacing.ms),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${brand.toUpperCase()} **** $last4',
                    style: AppTypography.bodySmallSemiBold.copyWith(
                      color: context.primaryTextColor,
                    ),
                  ),
                  Text(
                    'Expires $expiry',
                    style: AppTypography.overline.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: AppColors.accent,
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCards extends StatelessWidget {
  final OverstayChargesController controller;

  const _EmptyCards({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: context.isDark
            ? AppColors.darkBackground
            : AppColors.lightSurfaceVariant,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.credit_card_off_rounded,
            size: 36,
            color: context.isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary,
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            'No saved cards',
            style: AppTypography.bodyMediumSemiBold.copyWith(
              color: context.primaryTextColor,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Add a card to complete your payment',
            style: AppTypography.bodySmall.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          SizedBox(height: AppSpacing.ms),
          ElevatedButton.icon(
            onPressed: controller.openAddCardSheet,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Card'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.mediumRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
