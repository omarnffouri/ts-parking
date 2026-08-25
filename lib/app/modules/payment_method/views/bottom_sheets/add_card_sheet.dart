import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/payment_method_controller.dart';

class AddCardSheet extends StatelessWidget {
  const AddCardSheet({super.key, required this.controller});

  final PaymentMethodController controller;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    // final viewPadding = MediaQuery.viewPaddingOf(context).bottom;
    // final bottomPadding = viewInsets > 0 ? viewInsets : viewPadding;

    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.xlargeTopRadius,
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        bottomInset + AppSpacing.md,
      ),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHandle(theme),
            Text('Add New Card', style: AppTypography.h3),
            SizedBox(height: AppSpacing.xs),
            Text(
              'Enter your card details to create a Stripe payment method and save the card to your account.',
              style: AppTypography.bodyMedium.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: AppSpacing.md),
            _buildCardholderField(theme),
            SizedBox(height: AppSpacing.ms),
            _buildStripeCardField(theme),
            SizedBox(height: AppSpacing.xs),
            _buildHelperText(theme),
            SizedBox(height: AppSpacing.lg),
            _buildSubmitButton(),
            SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
    );
  }

  Widget _buildHandle(ThemeData theme) {
    return Center(
      child: Container(
        width: 44,
        height: 4,
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        decoration: BoxDecoration(
          color: theme.dividerColor,
          borderRadius: AppRadius.pillRadius,
        ),
      ),
    );
  }

  Widget _buildCardholderField(ThemeData theme) {
    return TextField(
      controller: controller.cardholderNameController,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Cardholder Name',
        hintText: 'Name on card',
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.45,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.largeRadius,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildStripeCardField(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.ms),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.45,
        ),
        borderRadius: AppRadius.largeRadius,
      ),
      child: CardField(
        controller: controller.cardEditController,
        enablePostalCode: false,
        onCardChanged: controller.onCardChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          disabledBorder: InputBorder.none,
          isDense: true,
          contentPadding: EdgeInsets.zero,
        ),
        style: AppTypography.bodyLarge.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }

  Widget _buildHelperText(ThemeData theme) {
    if (AppConstants.stripePublishableKey.isEmpty) {
      return Text(
        'Stripe publishable key is missing. Set STRIPE_PUBLISHABLE_KEY to enable card saving.',
        style: AppTypography.bodySmall.copyWith(color: AppColors.error),
      );
    }

    return Text(
      'Your card details are converted into a Stripe payment method before they are sent to the API.',
      style: AppTypography.bodySmall.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Obx(
      () => SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: controller.canSubmitCard ? controller.submitAddCard : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.4),
            disabledForegroundColor: Colors.white70,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
          ),
          child: controller.isSubmitting
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Save Card'),
        ),
      ),
    );
  }
}
