import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';
import 'package:ts_parking/app/data/models/subscription_model.dart';

void main() {
  test('fromJson parses all fields with nested plan and slot', () {
    final sub = SubscriptionModel.fromJson({
      'id': 89,
      'subscription_ref': 'SUB-20260403-008',
      'slot_id': 334,
      'plan_id': 5,
      'vehicle_id': 7,
      'billing_cycle': 'monthly',
      'total_amount': '300.00',
      'discount': '50.00',
      'amount_before_discount': '350.00',
      'status': 'active',
      'auto_renew': true,
      'started_at': '2026-04-03T00:00:00.000000Z',
      'duration': 1,
      'next_billing_date': '2026-05-03T00:00:00.000000Z',
      'cancelled_at': null,
      'slot': {'id': 334, 'slot_code': 'B08', 'status': 'booked'},
      'plan': {'id': 5, 'subscription_type': 'standard', 'price': '200.00'},
    });

    expect(sub.id, 89);
    expect(sub.subscriptionRef, 'SUB-20260403-008');
    expect(sub.totalAmount, 300.0);
    expect(sub.discount, 50.0);
    expect(sub.amountBeforeDiscount, 350.0);
    expect(sub.status, 'active');
    expect(sub.autoRenew, isTrue);
    expect(sub.duration, 1);
    expect(sub.slotCode, 'B08');
    expect(sub.slotStatus, SlotStatus.booked);
    expect(sub.subscriptionType, 'standard');
    expect(sub.planPrice, 200.0);
  });

  test('fromJson handles missing nested objects and null fields', () {
    final sub = SubscriptionModel.fromJson({
      'id': null,
      'subscription_ref': null,
      'billing_cycle': null,
      'total_amount': null,
      'status': null,
      'auto_renew': null,
    });

    expect(sub.id, 0);
    expect(sub.subscriptionRef, '');
    expect(sub.billingCycle, 'monthly');
    expect(sub.totalAmount, 0.0);
    expect(sub.autoRenew, isTrue);
    expect(sub.slotCode, isNull);
    expect(sub.slotStatus, isNull);
    expect(sub.subscriptionType, isNull);
    expect(sub.planPrice, isNull);
    expect(sub.discount, isNull);
    expect(sub.amountBeforeDiscount, isNull);
  });
}
