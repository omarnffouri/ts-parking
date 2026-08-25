import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/vehicle_charge_model.dart';

void main() {
  test('fromJson parses all fields with nested vehicle and subscription', () {
    final charge = VehicleChargeModel.fromJson({
      'id': 3,
      'vehicle_id': 7,
      'period_from': '2026-05-03T00:00:00.000000Z',
      'period_to': '2026-05-03T00:00:00.000000Z',
      'amount': 50,
      'status': 'unpaid',
      'note': 'des',
      'created_at': '2026-04-03T18:08:17.000000Z',
      'subscription_id': 85,
      'vehicle': {'id': 7, 'license_plate': 'TR123'},
      'subscription': {
        'id': 85,
        'subscription_ref': 'SUB-20260403-004',
        'billing_cycle': 'monthly',
        'total_amount': '100.00',
      },
    });

    expect(charge.id, 3);
    expect(charge.vehicleId, 7);
    expect(charge.amount, 50.0);
    expect(charge.status, 'unpaid');
    expect(charge.note, 'des');
    expect(charge.subscriptionId, 85);
    expect(charge.licensePlate, 'TR123');
    expect(charge.subscriptionRef, 'SUB-20260403-004');
    expect(charge.billingCycle, 'monthly');
    expect(charge.subscriptionAmount, 100.0);
    expect(charge.isUnpaid, isTrue);
    expect(charge.isPaid, isFalse);
  });

  test('fromJson handles null nested objects', () {
    final charge = VehicleChargeModel.fromJson({
      'id': 1,
      'vehicle_id': 2,
      'period_from': '2026-01-01T00:00:00.000000Z',
      'period_to': '2026-01-01T00:00:00.000000Z',
      'amount': 25,
      'status': 'paid',
      'created_at': '2026-01-01T00:00:00.000000Z',
      'subscription_id': 10,
      'vehicle': null,
      'subscription': null,
    });

    expect(charge.licensePlate, isNull);
    expect(charge.subscriptionRef, isNull);
    expect(charge.billingCycle, isNull);
    expect(charge.subscriptionAmount, isNull);
    expect(charge.isPaid, isTrue);
  });
}
