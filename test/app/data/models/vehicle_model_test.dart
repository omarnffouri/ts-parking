import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/vehicle_model.dart';
import 'package:ts_parking/app/core/enums/parking_vehicle_type.dart';

void main() {
  test('fromJson parses all fields with nested vehicle_type', () {
    final vehicle = VehicleModel.fromJson({
      'id': 7,
      'user_id': 3,
      'vehicle_type_id': 1,
      'license_plate': 'TR123',
      'identifier': 'VIN123',
      'status': 'active',
      'created_at': '2026-04-01T00:00:00.000000Z',
      'updated_at': '2026-04-02T00:00:00.000000Z',
      'vehicle_type': {'id': 1, 'name': 'Truck', 'price': '150.00'},
    });

    expect(vehicle.id, '7');
    expect(vehicle.userId, '3');
    expect(vehicle.vehicleTypeId, 1);
    expect(vehicle.licensePlate, 'TR123');
    expect(vehicle.identifier, 'VIN123');
    expect(vehicle.status, 'active');
    expect(vehicle.vehicleType, ParkingVehicleType.truck);
    expect(vehicle.vehicleTypeName, 'Truck');
    expect(vehicle.updatedAt, isNotNull);
  });

  test('fromJson handles null fields gracefully', () {
    final vehicle = VehicleModel.fromJson({
      'id': null,
      'user_id': null,
      'license_plate': null,
      'status': null,
      'created_at': null,
      'vehicle_type': null,
    });

    expect(vehicle.id, '');
    expect(vehicle.userId, '');
    expect(vehicle.licensePlate, '');
    expect(vehicle.status, 'active');
    expect(vehicle.vehicleType, ParkingVehicleType.unknown);
  });
}
