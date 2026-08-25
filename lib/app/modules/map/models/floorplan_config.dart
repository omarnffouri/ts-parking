import 'dart:math' as math;
import 'dart:ui';

import '../../../domain/entities/slot_entity.dart';

class ParkingMapConfig {
  final String yardId;
  final String yardName;
  final String yardAddress;
  final Size designSize;
  final Rect overviewBounds;
  final List<ParkingZoneConfig> zones;

  const ParkingMapConfig({
    required this.yardId,
    required this.yardName,
    required this.yardAddress,
    required this.designSize,
    required this.overviewBounds,
    required this.zones,
  });

  ParkingMapConfig withoutSlots() {
    return ParkingMapConfig(
      yardId: yardId,
      yardName: yardName,
      yardAddress: yardAddress,
      designSize: designSize,
      overviewBounds: overviewBounds,
      zones: const [],
    );
  }

  ParkingMapConfig withApiSlots(List<SlotEntity> apiSlots) {
    final groupedSlots = <String, List<SlotEntity>>{};
    final zoneRegionKeys = <String, String>{};
    final zoneLabels = <String, String>{};
    final fallbackSlots = <SlotEntity>[];

    for (final slot in apiSlots) {
      final zoneKey = slot.zoneId.toString();
      final regionKey = _normalizeDirectionId(slot.zoneDirection);
      if (_zoneBlueprintById.containsKey(regionKey)) {
        groupedSlots.putIfAbsent(zoneKey, () => <SlotEntity>[]).add(slot);
        zoneRegionKeys.putIfAbsent(zoneKey, () => regionKey);
        zoneLabels.putIfAbsent(
          zoneKey,
          () => slot.zoneName.trim().isEmpty
              ? 'Zone ${slot.zoneId}'
              : slot.zoneName,
        );
      } else {
        fallbackSlots.add(slot);
      }
    }

    final generatedZones = <ParkingZoneConfig>[];

    for (final blueprint in _zoneBlueprints) {
      final matchingZoneKeys = zoneRegionKeys.entries
          .where((entry) => entry.value == blueprint.id)
          .map((entry) => entry.key)
          .toList(growable: false);
      final layoutSlots = matchingZoneKeys
          .expand((zoneKey) => groupedSlots[zoneKey] ?? const <SlotEntity>[])
          .toList(growable: false);

      for (final zoneKey in matchingZoneKeys) {
        final zoneSlots = groupedSlots[zoneKey];
        if (zoneSlots == null || zoneSlots.isEmpty) {
          continue;
        }

        zoneSlots.sort(_compareSlots);
        generatedZones.add(
          _buildZoneFromBlueprint(
            blueprint,
            zoneSlots,
            layoutReferenceSlots: layoutSlots,
            zoneId: zoneKey,
            zoneName: zoneLabels[zoneKey] ?? blueprint.name,
          ),
        );
      }
    }

    if (fallbackSlots.isNotEmpty) {
      fallbackSlots.sort(_compareSlotsByZoneThenCode);
      generatedZones.add(_buildFallbackZone(fallbackSlots));
    }

    final maxBottom = generatedZones.fold<double>(
      overviewBounds.bottom,
      (current, zone) => math.max(current, zone.focusBounds.bottom),
    );
    final nextHeight = maxBottom > overviewBounds.bottom
        ? maxBottom + 96
        : designSize.height;

    return ParkingMapConfig(
      yardId: yardId,
      yardName: yardName,
      yardAddress: yardAddress,
      designSize: Size(designSize.width, nextHeight),
      overviewBounds: Rect.fromLTWH(
        overviewBounds.left,
        overviewBounds.top,
        overviewBounds.width,
        nextHeight - overviewBounds.top - 12,
      ),
      zones: generatedZones,
    );
  }

  static const primary = ParkingMapConfig(
    yardId: 'static-yard-1',
    yardName: 'Ford Parking',
    yardAddress: 'Custom parking map',
    designSize: Size(1000, 1600),
    overviewBounds: Rect.fromLTWH(18, 92, 918, 1504),
    zones: [],
  );
}

