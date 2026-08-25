part of 'map_controller.dart';

extension MapControllerZoneX on MapController {
  Future<void> openZoneSlotsSheet(
    BuildContext context,
    ParkingZoneConfig zone,
  ) async {
    final denseLayoutZone = denseLayoutZoneFor(zone);
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ZoneSlotsSheet(
        parentContext: context,
        zoneName: denseLayoutZone.name,
        slots: denseLayoutZone.slots
            .map((slotConfig) => slotConfig.slot)
            .toList(growable: false),
      ),
    );
  }

  bool isSelectedSlot(ParkingSlotConfig slotConfig) =>
      _selectedSlot.value?.id == slotConfig.slot.id;

  bool isDenseZone(ParkingZoneConfig zone) =>
      denseLayoutZoneFor(zone).slots.length >
      _denseZoneThresholdFor(zone.layoutKey);

  bool shouldShowDenseZoneLabel(ParkingZoneConfig zone) {
    if (!isDenseZone(zone)) {
      return false;
    }

    final firstLayoutZone = activeMapConfig.zones.firstWhereOrNull(
      (candidate) => candidate.layoutKey == zone.layoutKey,
    );
    return firstLayoutZone?.id == zone.id;
  }

  ParkingZoneConfig denseLayoutZoneFor(ParkingZoneConfig zone) {
    final siblingZones = activeMapConfig.zones
        .where((candidate) => candidate.layoutKey == zone.layoutKey)
        .toList(growable: false);
    if (siblingZones.length <= 1) {
      return ParkingZoneConfig(
        id: zone.id,
        name: _layoutDisplayName(zone.layoutKey),
        layoutKey: zone.layoutKey,
        tapBounds: zone.tapBounds,
        focusBounds: zone.focusBounds,
        focusScaleMultiplier: zone.focusScaleMultiplier,
        slots: zone.slots,
      );
    }

    var combinedTapBounds = siblingZones.first.tapBounds;
    var combinedFocusBounds = siblingZones.first.focusBounds;
    var maxFocusScaleMultiplier = siblingZones.first.focusScaleMultiplier;

    for (final sibling in siblingZones.skip(1)) {
      combinedTapBounds = combinedTapBounds.expandToInclude(sibling.tapBounds);
      combinedFocusBounds = combinedFocusBounds.expandToInclude(
        sibling.focusBounds,
      );
      maxFocusScaleMultiplier = math.max(
        maxFocusScaleMultiplier,
        sibling.focusScaleMultiplier,
      );
    }

    return ParkingZoneConfig(
      id: zone.layoutKey,
      name: _layoutDisplayName(zone.layoutKey),
      layoutKey: siblingZones.first.layoutKey,
      tapBounds: combinedTapBounds,
      focusBounds: combinedFocusBounds,
      focusScaleMultiplier: maxFocusScaleMultiplier,
      slots: siblingZones
          .expand((candidate) => candidate.slots)
          .toList(growable: false),
    );
  }

  Color fillColorForSlot(ParkingSlotConfig slotConfig) {
    final userType = slotConfig.slot.activeSubscriptionUser?.userType.trim();
    if (userType == null || userType.isEmpty) {
      return MapController._defaultEmptySlotColor;
    }

    final paletteIndex =
        userType.codeUnits.fold<int>(0, (sum, unit) => sum + unit) %
        MapController._userTypePalette.length;
    return MapController._userTypePalette[paletteIndex];
  }

  int _denseZoneThresholdFor(String layoutKey) {
    switch (layoutKey) {
      case 'south':
        return MapController.southDenseZoneSlotThreshold;
      default:
        return MapController.denseZoneSlotThreshold;
    }
  }

  String _layoutDisplayName(String layoutKey) {
    switch (layoutKey) {
      case 'north':
        return 'North';
      case 'east':
        return 'East';
      case 'south':
        return 'South';
      case 'west':
        return 'West';
      case 'middle':
        return 'Middle';
      default:
        return layoutKey;
    }
  }
}
