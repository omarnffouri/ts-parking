import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';

import '../../../core/utils/error_handler.dart';
import '../../../core/utils/theme_extensions.dart';
import '../controllers/payment_method_controller.dart';
import '../../../domain/entities/user_card_entity.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_radius.dart';
import '../../../theme/app_spacing.dart';
import '../../../theme/app_typography.dart';
import 'widgets/payment_card.dart';

class PaymentCardDetailView extends StatefulWidget {
  const PaymentCardDetailView({
    super.key,
    required this.cardId,
    required this.index,
  });

  final String cardId;
  final int index;

  @override
  State<PaymentCardDetailView> createState() => _PaymentCardDetailViewState();
}

class _PaymentCardDetailViewState extends State<PaymentCardDetailView> {
  late final TextEditingController _nameController;
  final _controller = Get.find<PaymentMethodController>();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Cardholder Name');
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    final fieldFillColor = isDark
        ? AppColors.darkSurfaceVariant
        : const Color(0xFFF1F3F8);
    final shadowAlpha = isDark ? 0.2 : 0.06;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: Get.back,
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: context.primaryTextColor,
          ),
        ),
        title: Text(
          'Card Details',
          style: AppTypography.h3.copyWith(color: context.primaryTextColor),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => setState(() => _isEditing = !_isEditing),
            icon: Icon(
              _isEditing ? Icons.close_rounded : Icons.edit_rounded,
              color: _isEditing ? AppColors.error : context.secondaryTextColor,
              size: 22,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.lg,
            AppSpacing.sm,
            AppSpacing.lg,
            AppSpacing.lg,
          ),
          child: Obx(() {
            final card = _controller.cards
                .where((c) => c.id == widget.cardId)
                .firstOrNull;
            if (card == null) {
              return const Center(child: Text('Card not found'));
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  child: PaymentCard(card: card, index: widget.index),
                ),
                const SizedBox(height: AppSpacing.lg),
                _buildInfoSection(
                  card,
                  surfaceColor: context.surfaceColor,
                  textColor: context.primaryTextColor,
                  secondaryTextColor: context.secondaryTextColor,
                  fieldFillColor: fieldFillColor,
                  shadowAlpha: shadowAlpha,
                ),
                const SizedBox(height: AppSpacing.md),
                _buildActions(card),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildInfoSection(
    UserCardEntity card, {
    required Color surfaceColor,
    required Color textColor,
    required Color secondaryTextColor,
    required Color fieldFillColor,
    required double shadowAlpha,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: AppRadius.xlargeRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: shadowAlpha),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Card Information',
            style: AppTypography.h3.copyWith(color: textColor),
          ),
          const SizedBox(height: AppSpacing.ms),
          _CardField(
            label: 'Cardholder Name',
            value: _nameController.text,
            isEditing: _isEditing,
            controller: _nameController,
            fillColor: fieldFillColor,
            textColor: textColor,
            labelColor: secondaryTextColor,
          ),
          const SizedBox(height: AppSpacing.ms),
          _CardField(
            label: 'Card Number',
            value: card.maskedNumber,
            fillColor: fieldFillColor,
            textColor: textColor,
            labelColor: secondaryTextColor,
          ),
          const SizedBox(height: AppSpacing.ms),
          Row(
            children: [
              Expanded(
                child: _CardField(
                  label: 'Expiry Date',
                  value: card.expiry,
                  fillColor: fieldFillColor,
                  textColor: textColor,
                  labelColor: secondaryTextColor,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: _CardField(
                  label: 'Brand',
                  value: card.brand.toUpperCase(),
                  fillColor: fieldFillColor,
                  textColor: textColor,
                  labelColor: secondaryTextColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.ms),
          _StatusTile(
            isDefault: card.isDefault,
            fillColor: fieldFillColor,
            textColor: textColor,
            secondaryTextColor: secondaryTextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildActions(UserCardEntity card) {
    if (_isEditing) {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
          ),
          child: const Text('Save Changes'),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => _showDeleteConfirmation(context),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.error,
              side: const BorderSide(color: AppColors.error),
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.largeRadius,
              ),
            ),
            child: const Text('Delete'),
          ),
        ),
        if (!card.isDefault) ...[
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: _SetDefaultButton(
              controller: _controller,
              onPressed: () => _controller.setDefaultCard(card.id),
            ),
          ),
        ],
      ],
    );
  }

  void _saveChanges() {
    setState(() => _isEditing = false);
    ErrorHandler.showInfo('Design only', 'Update API will be connected later.');
  }

  void _showDeleteConfirmation(BuildContext context) {
    final theme = Theme.of(context);

    Get.dialog(
      Obx(
        () => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: AppRadius.xlargeRadius),
          title: Text(
            'Delete card?',
            style: AppTypography.h3.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'This will permanently remove the saved payment method from your account.',
            style: AppTypography.bodyMedium.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _controller.isDeletingCard.value ? null : Get.back,
              child: const Text(
                'Cancel',
                style: TextStyle(color: AppColors.error),
              ),
            ),
            ElevatedButton(
              onPressed: _controller.isDeletingCard.value
                  ? null
                  : () async {
                      final isDeleted = await _controller.deleteCard(
                        widget.cardId,
                        showSuccessMessage: false,
                      );
                      if (!isDeleted) {
                        return;
                      }
                      if (Get.isDialogOpen ?? false) {
                        Get.back();
                      }
                      if (mounted) {
                        Get.back();
                      }
                      Future<void>.delayed(
                        const Duration(milliseconds: 150),
                        () {
                          if (Get.context != null) {
                            ErrorHandler.showSuccess(
                              'Card deleted successfully.',
                            );
                          }
                        },
                      );
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: _controller.isDeletingCard.value
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Delete'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SetDefaultButton extends StatelessWidget {
  const _SetDefaultButton({required this.controller, required this.onPressed});

  final PaymentMethodController controller;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isLoading = controller.isSettingDefault.value;
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.primary.withValues(alpha: 0.6),
            disabledForegroundColor: Colors.white70,
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
            shape: RoundedRectangleBorder(borderRadius: AppRadius.largeRadius),
          ),
          child: isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Set as Default'),
        ),
      );
    });
  }
}

