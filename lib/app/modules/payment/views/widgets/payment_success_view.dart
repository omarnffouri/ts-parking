import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/theme_extensions.dart';
import '../../../../core/widgets/label_value_row.dart';
import '../../../../domain/entities/invoice_entity.dart';
import '../../../../domain/entities/subscription_entity.dart';
import '../../../../domain/params/payment_success_args.dart';
import '../../../../routes/app_pages.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';

class PaymentSuccessView extends StatelessWidget {
  const PaymentSuccessView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final args = Get.arguments as PaymentSuccessArgs;
    final invoice = args.invoice;
    final subscriptions = args.subscriptions;
    final isPaidFlow = invoice?.status == 'paid';

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: isDark
            ? AppColors.darkBackground
            : AppColors.lightBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 48,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  isPaidFlow ? 'Payment Successful' : 'Subscription Activated',
                  style: AppTypography.h2.copyWith(
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.lightTextPrimary,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Your parking subscription is now active',
                  style: AppTypography.bodyMedium.copyWith(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                _DetailsCard(
                  invoice: invoice,
                  subscriptions: subscriptions,
                  isDark: isDark,
                ),
                const Spacer(flex: 2),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Get.offAllNamed(Routes.MAIN_SCREEN),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: AppRadius.mediumRadius,
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.ms,
                      ),
                    ),
                    child: Text(
                      'Go to Home',
                      style: AppTypography.buttonMedium,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DetailsCard extends StatelessWidget {
  final InvoiceEntity? invoice;
  final List<SubscriptionEntity> subscriptions;
  final bool isDark;

  const _DetailsCard({
    required this.invoice,
    required this.subscriptions,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          if (invoice != null) ...[
            LabelValueRow(
              label: 'Invoice',
              value: invoice!.invoiceNumber,
              isDark: isDark,
            ),
            const SizedBox(height: AppSpacing.sm),
            LabelValueRow(
              label: 'Amount',
              value: '\$${invoice!.total.toStringAsFixed(2)}',
              isDark: isDark,
              valueColor: AppColors.accent,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          ...subscriptions.map(
            (sub) => Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xs),
              child: LabelValueRow(
                label: 'Subscription',
                value: sub.subscriptionRef,
                isDark: isDark,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
