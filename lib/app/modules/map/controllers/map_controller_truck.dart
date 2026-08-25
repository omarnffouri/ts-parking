part of 'map_controller.dart';

extension MapControllerTruckX on MapController {
  Future<void> handleSlotTap(
    BuildContext context,
    ParkingZoneConfig zone,
    ParkingSlotConfig slotConfig,
  ) async {
    final slot = slotConfig.slot;
    if (_truckRect.value != null) return;

    _selectedSlot.value = slot;
    _focusSlotRect(slotConfig.rect);

    if (!slot.isBookable) {
      await openSlotSheet(context, slot);
      return;
    }

    final runId = ++_truckAnimationRun;
    final usesTopDownArrival = _usesBottomArrival(
      zone: zone,
      slotConfig: slotConfig,
    );
    _truckArrivalVisual.value = usesTopDownArrival
        ? TruckArrivalVisual.topDown
        : TruckArrivalVisual.side;
    _truckRotation.value = usesTopDownArrival ? slotConfig.rotation : 0.0;
    final endRect = _truckEndRect(zone: zone, slotConfig: slotConfig);
    final startRect = _truckStartRect(zone: zone, slotConfig: slotConfig);

    _truckRect.value = startRect;
    _truckVisible.value = false;

    await Future<void>.delayed(const Duration(milliseconds: 16));
    if (runId != _truckAnimationRun) return;

    _truckRect.value = startRect;
    _truckVisible.value = true;

    await Future<void>.delayed(const Duration(milliseconds: 16));
    if (runId != _truckAnimationRun) return;

    _truckRect.value = endRect;

    await Future<void>.delayed(MapController.truckTravelDuration);
    if (runId != _truckAnimationRun) return;
    if (!context.mounted) return;

    await openSlotSheet(context, slot);
    if (runId != _truckAnimationRun) return;

    _truckVisible.value = false;

    await Future<void>.delayed(MapController.truckFadeDuration);
    if (runId != _truckAnimationRun) return;

    _resetTruckState();
  }

  Rect _truckEndRect({
    required ParkingZoneConfig zone,
    required ParkingSlotConfig slotConfig,
  }) {
    if (_usesBottomArrival(zone: zone, slotConfig: slotConfig)) {
      final isCompactSlot = _isCompactSlot(slotConfig);
      final width = (slotConfig.rect.width * (isCompactSlot ? 1.35 : 1.7))
          .clamp(isCompactSlot ? 20.0 : 34.0, isCompactSlot ? 28.0 : 46.0)
          .toDouble();
      final height = (slotConfig.rect.height * (isCompactSlot ? 1.72 : 1.42))
          .clamp(isCompactSlot ? 46.0 : 92.0, isCompactSlot ? 64.0 : 122.0)
          .toDouble();
      final designSize = activeMapConfig.designSize;
      final left = (slotConfig.rect.center.dx - (width * 0.5)).clamp(
        12.0,
        designSize.width - width - 12.0,
      );
      final top =
          (isCompactSlot
                  ? slotConfig.rect.center.dy - (height * 0.5)
                  : slotConfig.rect.top - (slotConfig.rect.height * 0.06))
              .clamp(24.0, designSize.height - height - 24.0);

      return Rect.fromLTWH(left.toDouble(), top.toDouble(), width, height);
    }

    final width = (slotConfig.rect.width * 0.88).clamp(14.0, 28.0).toDouble();
    final height = (slotConfig.rect.height * 0.62)
        .clamp(8.0, slotConfig.rect.height - 2.0)
        .toDouble();
    final designSize = activeMapConfig.designSize;
    final left = (slotConfig.rect.center.dx - (width * 0.5)).clamp(
      12.0,
      designSize.width - width - 12.0,
    );
    final top = (slotConfig.rect.center.dy - (height * 0.5)).clamp(
      24.0,
      designSize.height - height - 24.0,
    );

    return Rect.fromLTWH(left.toDouble(), top.toDouble(), width, height);
  }

  Rect _truckStartRect({
    required ParkingZoneConfig zone,
    required ParkingSlotConfig slotConfig,
  }) {
    final endRect = _truckEndRect(zone: zone, slotConfig: slotConfig);

    if (_usesBottomArrival(zone: zone, slotConfig: slotConfig)) {
      final isCompactSlot = _isCompactSlot(slotConfig);
      final designSize = activeMapConfig.designSize;
      final maxTop = designSize.height - endRect.height - 12.0;
      final desiredTop = zone.focusBounds.bottom + (isCompactSlot ? 20 : 40);
      final minTop = endRect.top + (isCompactSlot ? 24 : 56);
      final startTop = desiredTop.clamp(minTop, maxTop);

      return Rect.fromLTWH(
        endRect.left,
        startTop.toDouble(),
        endRect.width,
        endRect.height,
      );
    }

    final startLeft = (zone.focusBounds.left - endRect.width - 56).clamp(
      -endRect.width,
      endRect.left - 48,
    );

    return Rect.fromLTWH(
      startLeft.toDouble(),
      endRect.top,
      endRect.width,
      endRect.height,
    );
  }

  bool _usesBottomArrival({
    required ParkingZoneConfig zone,
    required ParkingSlotConfig slotConfig,
  }) {
    if (zone.layoutKey == 'east') {
      return false;
    }

    return slotConfig.rect.height > slotConfig.rect.width;
  }

  bool _isCompactSlot(ParkingSlotConfig slotConfig) =>
      slotConfig.rect.shortestSide <= 20;

  void _resetTruckState() {
    _truckRect.value = null;
    _truckVisible.value = false;
    _truckArrivalVisual.value = TruckArrivalVisual.side;
    _truckRotation.value = 0.0;
  }
}
