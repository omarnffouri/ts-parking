import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/vehicle_type_model.dart';

void main() {
  test('fromJson parses all fields', () {
    final type = VehicleTypeModel.fromJson({
      'id': 1,
      'name': 'Truck',
      'price': '150.00',
    });

    expect(type.id, 1);
    expect(type.name, 'Truck');
    expect(type.price, 150.0);
  });

  test('fromJson handles null id', () {
    final type = VehicleTypeModel.fromJson({
      'id': null,
      'name': null,
      'price': null,
    });

    expect(type.id, 0);
    expect(type.name, '');
    expect(type.price, 0.0);
  });
}
