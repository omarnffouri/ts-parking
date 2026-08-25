import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/zone_model.dart';

void main() {
  test('fromJson parses all fields', () {
    final zone = ZoneModel.fromJson({
      'id': 6,
      'yard_id': 2,
      'name': 'Zone B',
      'description': 'Large trucks',
      'capacity': 50,
      'status': 'active',
      'slots_count': 45,
    });

    expect(zone.id, '6');
    expect(zone.yardId, '2');
    expect(zone.name, 'Zone B');
    expect(zone.description, 'Large trucks');
    expect(zone.capacity, 50);
    expect(zone.status, 'active');
    expect(zone.slotsCount, 45);
  });

  test('fromJson handles null fields', () {
    final zone = ZoneModel.fromJson({'id': 1});

    expect(zone.name, '');
    expect(zone.capacity, 0);
    expect(zone.slotsCount, 0);
  });
}
