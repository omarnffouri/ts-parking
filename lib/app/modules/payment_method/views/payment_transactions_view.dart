import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/core/widgets/widgets.dart';

import '../../../core/utils/theme_extensions.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../controllers/payment_method_controller.dart';
import 'widgets/empty_states.dart';
import 'widgets/transaction_tile.dart';

class PaymentTransactionsView extends GetView<PaymentMethodController> {
  const PaymentTransactionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: context.backgroundColor,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.primaryTextColor,
            size: 22,
          ),
        ),
        title: Text(
          'All Transactions',
          style: AppTypography.h3.copyWith(color: context.primaryTextColor),
        ),
      ),
      body: Obx(() {
        if (controller.isLoadingTransactions.value) {
          return const Center(child: LoadingWidget());
        }

        if (controller.transactions.isEmpty) {
          return Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: EmptyTransactions(textColor: context.primaryTextColor),
          );
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.md,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: context.surfaceColor,
              borderRadius: AppRadius.xlargeRadius,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.lg),
              physics: const BouncingScrollPhysics(),
              itemCount: controller.transactions.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.md),
              itemBuilder: (context, index) {
                final transaction = controller.transactions[index];
                return TransactionTile(
                  transaction: transaction,
                  textColor: context.primaryTextColor,
                  secondaryTextColor: context.secondaryTextColor,
                  isDark: isDark,
                );
              },
            ),
          ),
        );
      }),
    );
  }
}
