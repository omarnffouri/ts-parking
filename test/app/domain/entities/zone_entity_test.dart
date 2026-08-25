import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/domain/entities/zone_entity.dart';

void main() {
  group('ZoneEntity', () {
    const zone = ZoneEntity(
      id: '4',
      yardId: '4',
      name: 'South',
      description: null,
      capacity: 150,
      status: 'active',
      slotsCount: 150,
    );

    test('has correct fields', () {
      expect(zone.id, equals('4'));
      expect(zone.yardId, equals('4'));
      expect(zone.name, equals('South'));
      expect(zone.capacity, equals(150));
      expect(zone.status, equals('active'));
      expect(zone.slotsCount, equals(150));
    });

    test('equality compares all fields', () {
      const sameZone = ZoneEntity(
        id: '4',
        yardId: '4',
        name: 'South',
        description: null,
        capacity: 150,
        status: 'active',
        slotsCount: 150,
      );

      expect(zone, equals(sameZone));
    });

    test('defaults work for optional fields', () {
      const minimal = ZoneEntity(id: '1', name: 'Test');

      expect(minimal.yardId, equals(''));
      expect(minimal.description, isNull);
      expect(minimal.capacity, equals(0));
      expect(minimal.status, equals(''));
      expect(minimal.slotsCount, equals(0));
    });
  });
}