int _compareSlots(SlotEntity a, SlotEntity b) {
  final aParts = _slotCodeParts(a.slotCode);
  final bParts = _slotCodeParts(b.slotCode);

  final prefixCompare = aParts.prefix.compareTo(bParts.prefix);
  if (prefixCompare != 0) {
    return prefixCompare;
  }

  final numberCompare = aParts.number.compareTo(bParts.number);
  if (numberCompare != 0) {
    return numberCompare;
  }

  final suffixCompare = aParts.suffix.compareTo(bParts.suffix);
  if (suffixCompare != 0) {
    return suffixCompare;
  }

  return a.id.compareTo(b.id);
}

int _compareSlotsByZoneThenCode(SlotEntity a, SlotEntity b) {
  final zoneCompare = a.zoneName.trim().toLowerCase().compareTo(
    b.zoneName.trim().toLowerCase(),
  );
  if (zoneCompare != 0) {
    return zoneCompare;
  }

  return _compareSlots(a, b);
}

_SlotCodeParts _slotCodeParts(String value) {
  final normalized = value.trim().toLowerCase();
  final match = RegExp(r'^([a-z-]*)(\d+)?(.*)$').firstMatch(normalized);

  if (match == null) {
    return _SlotCodeParts(prefix: normalized, number: -1, suffix: '');
  }

  return _SlotCodeParts(
    prefix: (match.group(1) ?? '').trim(),
    number: int.tryParse(match.group(2) ?? '') ?? -1,
    suffix: (match.group(3) ?? '').trim(),
  );
}

String _normalizeDirectionId(String? value) {
  final normalized = value?.trim().toLowerCase() ?? '';
  switch (normalized) {
    case 'north':
      return 'north';
    case 'east':
      return 'east';
    case 'west':
      return 'west';
    case 'south':
      return 'south';
    case 'middle':
      return 'middle';
    default:
      return _fallbackZoneId;
  }
}

class _SlotCodeParts {
  const _SlotCodeParts({
    required this.prefix,
    required this.number,
    required this.suffix,
  });

  final String prefix;
  final int number;
  final String suffix;
}

class ParkingZoneConfig {
  final String id;
  final String name;
  final String layoutKey;
  final Rect tapBounds;
  final Rect focusBounds;
  final double focusScaleMultiplier;
  final List<ParkingSlotConfig> slots;

  const ParkingZoneConfig({
    required this.id,
    required this.name,
    required this.layoutKey,
    required this.tapBounds,
    required this.focusBounds,
    this.focusScaleMultiplier = 1,
    required this.slots,
  });
}

class ParkingSlotConfig {
  final SlotEntity slot;
  final Rect rect;
  final double rotation;

  const ParkingSlotConfig({
    required this.slot,
    required this.rect,
    this.rotation = 0,
  });
}

Path buildZoneInteractionPath({required ParkingZoneConfig zone}) {
  switch (zone.layoutKey) {
    case 'north':
      return Path()..addRRect(
        RRect.fromRectAndRadius(zone.tapBounds, const Radius.circular(28)),
      );
    case 'east':
      return Path()..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(842, 170, 78, 736),
          const Radius.circular(22),
        ),
      );
    case 'west':
      return Path()..addRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(28, 170, 126, 1240),
          const Radius.circular(22),
        ),
      );
    case 'middle':
      final slotBounds = _slotBoundsForZone(zone);
      final interactionRect = slotBounds?.inflate(20) ?? zone.tapBounds;
      return Path()..addRRect(
        RRect.fromRectAndRadius(interactionRect, const Radius.circular(28)),
      );
    case 'south':
      return _buildSouthInteractionPath();
    default:
      return Path()..addRRect(
        RRect.fromRectAndRadius(zone.tapBounds, const Radius.circular(24)),
      );
  }
}

const String _fallbackZoneId = 'additional';

