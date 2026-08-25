import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/core/widgets/widgets.dart';

import '../../../core/utils/theme_extensions.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import '../controllers/payment_method_controller.dart';
import '../../../core/widgets/add_card_bottom_sheet.dart';
import 'payment_card_detail_view.dart';
import 'payment_transactions_view.dart';
import 'widgets/empty_states.dart';
import 'widgets/payment_card.dart';
import 'widgets/transaction_tile.dart';

class PaymentMethodView extends GetView<PaymentMethodController> {
  const PaymentMethodView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      floatingActionButton: AnimatedBuilder(
        animation: controller.bounceController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, controller.bounceOffset.value),
            child: child,
          );
        },
        child: FloatingActionButton.extended(
          onPressed: () => _openAddCardSheet(context),
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 8,
          icon: const Icon(Icons.add_card_rounded),
          label: const Text('Add Card'),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            floating: false,
            pinned: true,
            backgroundColor: context.backgroundColor,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              onPressed: () => Get.back(),
              icon: Icon(
                Icons.arrow_back_ios_new_rounded,
                color: context.primaryTextColor,
                size: 22,
              ),
            ),
            title: Text(
              'Payment Method',
              style: AppTypography.h3.copyWith(color: context.primaryTextColor),
            ),
            centerTitle: true,
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.md,
              0,
              0,
            ),
            sliver: SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Cards',
                    style: AppTypography.h2.copyWith(
                      color: context.primaryTextColor,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    'Manage saved payment methods and track recent activity.',
                    style: AppTypography.bodyMedium.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),
                  Obx(() {
                    if (controller.isLoadingCards.value) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.xl),
                          child: LoadingWidget(),
                        ),
                      );
                    }
                    if (controller.cards.isEmpty) {
                      return EmptyCards(
                        secondaryTextColor: context.secondaryTextColor,
                        surfaceColor: context.surfaceColor,
                        isDark: isDark,
                      );
                    }
                    return Column(
                      children: [
                        SizedBox(
                          height: 212,
                          child: PageView.builder(
                            controller: controller.pageController,
                            itemCount: controller.cards.length,
                            physics: const BouncingScrollPhysics(),
                            onPageChanged: controller.onCardPageChanged,
                            itemBuilder: (context, index) {
                              final card = controller.cards[index];
                              return Padding(
                                padding: const EdgeInsets.only(
                                  right: AppSpacing.md,
                                ),
                                child: PaymentCard(
                                  card: card,
                                  index: index,
                                  onTap: () => Get.to(
                                    () => PaymentCardDetailView(
                                      cardId: card.id,
                                      index: index,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: List.generate(
                              controller.cards.length,
                              (index) => AnimatedContainer(
                                duration: const Duration(milliseconds: 250),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xs,
                                ),
                                width: controller.currentCardIndex == index
                                    ? 20
                                    : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: controller.currentCardIndex == index
                                      ? AppColors.primary
                                      : context.secondaryTextColor.withValues(
                                          alpha: 0.35,
                                        ),
                                  borderRadius: AppRadius.pillRadius,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                  SizedBox(height: AppSpacing.xl),
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.lg),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppSpacing.lg),
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Obx(
                            () => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Recent Transactions',
                                  style: AppTypography.h3.copyWith(
                                    color: context.primaryTextColor,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(
                                      alpha: 0.16,
                                    ),
                                    borderRadius: AppRadius.pillRadius,
                                  ),
                                  child: Text(
                                    '${controller.transactions.length} items',
                                    style: AppTypography.bodySmallSemiBold
                                        .copyWith(color: AppColors.primaryDark),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: AppSpacing.md),
                          Obx(() {
                            if (controller.isLoadingTransactions.value) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(
                                  vertical: AppSpacing.xl,
                                ),
                                child: Center(child: LoadingWidget()),
                              );
                            }

                            if (controller.transactions.isEmpty) {
                              return EmptyTransactions(
                                textColor: context.primaryTextColor,
                              );
                            }

                            return Column(
                              children: [
                                ...controller.recentTransactions.map(
                                  (transaction) => Padding(
                                    padding: const EdgeInsets.only(
                                      bottom: AppSpacing.md,
                                    ),
                                    child: TransactionTile(
                                      transaction: transaction,
                                      textColor: context.primaryTextColor,
                                      secondaryTextColor:
                                          context.secondaryTextColor,
                                      isDark: isDark,
                                    ),
                                  ),
                                ),
                                if (controller.hasMoreTransactions)
                                  SizedBox(
                                    width: double.infinity,
                                    child: AppButton.secondary(
                                      label: 'Show All',
                                      onPressed: () => Get.to(
                                        () => const PaymentTransactionsView(),
                                      ),
                                      useGlow: false,
                                      backgroundColor: AppColors.secondary,
                                      textColor: Colors.white,
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 120),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openAddCardSheet(BuildContext context) {
    controller.resetAddCardForm();
    showAddCardBottomSheet(
      cardholderNameController: controller.cardholderNameController,
      cardEditController: controller.cardEditController,
      isCardComplete: controller.isCardCompleteRx,
      isSubmitting: controller.isSubmittingRx,
      onCardChanged: controller.onCardChanged,
      onSubmit: controller.submitAddCard,
    );
  }
}
