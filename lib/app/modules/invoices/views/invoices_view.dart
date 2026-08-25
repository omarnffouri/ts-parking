import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/accent_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/entities/invoice_entity.dart';
import '../../../routes/app_pages.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../controllers/invoices_controller.dart';

class InvoicesView extends GetView<InvoicesController> {
  const InvoicesView({super.key});

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
                    'Invoices',
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

                if (controller.invoices.isEmpty) {
                  return const EmptyState(
                    icon: Icons.receipt_long_outlined,
                    title: 'No Invoices Yet',
                    message:
                        'Your invoices will appear here after you subscribe.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadInvoices,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.only(
                      left: AppSpacing.screenHorizontal,
                      right: AppSpacing.screenHorizontal,
                      top: AppSpacing.md,
                      bottom: AppSpacing.xxl + AppSpacing.xxl,
                    ),
                    itemCount: controller.invoices.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.invoices.length) {
                        return Obx(() {
                          if (!controller.isLoadingMore &&
                              !controller.hasMore) {
                            return const SizedBox.shrink();
                          }
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: AppSpacing.lg,
                            ),
                            child: Center(child: LoadingWidget(size: 28)),
                          );
                        });
                      }
                      return _InvoiceCard(invoice: controller.invoices[index]);
                    },
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _InvoiceCard extends StatelessWidget {
  final InvoiceEntity invoice;

  const _InvoiceCard({required this.invoice});

  String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return DateTimeUtils.formatDisplayDate(date);
  }

  String _formatType(String type) {
    return type
        .split('_')
        .map(
          (word) => word.isEmpty
              ? ''
              : word[0].toUpperCase() + word.substring(1).toLowerCase(),
        )
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasDiscount = invoice.discountAmount > 0;

    return GestureDetector(
      onTap: () => Get.toNamed(Routes.INVOICE_DETAIL, arguments: invoice.id),
      child: AccentCard(
        accentColor: AppColors.getStatusColor(invoice.status),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (invoice.isOverstay
                                  ? AppColors.error
                                  : AppColors.secondary)
                              .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: Text(
                      _formatType(invoice.invoiceType),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: invoice.isOverstay
                            ? AppColors.error
                            : AppColors.secondary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  StatusBadge.small(status: invoice.status),
                ],
              ),
              SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.receipt_outlined,
                        size: 18,
                        color: theme.hintColor,
                      ),
                      SizedBox(width: AppSpacing.xs),
                      Text(
                        invoice.invoiceNumber,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '\$${invoice.total.toStringAsFixed(2)}',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.secondaryDark,
                    ),
                  ),
                ],
              ),
              if (hasDiscount) ...[
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      'Subtotal: \$${invoice.subtotal.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      '-\$${invoice.discountAmount.toStringAsFixed(2)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: AppSpacing.xs),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Issued: ${_formatDate(invoice.issuedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.hintColor,
                    ),
                  ),
                  if (invoice.paidAt != null)
                    Text(
                      'Paid: ${_formatDate(invoice.paidAt)}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.success,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