const List<_ParkingZoneBlueprint> _zoneBlueprints = [
  _ParkingZoneBlueprint(
    id: 'north',
    name: 'North',
    tapBounds: Rect.fromLTWH(124, 86, 768, 118),
    focusBounds: Rect.fromLTWH(108, 92, 792, 152),
    focusScaleMultiplier: 1.18,
    slotBounds: Rect.fromLTWH(136, 106, 744, 70),
    preferredColumns: 1,
    preferredSlotWidth: 26,
    preferredSlotHeight: 68,
    columnGap: 2,
    rowGap: 2,
    forceSingleRow: true,
  ),
  _ParkingZoneBlueprint(
    id: 'west',
    name: 'West',
    tapBounds: Rect.fromLTWH(28, 170, 122, 1240),
    focusBounds: Rect.fromLTWH(20, 148, 182, 1286),
    focusScaleMultiplier: 2.1,
    slotBounds: Rect.fromLTWH(42, 206, 94, 1176),
    preferredColumns: 4,
    preferredSlotWidth: 20,
    preferredSlotHeight: 18,
    columnGap: 4,
    rowGap: 4,
  ),
  _ParkingZoneBlueprint(
    id: 'east',
    name: 'East',
    tapBounds: Rect.fromLTWH(842, 170, 78, 736),
    focusBounds: Rect.fromLTWH(826, 148, 110, 784),
    focusScaleMultiplier: 2.0,
    slotBounds: Rect.fromLTWH(854, 206, 54, 652),
    preferredColumns: 3,
    preferredSlotWidth: 15,
    preferredSlotHeight: 16,
    columnGap: 4,
    rowGap: 4,
  ),
  _ParkingZoneBlueprint(
    id: 'middle',
    name: 'Middle',
    tapBounds: Rect.fromLTWH(160, 284, 710, 470),
    focusBounds: Rect.fromLTWH(138, 268, 752, 520),
    focusScaleMultiplier: 1.03,
    slotBounds: Rect.fromLTWH(182, 314, 666, 410),
    preferredColumns: 8,
    preferredSlotWidth: 34,
    preferredSlotHeight: 28,
    columnGap: 6,
    rowGap: 6,
  ),
  _ParkingZoneBlueprint(
    id: 'south',
    name: 'South',
    tapBounds: Rect.fromLTWH(28, 954, 878, 540),
    focusBounds: Rect.fromLTWH(18, 932, 906, 590),
    focusScaleMultiplier: 2.1,
    slotBounds: Rect.fromLTWH(42, 996, 848, 494),
    preferredColumns: 13,
    preferredSlotWidth: 20,
    preferredSlotHeight: 24,
    columnGap: 4,
    rowGap: 4,
  ),
];

final Map<String, _ParkingZoneBlueprint> _zoneBlueprintById = {
  for (final blueprint in _zoneBlueprints) blueprint.id: blueprint,
};

ParkingZoneConfig _buildZoneFromBlueprint(
  _ParkingZoneBlueprint blueprint,
  List<SlotEntity> slots, {
  List<SlotEntity>? layoutReferenceSlots,
  required String zoneId,
  required String zoneName,
}) {
  final slotConfigs = blueprint.id == 'south'
      ? _buildCurvedSouthSlotConfigsFromCoordinates(
              slots: slots,
              blueprint: blueprint,
            ) ??
            _buildCurvedSouthSlotConfigs(slots: slots, blueprint: blueprint)
      : _usesHorizontalSideLayout(blueprint.id)
      ? _buildLinearSlotConfigs(slots: slots, blueprint: blueprint)
      : _buildSlotConfigsFromCoordinates(
              slots: slots,
              zoneBlueprint: blueprint,
              layoutReferenceSlots: layoutReferenceSlots,
            ) ??
            _buildLinearSlotConfigs(slots: slots, blueprint: blueprint);

  return ParkingZoneConfig(
    id: zoneId,
    name: zoneName,
    layoutKey: blueprint.id,
    tapBounds: blueprint.tapBounds,
    focusBounds: blueprint.focusBounds,
    focusScaleMultiplier: blueprint.focusScaleMultiplier,
    slots: slotConfigs,
  );
}

bool _usesHorizontalSideLayout(String zoneId) {
  return zoneId == 'west' || zoneId == 'east';
}

List<ParkingSlotConfig> _buildLinearSlotConfigs({
  required List<SlotEntity> slots,
  required _ParkingZoneBlueprint blueprint,
}) {
  final slotRects = _buildSlotRects(
    slotCount: slots.length,
    slotBounds: blueprint.slotBounds,
    preferredColumns: blueprint.preferredColumns,
    preferredSlotWidth: blueprint.preferredSlotWidth,
    preferredSlotHeight: blueprint.preferredSlotHeight,
    columnGap: blueprint.columnGap,
    rowGap: blueprint.rowGap,
    forceSingleRow: blueprint.forceSingleRow,
    alignTop: _usesHorizontalSideLayout(blueprint.id),
  );

  return List<ParkingSlotConfig>.generate(
    slots.length,
    (index) => ParkingSlotConfig(slot: slots[index], rect: slotRects[index]),
    growable: false,
  );
}

