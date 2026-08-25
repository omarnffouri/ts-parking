import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/yard_model.dart';

void main() {
  test('fromJson parses all fields', () {
    final yard = YardModel.fromJson({
      'id': 1,
      'name': 'Ford Parking',
      'address': '12825 Ford Rd, Dearborn, MI 48126',
      'latitude': 42.3223,
      'longitude': -83.2358,
      'capacity_total': 100,
      'available_slots': 75,
      'status': 'approved',
      'image': 'https://example.com/yard.jpg',
    });

    expect(yard.id, '1');
    expect(yard.name, 'Ford Parking');
    expect(yard.address, '12825 Ford Rd, Dearborn, MI 48126');
    expect(yard.latitude, 42.3223);
    expect(yard.longitude, -83.2358);
    expect(yard.capacityTotal, 100);
    expect(yard.availableSlots, 75);
    expect(yard.status, 'approved');
    expect(yard.imageUrl, 'https://example.com/yard.jpg');
  });

  test('fromJson handles null/empty image', () {
    final yard = YardModel.fromJson({'id': 2, 'name': 'Test', 'image': ''});

    expect(yard.imageUrl, isNull);
  });

  test('fromJson handles all null fields', () {
    final yard = YardModel.fromJson({});

    expect(yard.name, '');
    expect(yard.latitude, 0.0);
    expect(yard.capacityTotal, 0);
  });
}
