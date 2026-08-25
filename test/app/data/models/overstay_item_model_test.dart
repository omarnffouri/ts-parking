import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/overstay_item_model.dart';

void main() {
  test('fromJson parses all fields', () {
    final item = OverstayItemModel.fromJson({
      'id': 3,
      'subscription_id': 85,
      'vehicle_id': 7,
      'slot_id': 243,
      'period_from': '2026-05-03T00:00:00.000000Z',
      'period_to': '2026-05-04T00:00:00.000000Z',
      'rate': 50,
      'amount': 100,
      'status': 'unpaid',
      'note': 'overstay note',
      'created_at': '2026-04-03T18:08:17.000000Z',
    });

    expect(item.id, 3);
    expect(item.subscriptionId, 85);
    expect(item.vehicleId, 7);
    expect(item.slotId, 243);
    expect(item.rate, 50.0);
    expect(item.amount, 100.0);
    expect(item.status, 'unpaid');
    expect(item.note, 'overstay note');
    expect(item.isUnpaid, isTrue);
    expect(item.isPaid, isFalse);
  });

  test('fromJson handles null optional fields', () {
    final item = OverstayItemModel.fromJson({
      'id': 1,
      'subscription_id': 2,
      'vehicle_id': 3,
      'slot_id': 4,
      'period_from': '2026-01-01T00:00:00.000000Z',
      'period_to': '2026-01-01T00:00:00.000000Z',
      'rate': 10,
      'amount': 10,
      'status': 'paid',
      'note': null,
      'created_at': '2026-01-01T00:00:00.000000Z',
    });

    expect(item.note, isNull);
    expect(item.isPaid, isTrue);
  });
}