List<ParkingSlotConfig>? _buildSlotConfigsFromCoordinates({
  required List<SlotEntity> slots,
  required _ParkingZoneBlueprint zoneBlueprint,
  List<SlotEntity>? layoutReferenceSlots,
}) {
  if (slots.isEmpty || !slots.every(_hasExplicitCoordinates)) {
    return null;
  }

  final coordinateReferenceSlots =
      layoutReferenceSlots != null &&
          layoutReferenceSlots.every(_hasExplicitCoordinates)
      ? layoutReferenceSlots
      : slots;
  final isSideZone = zoneBlueprint.id == 'west' || zoneBlueprint.id == 'east';
  final minRow = coordinateReferenceSlots.fold<int>(
    coordinateReferenceSlots.first.row!,
    (current, slot) => math.min(current, slot.row!),
  );
  final maxRow = coordinateReferenceSlots.fold<int>(
    coordinateReferenceSlots.first.row!,
    (current, slot) => math.max(current, slot.row!),
  );
  final minColumn = coordinateReferenceSlots.fold<int>(
    coordinateReferenceSlots.first.column!,
    (current, slot) => math.min(current, slot.column!),
  );
  final maxColumn = coordinateReferenceSlots.fold<int>(
    coordinateReferenceSlots.first.column!,
    (current, slot) => math.max(current, slot.column!),
  );
  final rows = math.max(
    1,
    isSideZone ? (maxColumn - minColumn) + 1 : (maxRow - minRow) + 1,
  );
  final columns = math.max(
    1,
    isSideZone ? (maxRow - minRow) + 1 : (maxColumn - minColumn) + 1,
  );

  final computedWidth =
      (zoneBlueprint.slotBounds.width -
          ((columns - 1) * zoneBlueprint.columnGap)) /
      columns;
  final computedHeight =
      (zoneBlueprint.slotBounds.height - ((rows - 1) * zoneBlueprint.rowGap)) /
      rows;
  final slotWidth = math.min(
    zoneBlueprint.preferredSlotWidth,
    math.max(1.0, computedWidth),
  );
  final slotHeight = math.min(
    zoneBlueprint.preferredSlotHeight,
    math.max(1.0, computedHeight),
  );

  return slots
      .map((slot) {
        final xIndex = isSideZone
            ? slot.row! - minRow
            : slot.column! - minColumn;
        final yIndex = isSideZone
            ? slot.column! - minColumn
            : slot.row! - minRow;

        return ParkingSlotConfig(
          slot: slot,
          rect: Rect.fromLTWH(
            zoneBlueprint.slotBounds.left +
                (xIndex * (slotWidth + zoneBlueprint.columnGap)),
            zoneBlueprint.slotBounds.top +
                (yIndex * (slotHeight + zoneBlueprint.rowGap)),
            slotWidth,
            slotHeight,
          ),
        );
      })
      .toList(growable: false);
}

bool _hasExplicitCoordinates(SlotEntity slot) {
  return (slot.row ?? -1) >= 0 && (slot.column ?? -1) >= 0;
}

