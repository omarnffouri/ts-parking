import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/domain/entities/yard_entity.dart';

void main() {
  group('YardEntity', () {
    const yard = YardEntity(
      id: 'yard_1',
      name: 'Test Yard',
      address: '123 Main St',
      latitude: 24.7136,
      longitude: 46.6753,
      capacityTotal: 20,
      availableSlots: 15,
      status: 'approved',
    );

    test('latitude returns correct value', () {
      expect(yard.latitude, equals(24.7136));
    });

    test('longitude returns correct value', () {
      expect(yard.longitude, equals(46.6753));
    });

    test('equality compares all fields', () {
      const sameYard = YardEntity(
        id: 'yard_1',
        name: 'Test Yard',
        address: '123 Main St',
        latitude: 24.7136,
        longitude: 46.6753,
        capacityTotal: 20,
        availableSlots: 15,
        status: 'approved',
      );

      expect(yard, equals(sameYard));
    });
  });
}
