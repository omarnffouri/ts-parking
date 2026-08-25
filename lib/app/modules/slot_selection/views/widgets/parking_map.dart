import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ts_parking/app/core/utils/color_extensions.dart';
import 'package:ts_parking/app/core/utils/string_extensions.dart';
import 'package:ts_parking/app/core/utils/theme_extensions.dart';
import 'package:ts_parking/app/domain/entities/slot_entity.dart';
import 'package:ts_parking/app/core/enums/parking_vehicle_type.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';
import 'package:ts_parking/app/modules/slot_selection/controllers/slot_selection_controller.dart';
import 'package:ts_parking/app/modules/slot_selection/views/widgets/parking_road_painter.dart';
import 'package:ts_parking/app/theme/app_colors.dart';
import 'package:ts_parking/app/theme/app_radius.dart';
import 'package:ts_parking/app/theme/app_spacing.dart';
import 'package:ts_parking/app/theme/app_typography.dart';

class ParkingMap extends StatelessWidget {
  const ParkingMap({super.key, required this.controller});

  final SlotSelectionController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.panelColor,
        borderRadius: AppRadius.xlargeRadius,
        border: Border.all(color: context.panelBorderColor),
      ),
      child: Obx(() {
        final groups = controller.visibleGroupedSlots;

        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LegendRow(controller: controller),
              const SizedBox(height: AppSpacing.md),
              if (groups.isEmpty)
                const SizedBox(
                  height: 360,
                  child: Center(child: _FilteredEmptyState()),
                )
              else
                ...List.generate(groups.length, (index) {
                  final group = groups[index];
                  return Padding(
                    padding: EdgeInsets.only(
                      bottom: index == groups.length - 1 ? 0 : AppSpacing.lg,
                    ),
                    child: _ZoneSection(
                      group: group,
                      isFirst: index == 0,
                      controller: controller,
                    ),
                  );
                }),
            ],
          ),
        );
      }),
    );
  }
}

class _FilteredEmptyState extends StatelessWidget {
  const _FilteredEmptyState();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SlotSelectionController>();
    final statusFilter = controller.selectedStatusFilter.value;
    final title = switch (statusFilter) {
      SlotStatus.available => 'No available slots right now',
      SlotStatus.booked => 'No occupied slots at the moment',
      null =>
        controller.showAvailableOnly.value
            ? 'No available slots right now'
            : 'No slots to show',
    };
    final message = switch (statusFilter) {
      null =>
        controller.showAvailableOnly.value
            ? 'Turn off the filter or try another vehicle type.'
            : 'Try again in a moment.',
      SlotStatus.booked => 'Tap another filter to browse different slots.',
      SlotStatus.available =>
        'Try another vehicle type or clear the filter to browse all slots.',
    };

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: Column(
        key: const ValueKey('visible_slots_empty'),
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusFilter == SlotStatus.booked
                ? Icons.local_parking_rounded
                : Icons.event_busy_outlined,
            size: 48,
            color: context.secondaryTextColor,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.bodyLargeSemiBold.copyWith(
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: AppTypography.bodyMedium.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.controller});

  final SlotSelectionController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Wrap(
        spacing: AppSpacing.md,
        runSpacing: AppSpacing.sm,
        children: [
          _LegendItem(
            color: AppColors.success,
            label: 'Available',
            isSelected: controller.isStatusFilterSelected(SlotStatus.available),
            onTap: () => controller.toggleStatusFilter(SlotStatus.available),
          ),
          _LegendItem(
            color: AppColors.error,
            label: 'Occupied',
            isSelected: controller.isStatusFilterSelected(SlotStatus.booked),
            onTap: () => controller.toggleStatusFilter(SlotStatus.booked),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final Color color;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? color.withValues(alpha: context.isDark ? 0.14 : 0.12)
              : context.legendIdleBackground,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isSelected
                ? color.withValues(alpha: 0.65)
                : context.legendIdleBorder,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              label,
              style: AppTypography.bodySmall.copyWith(
                color: isSelected ? color : context.secondaryTextColor,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ZoneSection extends StatelessWidget {
  const _ZoneSection({
    required this.group,
    required this.isFirst,
    required this.controller,
  });

  final ZoneSlotGroup group;
  final bool isFirst;
  final SlotSelectionController controller;

  @override
  Widget build(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!isFirst) ...[
          Text(
            group.zoneName,
            key: ValueKey('zone_section_${group.zoneName}'),
            style: AppTypography.bodyLargeSemiBold.copyWith(
              color: context.primaryTextColor,
            ),
          ),
          const SizedBox(height: AppSpacing.ms),
        ],
        _SlotGrid(
          zoneName: group.zoneName,
          slots: group.slots,
          controller: controller,
        ),
      ],
    );

    if (!isFirst) {
      return content;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(top: AppSpacing.sm, right: AppSpacing.sm),
          child: _EntryGuide(label: group.zoneName),
        ),
        Expanded(child: content),
      ],
    );
  }
}

