import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';
import 'package:ts_parking/app/domain/entities/slot_entity.dart';

void main() {
  test('isVip returns true for vip plan', () {
    const slot = SlotEntity(
      id: 1,
      zoneId: 1,
      slotCode: 'A1',
      status: SlotStatus.available,
      backendStatus: 'available',
      vehicleTypeId: 1,
      vehicleTypeName: 'Truck',
      vehicleTypePrice: 150,
      zoneName: 'Zone A',
      zoneHorizontalCapacity: 4,
      zoneVerticalCapacity: 8,
      planId: 1,
      planName: 'vip',
      planPrice: 100,
      price: 100,
      priceBeforeDiscount: 100,
      discount: 0,
    );

    expect(slot.isVip, isTrue);
  });

  test('hasDiscount returns true when discount > 0', () {
    const slot = SlotEntity(
      id: 1,
      zoneId: 1,
      slotCode: 'B1',
      status: SlotStatus.available,
      backendStatus: 'available',
      vehicleTypeId: 1,
      vehicleTypeName: 'Truck',
      vehicleTypePrice: 150,
      zoneName: 'Zone B',
      zoneHorizontalCapacity: 2,
      zoneVerticalCapacity: 6,
      planId: 1,
      planName: 'standard',
      planPrice: 200,
      price: 150,
      priceBeforeDiscount: 200,
      discount: 50,
    );

    expect(slot.hasDiscount, isTrue);
    expect(slot.isVip, isFalse);
  });

  test('isBookable is true only for available slots without active users', () {
    const available = SlotEntity(
      id: 1,
      zoneId: 1,
      slotCode: 'W-01',
      status: SlotStatus.available,
      backendStatus: 'available',
      vehicleTypeId: 1,
      vehicleTypeName: 'Truck',
      vehicleTypePrice: 150,
      zoneName: 'West',
      zoneHorizontalCapacity: 0,
      zoneVerticalCapacity: 0,
      planId: 1,
      planName: 'standard',
      planPrice: 100,
      price: 100,
      priceBeforeDiscount: 100,
      discount: 0,
    );
    const availableWithSubscription = SlotEntity(
      id: 3,
      zoneId: 1,
      slotCode: 'W-03',
      status: SlotStatus.available,
      backendStatus: 'available',
      vehicleTypeId: 1,
      vehicleTypeName: 'Truck',
      vehicleTypePrice: 150,
      zoneName: 'West',
      zoneHorizontalCapacity: 0,
      zoneVerticalCapacity: 0,
      planId: 1,
      planName: 'vip',
      planPrice: 100,
      price: 100,
      priceBeforeDiscount: 100,
      discount: 0,
      activeSubscriptionUser: SlotActiveSubscriptionUserEntity(
        id: 9,
        name: 'Reserved User',
        mobileNumber: '0500000000',
      ),
    );
    const occupied = SlotEntity(
      id: 2,
      zoneId: 1,
      slotCode: 'W-02',
      status: SlotStatus.booked,
      backendStatus: 'hold',
      vehicleTypeId: 1,
      vehicleTypeName: 'Truck',
      vehicleTypePrice: 150,
      zoneName: 'West',
      zoneHorizontalCapacity: 0,
      zoneVerticalCapacity: 0,
      planId: 1,
      planName: 'standard',
      planPrice: 100,
      price: 100,
      priceBeforeDiscount: 100,
      discount: 0,
    );

    expect(available.isBookable, isTrue);
    expect(availableWithSubscription.isBookable, isFalse);
    expect(occupied.isBookable, isFalse);
  });

  test('equatable props include backend zone metadata fields', () {
    const first = SlotEntity(
      id: 1,
      zoneId: 1,
      slotCode: 'S-01',
      status: SlotStatus.booked,
      backendStatus: 'active',
      vehicleTypeId: 2,
      vehicleTypeName: 'Trailer',
      vehicleTypePrice: 200,
      zoneName: 'South',
      zoneDirection: 'right',
      zoneHorizontalCapacity: 12,
      zoneVerticalCapacity: 18,
      planId: 1,
      planName: 'standard',
      planPrice: 150,
      price: 150,
      priceBeforeDiscount: 200,
      discount: 50,
    );
    const second = SlotEntity(
      id: 1,
      zoneId: 1,
      slotCode: 'S-01',
      status: SlotStatus.booked,
      backendStatus: 'booked',
      vehicleTypeId: 2,
      vehicleTypeName: 'Trailer',
      vehicleTypePrice: 200,
      zoneName: 'South',
      zoneDirection: 'right',
      zoneHorizontalCapacity: 12,
      zoneVerticalCapacity: 18,
      planId: 1,
      planName: 'standard',
      planPrice: 150,
      price: 150,
      priceBeforeDiscount: 200,
      discount: 50,
    );

    expect(first, isNot(second));
  });
}
