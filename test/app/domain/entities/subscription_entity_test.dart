import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/domain/entities/subscription_entity.dart';

void main() {
  test('equatable compares by value', () {
    const a = SubscriptionEntity(
      id: 1,
      subscriptionRef: 'SUB-001',
      slotId: 10,
      planId: 5,
      vehicleId: 7,
      billingCycle: 'monthly',
      totalAmount: 300,
      status: 'active',
      autoRenew: true,
    );
    const b = SubscriptionEntity(
      id: 1,
      subscriptionRef: 'SUB-001',
      slotId: 10,
      planId: 5,
      vehicleId: 7,
      billingCycle: 'monthly',
      totalAmount: 300,
      status: 'active',
      autoRenew: true,
    );

    expect(a, equals(b));
  });

  test('optional fields default correctly', () {
    const sub = SubscriptionEntity(
      id: 1,
      subscriptionRef: 'SUB-001',
      slotId: 10,
      planId: 5,
      vehicleId: 7,
      billingCycle: 'monthly',
      totalAmount: 300,
      status: 'active',
      autoRenew: true,
    );

    expect(sub.duration, 1);
    expect(sub.startedAt, isNull);
    expect(sub.nextBillingDate, isNull);
    expect(sub.subscriptionType, isNull);
    expect(sub.planPrice, isNull);
    expect(sub.slotCode, isNull);
    expect(sub.cancelledAt, isNull);
    expect(sub.discount, isNull);
    expect(sub.amountBeforeDiscount, isNull);
  });
}
