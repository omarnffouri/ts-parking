import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/user_card_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/payment_controller.dart';

class CardSelector extends StatelessWidget {
  final PaymentController controller;
  final bool isDark;

  const CardSelector({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingCards) {
        return const Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      if (controller.cards.isEmpty) {
        return _EmptyCardState(controller: controller, isDark: isDark);
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Select payment method',
            style: AppTypography.bodyMediumSemiBold.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.ms),
          ...controller.cards.map(
            (card) => _CardTile(
              card: card,
              isSelected: controller.selectedCardId.value == card.id,
              onTap: () => controller.selectCard(card.id),
              isDark: isDark,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          GestureDetector(
            onTap: controller.openAddCardSheet,
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_outline_rounded,
                  size: 18,
                  color: AppColors.accent,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'Add new card',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}

class _CardTile extends StatelessWidget {
  final UserCardEntity card;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isDark;

  const _CardTile({
    required this.card,
    required this.isSelected,
    required this.onTap,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.sm),
        padding: const EdgeInsets.all(AppSpacing.ms),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
          borderRadius: AppRadius.mediumRadius,
          border: Border.all(
            color: isSelected
                ? AppColors.accent
                : isDark
                ? AppColors.darkBorder
                : AppColors.lightBorder,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.credit_card_rounded,
              size: 24,
              color: isSelected
                  ? AppColors.accent
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
            const SizedBox(width: AppSpacing.ms),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${card.brand.toUpperCase()} **** ${card.last4}',
                    style: AppTypography.bodySmallSemiBold.copyWith(
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  Text(
                    'Expires ${card.expiry}',
                    style: AppTypography.overline.copyWith(
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                size: 20,
                color: AppColors.accent,
              ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCardState extends StatelessWidget {
  final PaymentController controller;
  final bool isDark;

  const _EmptyCardState({required this.controller, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: AppRadius.mediumRadius,
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.4)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.credit_card_off_rounded,
            size: 40,
            color: isDark
                ? AppColors.darkTextTertiary
                : AppColors.lightTextTertiary,
          ),
          const SizedBox(height: AppSpacing.ms),
          Text(
            'No saved cards',
            style: AppTypography.bodyMediumSemiBold.copyWith(
              color: isDark
                  ? AppColors.darkTextPrimary
                  : AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Add a card to complete your payment',
            style: AppTypography.bodySmall.copyWith(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: controller.openAddCardSheet,
            icon: const Icon(Icons.add_rounded, size: 18),
            label: const Text('Add Card'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: AppRadius.mediumRadius,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
