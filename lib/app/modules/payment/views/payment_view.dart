import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/theme_extensions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../../../domain/params/pay_invoice_params.dart';
import '../controllers/payment_controller.dart';
import 'widgets/card_selector.dart';
import 'widgets/payment_method_option.dart';
import '../../../core/widgets/invoice_summary_card.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

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
          'Payment',
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
                  InvoiceSummaryCard(
                    invoice: controller.invoice,
                    yardName: controller.yardName,
                    isDark: isDark,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Payment method',
                    style: AppTypography.bodyLargeSemiBold.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.ms),
                  Obx(
                    () => Row(
                      children: [
                        Expanded(
                          child: PaymentMethodOption(
                            label: 'Card',
                            icon: Icons.credit_card_rounded,
                            isSelected:
                                controller.paymentMethod.value ==
                                PayInvoiceParams.methodCard,
                            onTap: () => controller.selectPaymentMethod(
                              PayInvoiceParams.methodCard,
                            ),
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.ms),
                        Expanded(
                          child: PaymentMethodOption(
                            label: 'Cash',
                            icon: Icons.payments_outlined,
                            isSelected:
                                controller.paymentMethod.value ==
                                PayInvoiceParams.methodCash,
                            onTap: () => controller.selectPaymentMethod(
                              PayInvoiceParams.methodCash,
                            ),
                            isDark: isDark,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Obx(() {
                    if (controller.isCash) {
                      return Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.md),
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
                            const SizedBox(width: AppSpacing.sm),
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
                    return CardSelector(controller: controller, isDark: isDark);
                  }),
                ],
              ),
            ),
          ),
          _PaymentBottomBar(controller: controller, isDark: isDark),
        ],
      ),
    );
  }
}

class _PaymentBottomBar extends StatelessWidget {
  final PaymentController controller;
  final bool isDark;

  const _PaymentBottomBar({required this.controller, required this.isDark});

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
        final canPay = controller.canPay;
        final isPaying = controller.isPaying;

        return SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: canPay ? controller.onPay : null,
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
                    'Pay \$${controller.invoice.total.toStringAsFixed(2)}',
                    style: AppTypography.buttonMedium,
                  ),
          ),
        );
      }),
    );
  }
}
