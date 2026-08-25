import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/utils/color_extensions.dart';
import '../../../../core/utils/string_extensions.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/enums/slot_status_enum.dart';
import '../../../../domain/entities/slot_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/map_controller.dart';

class SlotDetailsSheet extends GetView<MapController> {
  const SlotDetailsSheet({required this.slot, super.key});

  final SlotEntity slot;

  @override
  Widget build(BuildContext context) {
    final occupant = slot.activeSubscriptionUser;
    final statusForeground = slot.isBookable
        ? const Color(0xFF375FBE)
        : const Color(0xFF9A3B38);
    final statusBackground = slot.isBookable
        ? const Color(0xFFE8EEFF)
        : const Color(0xFFF7E1E0);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [context.backgroundColor, context.panelColor],
        ),
        borderRadius: AppRadius.xlargeTopRadius,
        boxShadow: const [
          BoxShadow(
            color: Color(0x260F172A),
            blurRadius: 26,
            offset: Offset(0, -10),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.of(context).padding.bottom + AppSpacing.md,
      ),
      child: Column(
        key: ValueKey('slot_sheet_${slot.id}'),
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 44,
              height: 5,
              decoration: BoxDecoration(
                color: context.panelBorderColor,
                borderRadius: AppRadius.pillRadius,
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Slot ${slot.slotCode}',
                      style: AppTypography.h3.copyWith(
                        color: context.primaryTextColor,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${slot.zoneName} • ${controller.yardName}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: context.secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: statusBackground,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: statusForeground.withValues(alpha: 0.14),
                  ),
                ),
                child: Text(
                  slot.status.title,
                  style: AppTypography.bodySmall.copyWith(
                    color: statusForeground,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFF5F7FC)],
              ),
              borderRadius: AppRadius.largeRadius,
              border: Border.all(color: context.panelBorderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _MetricTile(
                    label: 'Plan',
                    value: slot.planName.toTitleCase(),
                    icon: Icons.workspace_premium_rounded,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MetricTile(
                    label: 'Vehicle',
                    value: slot.vehicleTypeName,
                    icon: Icons.local_shipping_rounded,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _MetricTile(
                    label: 'Price',
                    value: slot.price.toPrice(),
                    icon: Icons.sell_rounded,
                  ),
                ),
              ],
            ),
          ),
          if (occupant != null) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFF8FAFF), Color(0xFFEEF2FA)],
                ),
                borderRadius: AppRadius.largeRadius,
                border: Border.all(color: context.panelBorderColor),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: const Color(
                      0xFF5E67F8,
                    ).withValues(alpha: 0.12),
                    child: Text(
                      occupant.name.isEmpty ? '?' : occupant.name[0],
                      style: AppTypography.bodyMedium.copyWith(
                        color: const Color(0xFF5E67F8),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          occupant.name,
                          style: AppTypography.bodyMedium.copyWith(
                            color: context.primaryTextColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${occupant.userTypeLabel} • ${occupant.mobileNumber}',
                          style: AppTypography.bodySmall.copyWith(
                            color: context.secondaryTextColor,
                          ),
                        ),
                        if ((occupant.vehicleNumber ?? '')
                            .trim()
                            .isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Vehicle ${occupant.vehicleNumber}',
                            style: AppTypography.bodySmall.copyWith(
                              color: context.secondaryTextColor,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),
          if (slot.isBookable)
            AppButton.primary(
              label: 'Book now',
              onPressed: () {
                Navigator.of(context).pop();
                controller.bookSelectedSlot(slot);
              },
              backgroundColor: AppColors.primary,
              textColor: AppColors.lightTextPrimary,
              borderRadius: BorderRadius.circular(20),
              useGlow: true,
            )
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFFF5F5), Color(0xFFF8E5E5)],
                ),
                borderRadius: AppRadius.largeRadius,
                border: Border.all(color: const Color(0xFFE7CACA)),
              ),
              child: Text(
                'This slot is currently occupied',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  color: const Color(0xFF9A3B38),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: const Color(0xFF6B7280)),
          const SizedBox(height: 10),
          Text(
            label,
            style: AppTypography.bodySmall.copyWith(
              color: const Color(0xFF8A94A6),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.bodySmallSemiBold.copyWith(
              color: const Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}