List<ParkingSlotConfig>? _buildCurvedSouthSlotConfigsFromCoordinates({
  required List<SlotEntity> slots,
  required _ParkingZoneBlueprint blueprint,
}) {
  if (slots.isEmpty || !slots.every(_hasExplicitCoordinates)) {
    return null;
  }

  const baseStartTrim = 32.0;
  const curbPadding = 12.0;
  const laneGap = 6.0;

  final baseCurveSamples = _buildSouthCurveSamples(samplesPerSegment: 160);
  final slotWidth = blueprint.preferredSlotWidth;
  final slotHeight = blueprint.preferredSlotHeight;
  final laneStep = slotHeight + laneGap;
  final maxRow = slots.fold<int>(
    0,
    (current, slot) => math.max(current, slot.row!),
  );

  final laneSpecs = List<_SouthLaneCoordinateSpec>.generate(maxRow + 1, (
    laneIndex,
  ) {
    final offsetFromCurve =
        curbPadding + (slotHeight / 2) + (laneIndex * laneStep);
    final curveSamples = _buildOffsetCurveSamples(
      baseCurveSamples,
      offsetFromCurve,
    );
    return _SouthLaneCoordinateSpec(
      curveSamples: curveSamples,
      startTrim: baseStartTrim + (laneIndex * 12.0),
      endTrim: 36.0 + (laneIndex * 14.0),
    );
  }, growable: false);

  return slots
      .map((slot) {
        // API row 0 should render on the top-most south lane.
        final lane = laneSpecs[maxRow - slot.row!];
        final preferredDistance =
            lane.startTrim +
            (slotWidth / 2) +
            (slot.column! * (slotWidth + blueprint.columnGap));
        final maxDistance = math.max(
          lane.startTrim + (slotWidth / 2),
          lane.curveSamples.last.distance - lane.endTrim - (slotWidth / 2),
        );
        final distanceAlongCurve = preferredDistance.clamp(
          lane.startTrim + (slotWidth / 2),
          maxDistance,
        );
        final position = _curvePositionAtDistance(
          lane.curveSamples,
          distanceAlongCurve,
        );

        return ParkingSlotConfig(
          slot: slot,
          rect: Rect.fromCenter(
            center: position.point,
            width: slotWidth,
            height: slotHeight,
          ),
          rotation: math.atan2(position.tangent.dy, position.tangent.dx),
        );
      })
      .toList(growable: false);
}

ParkingZoneConfig _buildFallbackZone(List<SlotEntity> slots) {
  const preferredColumns = 12;
  const preferredSlotWidth = 24.0;
  const preferredSlotHeight = 34.0;
  const columnGap = 6.0;
  const rowGap = 6.0;

  final slotBounds = const Rect.fromLTWH(238, 758, 468, 240);
  final slotRects = _buildSlotRects(
    slotCount: slots.length,
    slotBounds: slotBounds,
    preferredColumns: preferredColumns,
    preferredSlotWidth: preferredSlotWidth,
    preferredSlotHeight: preferredSlotHeight,
    columnGap: columnGap,
    rowGap: rowGap,
    forceSingleRow: false,
  );

  final bottom = slotRects.isEmpty
      ? slotBounds.bottom
      : slotRects.last.bottom + 24;
  final tapBounds = Rect.fromLTWH(
    slotBounds.left - 24,
    slotBounds.top - 24,
    slotBounds.width + 48,
    bottom - slotBounds.top + 48,
  );
  final focusBounds = Rect.fromLTWH(
    tapBounds.left - 12,
    tapBounds.top - 12,
    tapBounds.width + 24,
    tapBounds.height + 24,
  );

  return ParkingZoneConfig(
    id: _fallbackZoneId,
    name: 'Additional',
    layoutKey: _fallbackZoneId,
    tapBounds: tapBounds,
    focusBounds: focusBounds,
    focusScaleMultiplier: 1.08,
    slots: List<ParkingSlotConfig>.generate(
      slots.length,
      (index) => ParkingSlotConfig(slot: slots[index], rect: slotRects[index]),
      growable: false,
    ),
  );
}

Rect? _slotBoundsForZone(ParkingZoneConfig zone) {
  if (zone.slots.isEmpty) {
    return null;
  }

  var bounds = zone.slots.first.rect;
  for (final slot in zone.slots.skip(1)) {
    bounds = bounds.expandToInclude(slot.rect);
  }

  return bounds;
}

List<Rect> _buildSlotRects({
  required int slotCount,
  required Rect slotBounds,
  required int preferredColumns,
  required double preferredSlotWidth,
  required double preferredSlotHeight,
  required double columnGap,
  required double rowGap,
  required bool forceSingleRow,
  bool alignTop = false,
}) {
  if (slotCount == 0) {
    return const [];
  }

  final columns = forceSingleRow
      ? slotCount
      : math.min(slotCount, math.max(1, preferredColumns));
  final rows = (slotCount / columns).ceil();

  final computedWidth =
      (slotBounds.width - ((columns - 1) * columnGap)) / columns;
  final computedHeight = (slotBounds.height - ((rows - 1) * rowGap)) / rows;
  final slotWidth = math.min(preferredSlotWidth, math.max(1.0, computedWidth));
  final slotHeight = math.min(
    preferredSlotHeight,
    math.max(1.0, computedHeight),
  );

  final gridWidth = (columns * slotWidth) + ((columns - 1) * columnGap);
  final gridHeight = (rows * slotHeight) + ((rows - 1) * rowGap);
  final startX = slotBounds.left + ((slotBounds.width - gridWidth) / 2);
  final startY = alignTop
      ? slotBounds.top
      : slotBounds.top + ((slotBounds.height - gridHeight) / 2);

  return List<Rect>.generate(slotCount, (index) {
    final row = index ~/ columns;
    final column = index % columns;

    return Rect.fromLTWH(
      startX + (column * (slotWidth + columnGap)),
      startY + (row * (slotHeight + rowGap)),
      slotWidth,
      slotHeight,
    );
  }, growable: false);
}

