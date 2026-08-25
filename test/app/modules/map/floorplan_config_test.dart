import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';
import 'package:ts_parking/app/domain/entities/slot_entity.dart';
import 'package:ts_parking/app/modules/map/models/floorplan_config.dart';

void main() {
  test('primary map no longer contains the legacy top row right zone', () {
    expect(
      ParkingMapConfig.primary.zones.where(
        (zone) => zone.id == 'top_row_right',
      ),
      isEmpty,
    );
  });

  test('withoutSlots returns a map with no generated zones', () {
    expect(ParkingMapConfig.primary.withoutSlots().zones, isEmpty);
  });

  test('withApiSlots renders one zone per backend zone in blueprint order', () {
    final generated = ParkingMapConfig.primary.withApiSlots([
      _slot(id: 1, zoneId: 5, direction: 'north', code: 'N-02'),
      _slot(id: 2, zoneId: 3, direction: 'west', code: 'W-01'),
      _slot(id: 3, zoneId: 3, direction: 'west', code: 'W-02'),
    ]);

    expect(generated.zones.map((zone) => zone.id).toList(growable: false), [
      '5',
      '3',
    ]);
  });

  test('withApiSlots sorts slot codes naturally inside each zone', () {
    final generated = ParkingMapConfig.primary.withApiSlots([
      _slot(id: 1, zoneId: 3, direction: 'west', code: 'W-10'),
      _slot(id: 2, zoneId: 3, direction: 'west', code: 'W-02'),
      _slot(id: 3, zoneId: 3, direction: 'west', code: 'W-01'),
    ]);

    final westZone = generated.zones.singleWhere((zone) => zone.id == '3');

    expect(
      westZone.slots.map((slot) => slot.slot.slotCode).toList(growable: false),
      ['W-01', 'W-02', 'W-10'],
    );
  });

  test('withApiSlots keeps every slot inside its backend zone', () {
    final generated = ParkingMapConfig.primary.withApiSlots([
      _slot(id: 1, zoneId: 5, direction: 'north', code: 'N-01'),
      _slot(id: 2, zoneId: 3, direction: 'west', code: 'W-01'),
      _slot(id: 3, zoneId: 4, direction: 'south', code: 'S-01'),
      _slot(id: 4, zoneId: 6, direction: 'middle', code: 'B01'),
    ]);

    for (final zone in generated.zones) {
      expect(
        zone.slots.every((slot) => slot.slot.zoneId.toString() == zone.id),
        isTrue,
        reason: 'Zone ${zone.id} contains slots from another backend zone.',
      );
    }
  });

  test('withApiSlots preserves all slots for a large backend payload', () {
    final generated = ParkingMapConfig.primary.withApiSlots([
      ..._slotsForZone(zoneId: 5, direction: 'north', prefix: 'N-', count: 10),
      ..._slotsForZone(zoneId: 3, direction: 'west', prefix: 'W-', count: 150),
      ..._slotsForZone(zoneId: 4, direction: 'south', prefix: 'S-', count: 150),
      ..._slotsForZone(zoneId: 6, direction: 'middle', prefix: 'B', count: 80),
    ]);

    final renderedSlotCount = generated.zones
        .expand((zone) => zone.slots)
        .length;
    final zoneCounts = {
      for (final zone in generated.zones) zone.id: zone.slots.length,
    };

    expect(renderedSlotCount, 390);
    expect(zoneCounts['5'], 10);
    expect(zoneCounts['3'], 150);
    expect(zoneCounts['4'], 150);
    expect(zoneCounts['6'], 80);
  });

  test('south slots follow curved parking lanes', () {
    final generated = ParkingMapConfig.primary.withApiSlots(
      _slotsForZone(zoneId: 4, direction: 'south', prefix: 'S-', count: 150),
    );
    final southZone = generated.zones.singleWhere((zone) => zone.id == '4');
    final minLeft = southZone.slots
        .map((slot) => slot.rect.left)
        .reduce((a, b) => a < b ? a : b);
    final maxRight = southZone.slots
        .map((slot) => slot.rect.right)
        .reduce((a, b) => a > b ? a : b);
    final minTop = southZone.slots
        .map((slot) => slot.rect.top)
        .reduce((a, b) => a < b ? a : b);
    final maxBottom = southZone.slots
        .map((slot) => slot.rect.bottom)
        .reduce((a, b) => a > b ? a : b);
    final rotations = southZone.slots
        .map((slot) => slot.rotation)
        .toList(growable: false);
    final minRotation = rotations.reduce(math.min);
    final maxRotation = rotations.reduce(math.max);

    expect(minLeft, lessThan(160));
    expect(maxRight, greaterThan(850));
    expect(minTop, lessThan(1120));
    expect(maxBottom, greaterThan(1440));
    expect(maxRotation - minRotation, greaterThan(0.35));
  });

  test('south slots stay inside the curved yard boundary', () {
    final generated = ParkingMapConfig.primary.withApiSlots(
      _slotsForZone(zoneId: 4, direction: 'south', prefix: 'S-', count: 150),
    );
    final southZone = generated.zones.singleWhere((zone) => zone.id == '4');

    for (final slot in southZone.slots) {
      for (final corner in _rotatedCorners(slot)) {
        expect(
          corner.dx,
          greaterThanOrEqualTo(28),
          reason: '${slot.slot.slotCode} extends outside the left yard edge.',
        );
        expect(
          corner.dy,
          lessThanOrEqualTo(1510),
          reason: '${slot.slot.slotCode} extends below the yard edge.',
        );
        expect(
          corner.dx,
          lessThanOrEqualTo(_southCurveRightEdgeForY(corner.dy) - 4),
          reason: '${slot.slot.slotCode} extends outside the south yard curve.',
        );
      }
    }
  });

  test(
    'slots without a recognized direction fall through to the fallback section',
    () {
      final generated = ParkingMapConfig.primary.withApiSlots([
        _slot(
          id: 1,
          zoneId: 9,
          direction: null,
          zoneName: 'Mystery',
          code: 'E-01',
        ),
      ]);

      expect(generated.zones, hasLength(1));
      expect(generated.zones.single.id, 'additional');
      expect(generated.zones.single.slots.single.slot.zoneName, 'Mystery');
    },
  );
}

