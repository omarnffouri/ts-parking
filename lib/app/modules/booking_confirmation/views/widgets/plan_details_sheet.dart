import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';

import '../../../../domain/entities/pricing_plan_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

void showPlanDetailsSheet(BuildContext context, PricingPlanEntity plan) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  Get.bottomSheet(
    PlanDetailsSheet(plan: plan, isDark: isDark),
    backgroundColor: Colors.transparent,
  );
}

class PlanDetailsSheet extends StatelessWidget {
  final PricingPlanEntity plan;
  final bool isDark;

  const PlanDetailsSheet({super.key, required this.plan, required this.isDark});

  bool get _isVip => plan.name.toLowerCase() == 'vip';

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
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
          // Handle
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

          // Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.accent.withValues(alpha: 0.15),
                  AppColors.accent.withValues(alpha: 0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.mediumRadius,
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    if (_isVip)
                      Padding(
                        padding: const EdgeInsets.only(right: AppSpacing.xs),
                        child: Icon(
                          Icons.star_rounded,
                          size: 20,
                          color: AppColors.accent,
                        ),
                      ),
                    Text(
                      plan.name.toUpperCase(),
                      style: AppTypography.h3.copyWith(
                        color: isDark
                            ? AppColors.darkTextPrimary
                            : AppColors.lightTextPrimary,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${plan.price.toStringAsFixed(0)}',
                      style: AppTypography.h2.copyWith(color: AppColors.accent),
                    ),
                    Text(
                      '/mo',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.accent.withValues(alpha: 0.7),
                      ),
                    ),
                  ],
                ),
                if (plan.description.isNotEmpty &&
                    plan.description != 'null') ...[
                  const SizedBox(height: 4),
                  Text(
                    plan.description,
                    style: AppTypography.bodySmall.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Services
          if (plan.attributes.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.md),
            Text(
              "What's included",
              style: AppTypography.bodySmallSemiBold.copyWith(
                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            ...plan.attributes.map(
              (service) => Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.ms),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle_outlined,
                      size: 18,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        service.name,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary,
                        ),
                      ),
                    ),
                    Text(
                      service.price > 0
                          ? '\$${service.price.toStringAsFixed(0)}'
                          : 'Free',
                      style: AppTypography.bodySmallSemiBold.copyWith(
                        color: service.price > 0
                            ? isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.lightTextPrimary
                            : AppColors.success,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
