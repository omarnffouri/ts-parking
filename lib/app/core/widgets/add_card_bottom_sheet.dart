import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_radius.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_typography.dart';

void showAddCardBottomSheet({
  required TextEditingController cardholderNameController,
  required CardEditController cardEditController,
  required RxBool isCardComplete,
  required RxBool isSubmitting,
  required void Function(CardFieldInputDetails?) onCardChanged,
  required Future<void> Function() onSubmit,
}) {
  Get.bottomSheet(
    AddCardBottomSheet(
      cardholderNameController: cardholderNameController,
      cardEditController: cardEditController,
      isCardComplete: isCardComplete,
      isSubmitting: isSubmitting,
      onCardChanged: onCardChanged,
      onSubmit: onSubmit,
    ),
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
  );
}

class AddCardBottomSheet extends StatelessWidget {
  final TextEditingController cardholderNameController;
  final CardEditController cardEditController;
  final RxBool isCardComplete;
  final RxBool isSubmitting;
  final void Function(CardFieldInputDetails?) onCardChanged;
  final Future<void> Function() onSubmit;

  const AddCardBottomSheet({
    super.key,
    required this.cardholderNameController,
    required this.cardEditController,
    required this.isCardComplete,
    required this.isSubmitting,
    required this.onCardChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppRadius.xlargeTopRadius,
      ),
      padding: EdgeInsets.fromLTRB(
        AppSpacing.lg,
        AppSpacing.sm,
        AppSpacing.lg,
        bottomPadding + AppSpacing.md,
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
              margin: EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: theme.dividerColor,
                borderRadius: AppRadius.pillRadius,
              ),
            ),
          ),

          Text('Add New Card', style: AppTypography.h3),
          SizedBox(height: AppSpacing.xs),
          Text(
            'Enter your card details to save a payment method.',
            style: AppTypography.bodyMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: AppSpacing.md),

          // Cardholder name
          TextField(
            controller: cardholderNameController,
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
          ),
          SizedBox(height: AppSpacing.ms),

          // Stripe card field
          Container(
            padding: EdgeInsets.all(AppSpacing.ms),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.45,
              ),
              borderRadius: AppRadius.largeRadius,
            ),
            child: CardField(
              controller: cardEditController,
              enablePostalCode: false,
              onCardChanged: onCardChanged,
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: AppTypography.bodyLarge.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),

          // Submit button
          Obx(() {
            final canSubmit = isCardComplete.value && !isSubmitting.value;

            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: canSubmit ? onSubmit : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.primary.withValues(
                    alpha: 0.4,
                  ),
                  disabledForegroundColor: Colors.white70,
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.largeRadius,
                  ),
                ),
                child: isSubmitting.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text('Save Card'),
              ),
            );
          }),
        ],
      ),
    );
  }
}
