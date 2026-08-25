import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/date_utils.dart';
import '../../../core/widgets/accent_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../domain/entities/subscription_entity.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../controllers/subscriptions_controller.dart';

class SubscriptionsView extends GetView<SubscriptionsController> {
  const SubscriptionsView({super.key});

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
                    'Subscriptions',
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

                if (controller.subscriptions.isEmpty) {
                  return const EmptyState(
                    icon: Icons.autorenew_rounded,
                    title: 'No Subscriptions Yet',
                    message:
                        'Your active and past subscriptions will appear here.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadSubscriptions,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.only(
                      left: AppSpacing.screenHorizontal,
                      right: AppSpacing.screenHorizontal,
                      top: AppSpacing.md,
                      bottom: AppSpacing.xxl + AppSpacing.xxl,
                    ),
                    itemCount: controller.subscriptions.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.subscriptions.length) {
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
                      return _SubscriptionCard(
                        subscription: controller.subscriptions[index],
                      );
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

class _SubscriptionCard extends StatelessWidget {
  final SubscriptionEntity subscription;

  const _SubscriptionCard({required this.subscription});

  String _formatPlanType(String? type) {
    if (type == null) return 'Standard';
    if (type.toLowerCase() == 'vip') return 'VIP';
    return 'Standard';
  }

  String _formatDate(DateTime? date) =>
      DateTimeUtils.formatDisplayDateOrDash(date);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isVip = subscription.subscriptionType?.toLowerCase() == 'vip';
    final isCancelled = subscription.status == 'cancelled';

    return AccentCard(
      accentColor: AppColors.getStatusColor(subscription.status),
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
                    color: isVip
                        ? AppColors.primary.withValues(alpha: 0.15)
                        : AppColors.secondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.small),
                  ),
                  child: Text(
                    _formatPlanType(subscription.subscriptionType),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: isVip ? AppColors.primary : AppColors.secondary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                StatusBadge.small(status: subscription.status),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.local_parking_rounded,
                      size: 18,
                      color: theme.hintColor,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      'Slot: ${subscription.slotCode ?? 'N/A'}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                Text(
                  '\$${subscription.totalAmount.toStringAsFixed(2)}/${subscription.billingCycle}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.secondaryDark,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Ref: ${subscription.subscriptionRef}',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.hintColor,
              ),
            ),
            SizedBox(height: AppSpacing.xs),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isCancelled
                      ? 'Cancelled: ${_formatDate(subscription.cancelledAt)}'
                      : 'Next billing: ${_formatDate(subscription.nextBillingDate)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isCancelled ? AppColors.error : theme.hintColor,
                  ),
                ),
                Row(
                  children: [
                    Icon(
                      subscription.autoRenew
                          ? Icons.autorenew_rounded
                          : Icons.block_rounded,
                      size: 14,
                      color: theme.hintColor,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      subscription.autoRenew ? 'Auto-renew' : 'No renewal',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.hintColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