List<ParkingSlotConfig> _buildCurvedSouthSlotConfigs({
  required List<SlotEntity> slots,
  required _ParkingZoneBlueprint blueprint,
}) {
  if (slots.isEmpty) {
    return const [];
  }

  final baseCurveSamples = _buildSouthCurveSamples(samplesPerSegment: 160);
  final slotWidth = blueprint.preferredSlotWidth;
  final slotHeight = blueprint.preferredSlotHeight;
  final laneSpecs = _buildSouthLaneSpecs(
    slotCount: slots.length,
    baseCurveSamples: baseCurveSamples,
    slotWidth: slotWidth,
    slotHeight: slotHeight,
    alongGap: blueprint.columnGap,
  );

  final configs = <ParkingSlotConfig>[];
  var slotIndex = 0;

  for (final lane in laneSpecs) {
    if (lane.count == 0) {
      continue;
    }

    final leadingGap = 0.0;
    var distanceAlongCurve = lane.startTrim + leadingGap + (slotWidth / 2);

    for (
      var index = 0;
      index < lane.count && slotIndex < slots.length;
      index++
    ) {
      final position = _curvePositionAtDistance(
        lane.curveSamples,
        distanceAlongCurve,
      );
      final rect = Rect.fromCenter(
        center: position.point,
        width: slotWidth,
        height: slotHeight,
      );

      configs.add(
        ParkingSlotConfig(
          slot: slots[slotIndex],
          rect: rect,
          rotation: math.atan2(position.tangent.dy, position.tangent.dx),
        ),
      );

      slotIndex++;
      distanceAlongCurve += slotWidth + blueprint.columnGap;
    }
  }

  return configs;
}

double _southRoadRightEdgeForY(double y) {
  if (y <= 980) {
    return 920;
  }
  if (y >= 1510) {
    return 120;
  }

  var bestDistance = double.infinity;
  var bestX = 920.0;

  for (final segment in _southRoadCurveSegments) {
    for (var step = 0; step <= 240; step++) {
      final t = step / 240;
      final point = segment.pointAt(t);
      final distance = (point.dy - y).abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        bestX = point.dx;
      }
    }
  }

  return bestX;
}

List<_CurveSample> _buildSouthCurveSamples({required int samplesPerSegment}) {
  final points = <Offset>[];

  for (
    var segmentIndex = _southRoadCurveSegments.length - 1;
    segmentIndex >= 0;
    segmentIndex--
  ) {
    final segment = _southRoadCurveSegments[segmentIndex];
    for (var step = 0; step <= samplesPerSegment; step++) {
      if (segmentIndex != _southRoadCurveSegments.length - 1 && step == 0) {
        continue;
      }

      final t = 1 - (step / samplesPerSegment);
      points.add(segment.pointAt(t));
    }
  }

  return _curveSamplesFromPoints(points);
}

