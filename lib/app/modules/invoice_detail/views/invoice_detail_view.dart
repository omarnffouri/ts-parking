import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/theme_extensions.dart';
import '../../../core/widgets/invoice_summary_card.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../controllers/invoice_detail_controller.dart';
import 'widgets/invoice_header.dart';
import 'widgets/overstay_item_card.dart';
import 'widgets/subscription_card.dart';

class InvoiceDetailView extends GetView<InvoiceDetailController> {
  const InvoiceDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
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
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: Get.back,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Invoice Details',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: AppRadius.xlargeTopRadius,
              ),
              child: Obx(() {
                if (controller.isLoading) {
                  return Center(child: LoadingWidget(size: 40));
                }

                final invoice = controller.invoice;
                if (invoice == null) {
                  return Center(
                    child: Text(
                      'Invoice not found',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  );
                }

                final isDark = context.isDark;

                return Column(
                  children: [
                    Expanded(
                      child: RefreshIndicator(
                        onRefresh: controller.loadInvoice,
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          padding: EdgeInsets.all(AppSpacing.screenHorizontal),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: AppSpacing.sm),
                              InvoiceHeader(
                                invoiceNumber: invoice.invoiceNumber,
                                issuedAt: invoice.issuedAt,
                                status: invoice.status,
                                isDark: isDark,
                              ),
                              SizedBox(height: AppSpacing.md),
                              if (invoice.isOverstay)
                                ...invoice.overstays.map(
                                  (item) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: AppSpacing.md,
                                    ),
                                    child: OverstayItemCard(overstay: item),
                                  ),
                                )
                              else
                                ...invoice.subscriptions.map(
                                  (sub) => Padding(
                                    padding: EdgeInsets.only(
                                      bottom: AppSpacing.md,
                                    ),
                                    child: SubscriptionCard(
                                      subscription: sub,
                                      isDark: isDark,
                                      isDeleting: controller.isDeleting(sub.id),
                                      onDelete: controller.canPay
                                          ? () => controller
                                                .confirmDeleteSubscription(sub)
                                          : null,
                                    ),
                                  ),
                                ),
                              InvoiceSummaryCard(
                                invoice: invoice,
                                totalLabel: 'Grand Total',
                                isDark: isDark,
                              ),
                              if (controller.hasPdf) ...[
                                SizedBox(height: AppSpacing.md),
                                AppButton.primary(
                                  useGlow: false,
                                  label: 'View Invoice PDF',
                                  onPressed: controller.onViewPdf,
                                  icon: Icons.picture_as_pdf_rounded,
                                  fullWidth: true,
                                  textColor: AppColors.darkTextPrimary,
                                  backgroundColor: AppColors.secondaryDark,
                                ),
                              ],
                              SizedBox(height: AppSpacing.xxl),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (controller.canPay)
                      Container(
                        padding: EdgeInsets.fromLTRB(
                          AppSpacing.screenHorizontal,
                          AppSpacing.sm,
                          AppSpacing.screenHorizontal,
                          AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.lightBorder,
                            ),
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.onConfirmAndPay,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.accent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: AppRadius.mediumRadius,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: AppSpacing.md,
                                ),
                              ),
                              child: Text(
                                'Confirm & Pay',
                                style: AppTypography.buttonMedium.copyWith(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