List<SlotEntity> _slotsForZone({
  required int zoneId,
  required String direction,
  required String prefix,
  required int count,
}) {
  return List<SlotEntity>.generate(
    count,
    (index) => _slot(
      id: index + 1,
      zoneId: zoneId,
      direction: direction,
      code: '$prefix${index + 1}',
    ),
    growable: false,
  );
}

SlotEntity _slot({
  required int id,
  required int zoneId,
  required String? direction,
  required String code,
  String? zoneName,
}) {
  return SlotEntity(
    id: id,
    zoneId: zoneId,
    slotCode: code,
    status: SlotStatus.available,
    backendStatus: 'available',
    vehicleTypeId: 1,
    vehicleTypeName: 'Truck',
    vehicleTypePrice: 150,
    zoneName: zoneName ?? direction ?? 'Zone $zoneId',
    zoneDirection: direction,
    zoneHorizontalCapacity: 0,
    zoneVerticalCapacity: 0,
    planId: 1,
    planName: 'standard',
    planPrice: 25,
    price: 25,
    priceBeforeDiscount: 25,
    discount: 0,
  );
}

double _southCurveRightEdgeForY(double y) {
  if (y <= 980) {
    return 920;
  }
  if (y >= 1510) {
    return 120;
  }

  const segments = [
    (920.0, 980.0, 905.0, 1100.0, 820.0, 1175.0),
    (820.0, 1175.0, 690.0, 1310.0, 540.0, 1375.0),
    (540.0, 1375.0, 330.0, 1465.0, 120.0, 1510.0),
  ];

  var bestDistance = double.infinity;
  var bestX = 920.0;

  for (final segment in segments) {
    for (var step = 0; step <= 240; step++) {
      final t = step / 240;
      final inverseT = 1 - t;
      final x =
          (inverseT * inverseT * segment.$1) +
          (2 * inverseT * t * segment.$3) +
          (t * t * segment.$5);
      final curveY =
          (inverseT * inverseT * segment.$2) +
          (2 * inverseT * t * segment.$4) +
          (t * t * segment.$6);
      final distance = (curveY - y).abs();

      if (distance < bestDistance) {
        bestDistance = distance;
        bestX = x;
      }
    }
  }

  return bestX;
}

List<Offset> _rotatedCorners(ParkingSlotConfig slot) {
  final center = slot.rect.center;
  final halfWidth = slot.rect.width / 2;
  final halfHeight = slot.rect.height / 2;
  final cosine = math.cos(slot.rotation);
  final sine = math.sin(slot.rotation);
  const corners = [Offset(-1, -1), Offset(1, -1), Offset(1, 1), Offset(-1, 1)];

  return corners
      .map((corner) {
        final localX = corner.dx * halfWidth;
        final localY = corner.dy * halfHeight;
        return Offset(
          center.dx + (localX * cosine) - (localY * sine),
          center.dy + (localX * sine) + (localY * cosine),
        );
      })
      .toList(growable: false);
}