List<_SouthLaneSpec> _buildSouthLaneSpecs({
  required int slotCount,
  required List<_CurveSample> baseCurveSamples,
  required double slotWidth,
  required double slotHeight,
  required double alongGap,
}) {
  const baseStartTrim = 32.0;
  const curbPadding = 12.0;
  const laneGap = 6.0;
  final laneStep = slotHeight + laneGap;
  late List<_SouthLaneSpec> laneSpecs;

  for (var laneCount = 4; laneCount <= 7; laneCount++) {
    laneSpecs = List<_SouthLaneSpec>.generate(laneCount, (laneIndex) {
      final offsetFromCurve =
          curbPadding + (slotHeight / 2) + (laneIndex * laneStep);
      final curveSamples = _buildOffsetCurveSamples(
        baseCurveSamples,
        offsetFromCurve,
      );
      final curveLength = curveSamples.last.distance;
      final startTrim = baseStartTrim + (laneIndex * 12.0);
      final endTrim = 36.0 + (laneIndex * 14.0);
      final usableLength = math.max(0.0, curveLength - startTrim - endTrim);
      final capacity = math.max(
        1,
        ((usableLength + alongGap) / (slotWidth + alongGap)).floor(),
      );

      return _SouthLaneSpec(
        curveSamples: curveSamples,
        startTrim: startTrim,
        endTrim: endTrim,
        capacity: capacity,
        count: 0,
      );
    }, growable: false);

    final totalCapacity = laneSpecs.fold<int>(
      0,
      (sum, lane) => sum + lane.capacity,
    );
    if (totalCapacity >= slotCount) {
      break;
    }
  }

  final laneCounts = _buildSouthLaneCounts(
    slotCount: slotCount,
    capacities: laneSpecs.map((lane) => lane.capacity).toList(growable: false),
  );

  return List<_SouthLaneSpec>.generate(
    laneSpecs.length,
    (index) => _SouthLaneSpec(
      curveSamples: laneSpecs[index].curveSamples,
      startTrim: laneSpecs[index].startTrim,
      endTrim: laneSpecs[index].endTrim,
      capacity: laneSpecs[index].capacity,
      count: laneCounts[index],
    ),
    growable: false,
  );
}

List<_CurveSample> _buildOffsetCurveSamples(
  List<_CurveSample> baseCurveSamples,
  double offsetFromCurve,
) {
  final points = <Offset>[];
  for (final sample in baseCurveSamples) {
    final inwardNormal = _inwardNormalForCurvePoint(
      sample.point,
      sample.tangent,
    );
    points.add(sample.point + (inwardNormal * offsetFromCurve));
  }

  return _curveSamplesFromPoints(points);
}

List<_CurveSample> _curveSamplesFromPoints(List<Offset> points) {
  final samples = <_CurveSample>[];
  var distance = 0.0;

  for (var index = 0; index < points.length; index++) {
    if (index > 0) {
      distance += (points[index] - points[index - 1]).distance;
    }

    final previous = index == 0 ? points[index] : points[index - 1];
    final next = index == points.length - 1 ? points[index] : points[index + 1];
    final tangent = _normalizeOffset(next - previous);

    samples.add(
      _CurveSample(point: points[index], tangent: tangent, distance: distance),
    );
  }

  return samples;
}

List<int> _buildSouthLaneCounts({
  required int slotCount,
  required List<int> capacities,
}) {
  final laneCounts = List<int>.filled(capacities.length, 0, growable: false);
  final weights = List<double>.generate(
    capacities.length,
    (index) => capacities[index] * (1.08 - (index * 0.06)),
    growable: false,
  );
  final totalWeight = weights.fold<double>(0, (sum, value) => sum + value);
  final targets = List<double>.generate(
    capacities.length,
    (index) => (slotCount * weights[index]) / totalWeight,
    growable: false,
  );

  var remainingSlots = slotCount;
  while (remainingSlots > 0) {
    var selectedLane = -1;
    var bestScore = double.negativeInfinity;

    for (var index = 0; index < capacities.length; index++) {
      if (laneCounts[index] >= capacities[index]) {
        continue;
      }

      final score = targets[index] - laneCounts[index];
      if (score > bestScore) {
        bestScore = score;
        selectedLane = index;
      }
    }

    if (selectedLane == -1) {
      break;
    }

    laneCounts[selectedLane]++;
    remainingSlots--;
  }

  return laneCounts;
}

_CurvePosition _curvePositionAtDistance(
  List<_CurveSample> samples,
  double distance,
) {
  if (distance <= 0) {
    return _CurvePosition(
      point: samples.first.point,
      tangent: samples.first.tangent,
    );
  }
  if (distance >= samples.last.distance) {
    return _CurvePosition(
      point: samples.last.point,
      tangent: samples.last.tangent,
    );
  }

  for (var index = 0; index < samples.length - 1; index++) {
    final start = samples[index];
    final end = samples[index + 1];
    if (distance < start.distance || distance > end.distance) {
      continue;
    }

    final segmentDistance = end.distance - start.distance;
    final t = segmentDistance <= 0
        ? 0.0
        : (distance - start.distance) / segmentDistance;

    return _CurvePosition(
      point: Offset.lerp(start.point, end.point, t)!,
      tangent: _normalizeOffset(Offset.lerp(start.tangent, end.tangent, t)!),
    );
  }

  return _CurvePosition(
    point: samples.last.point,
    tangent: samples.last.tangent,
  );
}

