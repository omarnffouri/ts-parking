import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/loading_widget.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../controllers/overstay_charges_controller.dart';
import 'widgets/overstay_charge_card.dart';
import 'widgets/pay_charge_bottom_sheet.dart';

class OverstayChargesView extends GetView<OverstayChargesController> {
  const OverstayChargesView({super.key});

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
                    'Overstay Charges',
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

                if (controller.charges.isEmpty) {
                  return const EmptyState(
                    icon: Icons.timer_off_outlined,
                    title: 'No Overstay Charges',
                    message:
                        'Charges for exceeding your subscription period will appear here.',
                  );
                }

                return RefreshIndicator(
                  onRefresh: controller.loadCharges,
                  child: ListView.builder(
                    controller: controller.scrollController,
                    padding: EdgeInsets.only(
                      left: AppSpacing.screenHorizontal,
                      right: AppSpacing.screenHorizontal,
                      top: AppSpacing.md,
                      bottom: AppSpacing.xxl + AppSpacing.xxl,
                    ),
                    itemCount: controller.charges.length + 1,
                    itemBuilder: (context, index) {
                      if (index == controller.charges.length) {
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
                      final charge = controller.charges[index];
                      return OverstayChargeCard(
                        charge: charge,
                        onTap: charge.isUnpaid
                            ? () => showPayChargeBottomSheet(
                                charge: charge,
                                controller: controller,
                              )
                            : null,
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
