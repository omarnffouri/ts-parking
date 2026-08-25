import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/enums/parking_vehicle_type.dart';
import 'package:ts_parking/app/domain/entities/vehicle_entity.dart';

void main() {
  test('equatable compares by value', () {
    final now = DateTime.now();
    final a = VehicleEntity(
      id: '1',
      userId: '7',
      vehicleTypeId: 1,
      vehicleType: ParkingVehicleType.truck,
      vehicleTypeName: 'Truck',
      licensePlate: 'TR123',
      createdAt: now,
    );
    final b = VehicleEntity(
      id: '1',
      userId: '7',
      vehicleTypeId: 1,
      vehicleType: ParkingVehicleType.truck,
      vehicleTypeName: 'Truck',
      licensePlate: 'TR123',
      createdAt: now,
    );

    expect(a, equals(b));
  });
}