Offset _inwardNormalForCurvePoint(Offset point, Offset tangent) {
  final candidateA = _normalizeOffset(Offset(tangent.dy, -tangent.dx));
  final candidateB = Offset(-candidateA.dx, -candidateA.dy);
  final probeA = point + (candidateA * 24);

  if (probeA.dx <= _southRoadRightEdgeForY(probeA.dy)) {
    return candidateA;
  }

  return candidateB;
}

Offset _normalizeOffset(Offset value) {
  final distance = value.distance;
  if (distance == 0) {
    return const Offset(0, -1);
  }

  return Offset(value.dx / distance, value.dy / distance);
}

Path _buildSouthInteractionPath() {
  return Path()
    ..moveTo(910, 998)
    ..quadraticBezierTo(905, 1102, 820, 1175)
    ..quadraticBezierTo(690, 1310, 540, 1375)
    ..quadraticBezierTo(330, 1465, 120, 1510)
    ..lineTo(146, 1452)
    ..quadraticBezierTo(322, 1412, 484, 1340)
    ..quadraticBezierTo(650, 1264, 772, 1178)
    ..quadraticBezierTo(842, 1124, 846, 1054)
    ..close();
}

const List<_QuadraticCurveSegment> _southRoadCurveSegments = [
  _QuadraticCurveSegment(
    start: Offset(920, 980),
    control: Offset(905, 1100),
    end: Offset(820, 1175),
  ),
  _QuadraticCurveSegment(
    start: Offset(820, 1175),
    control: Offset(690, 1310),
    end: Offset(540, 1375),
  ),
  _QuadraticCurveSegment(
    start: Offset(540, 1375),
    control: Offset(330, 1465),
    end: Offset(120, 1510),
  ),
];

class _ParkingZoneBlueprint {
  const _ParkingZoneBlueprint({
    required this.id,
    required this.name,
    required this.tapBounds,
    required this.focusBounds,
    required this.focusScaleMultiplier,
    required this.slotBounds,
    required this.preferredColumns,
    required this.preferredSlotWidth,
    required this.preferredSlotHeight,
    required this.columnGap,
    required this.rowGap,
    this.forceSingleRow = false,
  });

  final String id;
  final String name;
  final Rect tapBounds;
  final Rect focusBounds;
  final double focusScaleMultiplier;
  final Rect slotBounds;
  final int preferredColumns;
  final double preferredSlotWidth;
  final double preferredSlotHeight;
  final double columnGap;
  final double rowGap;
  final bool forceSingleRow;
}

class _QuadraticCurveSegment {
  const _QuadraticCurveSegment({
    required this.start,
    required this.control,
    required this.end,
  });

  final Offset start;
  final Offset control;
  final Offset end;

  Offset pointAt(double t) {
    final inverseT = 1 - t;
    final x =
        (inverseT * inverseT * start.dx) +
        (2 * inverseT * t * control.dx) +
        (t * t * end.dx);
    final y =
        (inverseT * inverseT * start.dy) +
        (2 * inverseT * t * control.dy) +
        (t * t * end.dy);
    return Offset(x, y);
  }
}

class _CurveSample {
  const _CurveSample({
    required this.point,
    required this.tangent,
    required this.distance,
  });

  final Offset point;
  final Offset tangent;
  final double distance;
}

class _CurvePosition {
  const _CurvePosition({required this.point, required this.tangent});

  final Offset point;
  final Offset tangent;
}

class _SouthLaneSpec {
  const _SouthLaneSpec({
    required this.curveSamples,
    required this.startTrim,
    required this.endTrim,
    required this.capacity,
    required this.count,
  });

  final List<_CurveSample> curveSamples;
  final double startTrim;
  final double endTrim;
  final int capacity;
  final int count;
}

class _SouthLaneCoordinateSpec {
  const _SouthLaneCoordinateSpec({
    required this.curveSamples,
    required this.startTrim,
    required this.endTrim,
  });

  final List<_CurveSample> curveSamples;
  final double startTrim;
  final double endTrim;
}
