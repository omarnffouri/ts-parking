import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/domain/entities/vehicle_charge_entity.dart';

void main() {
  final now = DateTime.now();

  test('isUnpaid and isPaid return correct values', () {
    final unpaid = VehicleChargeEntity(
      id: 1,
      vehicleId: 7,
      periodFrom: now,
      periodTo: now,
      amount: 50,
      status: 'unpaid',
      createdAt: now,
      subscriptionId: 85,
    );

    final paid = VehicleChargeEntity(
      id: 2,
      vehicleId: 7,
      periodFrom: now,
      periodTo: now,
      amount: 50,
      status: 'paid',
      createdAt: now,
      subscriptionId: 85,
    );

    expect(unpaid.isUnpaid, isTrue);
    expect(unpaid.isPaid, isFalse);
    expect(paid.isPaid, isTrue);
    expect(paid.isUnpaid, isFalse);
  });
}
