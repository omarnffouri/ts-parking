import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';

import '../../../../core/widgets/loading_widget.dart';
import '../../../../domain/entities/plan_service_entity.dart';
import '../../../../domain/entities/pricing_plan_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/slot_selection_controller.dart';

void showPricingPlansSheet(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;
  final controller = Get.find<SlotSelectionController>();
  controller.loadPricingPlans();

  Get.bottomSheet(
    PricingPlansSheet(controller: controller, isDark: isDark),
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
  );
}

class PricingPlansSheet extends StatelessWidget {
  final SlotSelectionController controller;
  final bool isDark;

  const PricingPlansSheet({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      decoration: BoxDecoration(
        color: context.backgroundColor,
        borderRadius: AppRadius.xlargeTopRadius,
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.sm,
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
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                borderRadius: AppRadius.pillRadius,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Plans',
                style: AppTypography.h3.copyWith(
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              GestureDetector(
                onTap: Get.back,
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurfaceVariant
                        : AppColors.lightSurfaceVariant,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Compare plans and pick the best one for you',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          Divider(
            height: AppSpacing.lg,
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
          Flexible(
            child: Obx(() {
              if (controller.isLoadingPlans) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                  child: Center(child: LoadingWidget(size: 32)),
                );
              }

              if (controller.pricingPlans.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxl),
                  child: Center(
                    child: Text(
                      'No plans available',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: controller.pricingPlans.length,
                itemBuilder: (context, index) => _PlanCard(
                  plan: controller.pricingPlans[index],
                  isDark: isDark,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  final PricingPlanEntity plan;
  final bool isDark;

  const _PlanCard({required this.plan, required this.isDark});

  String get _displayName {
    final name = plan.name.trim();
    if (name.isEmpty) return 'Plan';
    if (name.toLowerCase() == 'vip') return 'VIP';
    return name[0].toUpperCase() + name.substring(1).toLowerCase();
  }

  bool get _isVip => plan.name.toLowerCase() == 'vip';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: AppSpacing.ms),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (_isVip)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Icon(
                    Icons.star_rounded,
                    size: 18,
                    color: AppColors.accent,
                  ),
                ),
              Expanded(
                child: Text(
                  _displayName,
                  style: AppTypography.bodyLargeSemiBold.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
              ),
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
                  '\$${plan.price.toStringAsFixed(0)}/mo',
                  style: AppTypography.bodySmallSemiBold.copyWith(
                    color: AppColors.accent,
                  ),
                ),
              ),
            ],
          ),
          if (plan.description.isNotEmpty && plan.description != 'null') ...[
            const SizedBox(height: AppSpacing.xs),
            Text(
              plan.description,
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
          ],
          if (plan.attributes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.ms),
            ...plan.attributes.map(
              (service) => _ServiceRow(service: service, isDark: isDark),
            ),
          ],
        ],
      ),
    );
  }
}

class _ServiceRow extends StatelessWidget {
  final PlanServiceEntity service;
  final bool isDark;

  const _ServiceRow({required this.service, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Row(
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              service.name,
              style: AppTypography.bodySmall.copyWith(
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.lightTextPrimary,
              ),
            ),
          ),
          if (service.price > 0)
            Text(
              '+\$${service.price.toStringAsFixed(0)}',
              style: AppTypography.overline.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
        ],
      ),
    );
  }
}
