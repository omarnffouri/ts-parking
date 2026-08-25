import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/enums/parking_vehicle_type.dart';
import '../../../../core/utils/color_extensions.dart';
import '../../../../domain/entities/slot_entity.dart';
import '../../../../theme/app_colors.dart';
import '../../../../theme/app_radius.dart';
import '../../../../theme/app_spacing.dart';
import '../../../../theme/app_typography.dart';
import '../../controllers/map_controller.dart';

class ZoneSlotsSheet extends GetView<MapController> {
  const ZoneSlotsSheet({
    required this.parentContext,
    required this.zoneName,
    required this.slots,
    super.key,
  });

  final BuildContext parentContext;
  final String zoneName;
  final List<SlotEntity> slots;

  @override
  Widget build(BuildContext context) {
    final sheetHeight = MediaQuery.of(context).size.height * 0.74;

    return Container(
      height: sheetHeight,
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
          Text(
            zoneName,
            style: AppTypography.h3.copyWith(color: context.primaryTextColor),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${slots.length} slots from API',
            style: AppTypography.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = constraints.maxWidth >= 1100
                    ? 6
                    : constraints.maxWidth >= 920
                    ? 5
                    : constraints.maxWidth >= 680
                    ? 4
                    : 4;
                final childAspectRatio = constraints.maxWidth >= 920
                    ? 1.04
                    : constraints.maxWidth >= 680
                    ? 0.98
                    : 0.94;

                return GridView.builder(
                  key: ValueKey('zone_slots_sheet_$zoneName'),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: AppSpacing.sm,
                    mainAxisSpacing: AppSpacing.sm,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemCount: slots.length,
                  itemBuilder: (context, index) => _ZoneSlotTile(
                    slot: slots[index],
                    onTap: () async {
                      if (!slots[index].isBookable) {
                        _showBusyWarning(slots[index]);
                        return;
                      }

                      Navigator.of(context).pop();
                      await Future<void>.delayed(
                        const Duration(milliseconds: 160),
                      );
                      if (!parentContext.mounted) return;
                      await controller.openSlotSheet(
                        parentContext,
                        slots[index],
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBusyWarning(SlotEntity slot) {
    final code = slot.slotCode.trim().isEmpty
        ? 'This slot'
        : 'Slot ${slot.slotCode}';
    Get.closeAllSnackbars();
    Get.snackbar(
      'Slot Busy',
      '$code is currently occupied.',
      snackPosition: SnackPosition.TOP,
      backgroundColor: const Color(0xFF3A1616),
      colorText: Colors.white,
      borderColor: AppColors.error.withValues(alpha: 0.55),
      borderWidth: 1.2,
      margin: const EdgeInsets.all(AppSpacing.md),
      borderRadius: AppRadius.small,
      icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
      shouldIconPulse: false,
      duration: const Duration(seconds: 2),
    );
  }
}

class _ZoneSlotTile extends StatelessWidget {
  const _ZoneSlotTile({required this.slot, required this.onTap});

  final SlotEntity slot;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accentColor = slot.isBookable
        ? AppColors.success.withValues(alpha: 0.95)
        : AppColors.error.withValues(alpha: 0.95);
    final glowColor = slot.isBookable
        ? AppColors.successGlow
        : AppColors.errorGlow;
    final code = slot.slotCode.trim().isEmpty ? 'S${slot.id}' : slot.slotCode;
    final vehicleType = slot.vehicleType;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mediumRadius,
        child: Ink(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: context.tileColor,
            borderRadius: AppRadius.mediumRadius,
            border: Border.all(color: accentColor.withValues(alpha: 0.7)),
            boxShadow: [
              BoxShadow(
                color: glowColor.withValues(alpha: 0.14),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      code,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodyMediumSemiBold.copyWith(
                        color: context.primaryTextColor,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: accentColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Center(
                child: Icon(vehicleType.icon, size: 26, color: accentColor),
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _displayNumber(slot.row),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmallSemiBold.copyWith(
                        color: context.secondaryTextColor,
                        fontSize: 11,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      vehicleType.label,
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.bodySmall.copyWith(
                        color: context.secondaryTextColor,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _displayNumber(int? value) => value?.toString() ?? '-';