class _StatusTile extends StatelessWidget {
  const _StatusTile({
    required this.isDefault,
    required this.fillColor,
    required this.textColor,
    required this.secondaryTextColor,
  });

  final bool isDefault;
  final Color fillColor;
  final Color textColor;
  final Color secondaryTextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.ms,
      ),
      decoration: BoxDecoration(
        color: isDefault ? AppColors.success.withValues(alpha: 0.1) : fillColor,
        borderRadius: AppRadius.largeRadius,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Status',
            style: AppTypography.bodyMedium.copyWith(color: secondaryTextColor),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isDefault)
                Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.xs),
                  child: Icon(
                    Icons.check_circle_rounded,
                    size: 16,
                    color: AppColors.success,
                  ),
                ),
              Text(
                isDefault ? 'Default Card' : 'Saved Card',
                style: AppTypography.bodyMediumSemiBold.copyWith(
                  color: isDefault ? AppColors.success : textColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CardField extends StatelessWidget {
  const _CardField({
    required this.label,
    required this.fillColor,
    required this.textColor,
    required this.labelColor,
    this.value,
    this.controller,
    this.isEditing = false,
  });

  final String label;
  final String? value;
  final TextEditingController? controller;
  final bool isEditing;
  final Color fillColor;
  final Color textColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.bodySmallSemiBold.copyWith(color: labelColor),
        ),
        const SizedBox(height: AppSpacing.xs),
        if (isEditing && controller != null)
          TextField(
            controller: controller,
            style: AppTypography.bodyLarge.copyWith(color: textColor),
            decoration: InputDecoration(
              filled: true,
              fillColor: fillColor,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.ms,
              ),
              border: OutlineInputBorder(
                borderRadius: AppRadius.largeRadius,
                borderSide: BorderSide(color: AppColors.primary),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: AppRadius.largeRadius,
                borderSide: BorderSide(
                  color: AppColors.primary.withValues(alpha: 0.5),
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppRadius.largeRadius,
                borderSide: BorderSide(color: AppColors.primary, width: 1.5),
              ),
            ),
          )
        else
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.ms,
            ),
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: AppRadius.largeRadius,
            ),
            child: Text(
              value ?? controller?.text ?? '',
              style: AppTypography.bodyLarge.copyWith(color: textColor),
            ),
          ),
      ],
    );
  }
}
