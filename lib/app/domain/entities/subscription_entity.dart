import 'package:equatable/equatable.dart';

import '../../core/enums/slot_status_enum.dart';

class SubscriptionEntity extends Equatable {
  final int id;
  final String subscriptionRef;
  final int slotId;
  final int planId;
  final int vehicleId;
  final String billingCycle;
  final double totalAmount;
  final String status;
  final bool autoRenew;
  final DateTime? startedAt;
  final int duration;
  final DateTime? nextBillingDate;
  final String? subscriptionType;
  final double? planPrice;
  final String? slotCode;
  final SlotStatus? slotStatus;
  final DateTime? cancelledAt;
  final double? discount;
  final double? amountBeforeDiscount;

  const SubscriptionEntity({
    required this.id,
    required this.subscriptionRef,
    required this.slotId,
    required this.planId,
    required this.vehicleId,
    required this.billingCycle,
    required this.totalAmount,
    required this.status,
    required this.autoRenew,
    this.startedAt,
    this.duration = 1,
    this.nextBillingDate,
    this.subscriptionType,
    this.planPrice,
    this.slotCode,
    this.slotStatus,
    this.cancelledAt,
    this.discount,
    this.amountBeforeDiscount,
  });

  bool get isSlotUnavailable => slotStatus == SlotStatus.booked;

  @override
  List<Object?> get props => [
    id,
    subscriptionRef,
    slotId,
    planId,
    vehicleId,
    billingCycle,
    totalAmount,
    status,
    autoRenew,
    startedAt,
    duration,
    nextBillingDate,
    subscriptionType,
    planPrice,
    slotCode,
    slotStatus,
    cancelledAt,
    discount,
    amountBeforeDiscount,
  ];
}
