import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/domain/entities/overstay_item_entity.dart';

void main() {
  final now = DateTime.now();

  test('isUnpaid and isPaid return correct values', () {
    final unpaid = OverstayItemEntity(
      id: 1,
      subscriptionId: 85,
      vehicleId: 7,
      slotId: 243,
      periodFrom: now,
      periodTo: now,
      rate: 50,
      amount: 50,
      status: 'unpaid',
      createdAt: now,
    );

    expect(unpaid.isUnpaid, isTrue);
    expect(unpaid.isPaid, isFalse);
  });
}
