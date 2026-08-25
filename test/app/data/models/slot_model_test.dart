import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';
import 'package:ts_parking/app/data/models/slot_model.dart';

void main() {
  test(
    'fromJson parses new backend slot fields and active subscription user',
    () {
      final slot = SlotModel.fromJson({
        'id': 328,
        'zone_id': 6,
        'slot_code': 'B02',
        'status': 'hold',
        'vehicle_type_id': 1,
        'price': 300,
        'price_before_discount': 350,
        'owner_operator_discount': 50,
        'vehicle_type': {'id': 1, 'name': 'truck', 'price': '150.00'},
        'zone': {
          'id': 6,
          'name': 'B',
          'direction': null,
          'horizontal_capacity': 0,
          'vertical_capacity': 0,
        },
        'plan': {'id': 5, 'subscription_type': 'standard', 'price': '200.00'},
        'active_subscription_user': {
          'id': 3,
          'name': 'Abdullah Hobabi TT',
          'user_type': 'cat_driver',
          'vehicle_id': 1,
          'vehicle_number': 'TRU2',
          'vehicle_identifier': null,
        },
      });

      expect(slot.status, SlotStatus.booked);
      expect(slot.backendStatus, 'hold');
      expect(slot.vehicleTypePrice, 150);
      expect(slot.zoneDirection, isNull);
      expect(slot.zoneHorizontalCapacity, 0);
      expect(slot.zoneVerticalCapacity, 0);
      expect(slot.activeSubscriptionUser, isNotNull);
      expect(slot.activeSubscriptionUser!.name, 'Abdullah Hobabi TT');
      expect(slot.activeSubscriptionUser!.vehicleNumber, 'TRU2');
      expect(slot.activeSubscriptionUser!.userTypeLabel, 'Driver');
    },
  );

  test('fromJson maps only available to the bookable slot status', () {
    final available = SlotModel.fromJson({
      'id': 1,
      'zone_id': 1,
      'slot_code': 'N-01',
      'status': 'available',
      'vehicle_type_id': 1,
      'vehicle_type': {'id': 1, 'name': 'truck', 'price': '150.00'},
      'zone': {
        'id': 5,
        'name': 'North',
        'direction': null,
        'horizontal_capacity': 0,
        'vertical_capacity': 0,
      },
      'price': 100,
      'price_before_discount': 100,
      'owner_operator_discount': 0,
    });
    final reservedAvailable = SlotModel.fromJson({
      'id': 4,
      'zone_id': 1,
      'slot_code': 'N-04',
      'status': 'available',
      'vehicle_type_id': 1,
      'vehicle_type': {'id': 1, 'name': 'truck', 'price': '150.00'},
      'zone': {
        'id': 5,
        'name': 'North',
        'direction': null,
        'horizontal_capacity': 0,
        'vertical_capacity': 0,
      },
      'plan': {'id': 2, 'subscription_type': 'vip', 'price': '150.00'},
      'active_subscription_user': {
        'id': 30,
        'name': 'Reserved VIP User',
        'user_type': 'cat_client',
        'vehicle_id': 35,
        'vehicle_number': 'AASSDD',
        'vehicle_identifier': null,
      },
      'price': 100,
      'price_before_discount': 100,
      'owner_operator_discount': 0,
    });
    final active = SlotModel.fromJson({
      'id': 2,
      'zone_id': 1,
      'slot_code': 'N-02',
      'status': 'active',
      'vehicle_type_id': 1,
      'vehicle_type': {'id': 1, 'name': 'truck', 'price': '150.00'},
      'zone': {
        'id': 5,
        'name': 'North',
        'direction': null,
        'horizontal_capacity': 0,
        'vertical_capacity': 0,
      },
      'price': 100,
      'price_before_discount': 100,
      'owner_operator_discount': 0,
    });
    final hold = SlotModel.fromJson({
      'id': 3,
      'zone_id': 1,
      'slot_code': 'N-03',
      'status': 'hold',
      'vehicle_type_id': 1,
      'vehicle_type': {'id': 1, 'name': 'truck', 'price': '150.00'},
      'zone': {
        'id': 5,
        'name': 'North',
        'direction': null,
        'horizontal_capacity': 0,
        'vertical_capacity': 0,
      },
      'price': 100,
      'price_before_discount': 100,
      'owner_operator_discount': 0,
    });

    expect(available.status, SlotStatus.available);
    expect(available.isBookable, isTrue);
    expect(reservedAvailable.status, SlotStatus.available);
    expect(reservedAvailable.activeSubscriptionUser, isNotNull);
    expect(reservedAvailable.isBookable, isFalse);
    expect(active.status, SlotStatus.booked);
    expect(active.isBookable, isFalse);
    expect(hold.status, SlotStatus.booked);
    expect(hold.isBookable, isFalse);
  });
}