class _EntryGuide extends StatelessWidget {
  const _EntryGuide({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final compactLabel = label.toCompactInitials();

    return SizedBox(
      width: 18,
      child: Column(
        children: [
          Text(
            compactLabel,
            textAlign: TextAlign.center,
            style: AppTypography.bodySmallSemiBold.copyWith(
              color: context.primaryTextColor,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: 26,
            height: 26,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.arrow_forward_rounded,
              size: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          SizedBox(
            width: 30,
            height: 112,
            child: CustomPaint(painter: ParkingRoadPainter()),
          ),
        ],
      ),
    );
  }
}

class _SlotGrid extends StatefulWidget {
  const _SlotGrid({
    required this.zoneName,
    required this.slots,
    required this.controller,
  });

  final String zoneName;
  final List<SlotEntity> slots;
  final SlotSelectionController controller;

  @override
  State<_SlotGrid> createState() => _SlotGridState();
}

class _SlotGridState extends State<_SlotGrid> {
  static const int _rowsPerPage = 4;
  static const int _columnsPerPage = 5;
  static const int _slotsPerPage = _rowsPerPage * _columnsPerPage;
  static const double _columnSpacing = 8;
  static const double _rowSpacing = 24;
  static const double _tileAspectRatio = 0.92;

  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final tileWidth =
            (constraints.maxWidth - (_columnSpacing * (_columnsPerPage - 1))) /
            _columnsPerPage;
        final tileHeight = tileWidth / _tileAspectRatio;
        final pageHeight =
            (_rowsPerPage * tileHeight) + ((_rowsPerPage - 1) * _rowSpacing);
        final pageCount = ((widget.slots.length / _slotsPerPage).ceil()).clamp(
          1,
          9999,
        );

        if (_currentPage >= pageCount) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() => _currentPage = pageCount - 1);
            }
          });
        }

        return Column(
          children: [
            SizedBox(
              height: pageHeight,
              child: PageView.builder(
                controller: _pageController,
                itemCount: pageCount,
                onPageChanged: (page) {
                  setState(() => _currentPage = page);
                  widget.controller.ensureSlotsForZonePage(
                    widget.zoneName,
                    page,
                    slotsPerPage: _slotsPerPage,
                  );
                },
                itemBuilder: (context, pageIndex) {
                  final start = pageIndex * _slotsPerPage;
                  final end = (start + _slotsPerPage).clamp(
                    0,
                    widget.slots.length,
                  );
                  final pageSlots = widget.slots.sublist(start, end);

                  return GridView.builder(
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _slotsPerPage,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: _columnsPerPage,
                          crossAxisSpacing: _columnSpacing,
                          mainAxisSpacing: _rowSpacing,
                          childAspectRatio: _tileAspectRatio,
                        ),
                    itemBuilder: (context, index) {
                      if (index >= pageSlots.length) {
                        return const SizedBox.shrink();
                      }

                      final slot = pageSlots[index];
                      return Obx(
                        () => _SlotTile(
                          slot: slot,
                          isSelected: widget.controller.isSelected(slot.id),
                          onTap: () => widget.controller.handleSlotTap(slot),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            if (pageCount > 1) ...[
              const SizedBox(height: AppSpacing.sm),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(pageCount, (index) {
                  final isActive = index == _currentPage;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: isActive ? 18 : 6,
                    height: 6,
                    margin: EdgeInsets.only(
                      right: index == pageCount - 1 ? 0 : AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.primary
                          : context.legendIdleBorder,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  );
                }),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _SlotTile extends StatelessWidget {
  const _SlotTile({
    required this.slot,
    required this.isSelected,
    required this.onTap,
  });

  final SlotEntity slot;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final vehicleType = slot.vehicleType;
    final canTap = slot.isBookable;
    final isReserved = !canTap && slot.activeSubscriptionUser != null;
    final availabilityColor = canTap ? AppColors.success : AppColors.error;
    final borderColor = isSelected
        ? AppColors.primary
        : availabilityColor.withValues(alpha: 0.45);

    return InkWell(
      key: ValueKey('slot_tile_${slot.id}'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 92,
        padding: const EdgeInsets.all(AppSpacing.xs),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary.withValues(alpha: 0.12)
              : context.tileColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: borderColor, width: isSelected ? 2.6 : 1),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: borderColor.withValues(alpha: 0.22),
                blurRadius: 26,
                spreadRadius: 1.5,
                offset: const Offset(0, 10),
              ),
          ],
        ),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        slot.slotCode,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                        style: AppTypography.bodyLargeSemiBold.copyWith(
                          color: context.primaryTextColor,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    if (isReserved)
                      Icon(
                        Icons.lock_rounded,
                        size: 13,
                        color: AppColors.error.withValues(alpha: 0.92),
                      ),
                    if (slot.isVip)
                      Padding(
                        padding: EdgeInsets.only(
                          left: isReserved ? AppSpacing.xs : 0,
                        ),
                        child: Icon(
                          Icons.star_rounded,
                          key: ValueKey('slot_vip_${slot.id}'),
                          size: 14,
                          color: AppColors.primary,
                        ),
                      ),
                  ],
                ),
                // const SizedBox(height: AppSpacing.xs),
                // Row(
                //   children: [
                //     Container(
                //       width: 6,
                //       height: 6,
                //       decoration: BoxDecoration(
                //         color: slotVisual.color,
                //         shape: BoxShape.circle,
                //       ),
                //     ),
                //     const SizedBox(width: AppSpacing.xs),
                //     Expanded(
                //       child: Text(
                //         slotVisual.label,
                //         maxLines: 1,
                //         overflow: TextOverflow.ellipsis,
                //         style: AppTypography.bodySmall.copyWith(
                //           color: slotVisual.color,
                //           fontSize: 9.5,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                Expanded(
                  child: Center(
                    child: ClipRect(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              color: availabilityColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Flexible(
                            child: Image.asset(
                              vehicleType.iconAsset,
                              height: 32,
                              fit: BoxFit.contain,
                              color: availabilityColor.withValues(alpha: 0.88),
                              colorBlendMode: BlendMode.modulate,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
