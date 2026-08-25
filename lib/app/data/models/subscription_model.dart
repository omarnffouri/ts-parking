import '../../core/enums/slot_status_enum.dart';
import '../../domain/entities/subscription_entity.dart';

class SubscriptionModel extends SubscriptionEntity {
  const SubscriptionModel({
    required super.id,
    required super.subscriptionRef,
    required super.slotId,
    required super.planId,
    required super.vehicleId,
    required super.billingCycle,
    required super.totalAmount,
    required super.status,
    required super.autoRenew,
    super.startedAt,
    super.duration,
    super.nextBillingDate,
    super.subscriptionType,
    super.planPrice,
    super.slotCode,
    super.slotStatus,
    super.cancelledAt,
    super.discount,
    super.amountBeforeDiscount,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    final plan = json['plan'] is Map<String, dynamic>
        ? _SubscriptionPlan.fromJson(json['plan'] as Map<String, dynamic>)
        : null;

    final slot = json['slot'] is Map<String, dynamic>
        ? _SubscriptionSlot.fromJson(json['slot'] as Map<String, dynamic>)
        : null;

    return SubscriptionModel(
      id: json['id'] as int? ?? 0,
      subscriptionRef: json['subscription_ref']?.toString() ?? '',
      slotId: json['slot_id'] as int? ?? 0,
      planId: json['plan_id'] as int? ?? 0,
      vehicleId: json['vehicle_id'] as int? ?? 0,
      billingCycle: json['billing_cycle']?.toString() ?? 'monthly',
      totalAmount: double.tryParse(json['total_amount'].toString()) ?? 0.0,
      status: json['status']?.toString() ?? 'pending',
      autoRenew: json['auto_renew'] as bool? ?? true,
      startedAt: json['started_at'] != null
          ? DateTime.tryParse(json['started_at'].toString())
          : null,
      duration: json['duration'] as int? ?? 1,
      nextBillingDate: json['next_billing_date'] != null
          ? DateTime.tryParse(json['next_billing_date'].toString())
          : null,
      subscriptionType: plan?.subscriptionType,
      planPrice: plan?.price,
      slotCode: slot?.slotCode,
      slotStatus: slot?.status,
      cancelledAt: json['cancelled_at'] != null
          ? DateTime.tryParse(json['cancelled_at'].toString())
          : null,
      discount: double.tryParse(json['discount']?.toString() ?? ''),
      amountBeforeDiscount: double.tryParse(
        json['amount_before_discount']?.toString() ?? '',
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Nested JSON objects
// ---------------------------------------------------------------------------

class _SubscriptionPlan {
  final String? subscriptionType;
  final double? price;

  const _SubscriptionPlan({this.subscriptionType, this.price});

  factory _SubscriptionPlan.fromJson(Map<String, dynamic> json) {
    return _SubscriptionPlan(
      subscriptionType: json['subscription_type']?.toString(),
      price: double.tryParse(json['price']?.toString() ?? ''),
    );
  }
}

class _SubscriptionSlot {
  final String? slotCode;
  final SlotStatus? status;

  const _SubscriptionSlot({this.slotCode, this.status});

  factory _SubscriptionSlot.fromJson(Map<String, dynamic> json) {
    return _SubscriptionSlot(
      slotCode: json['slot_code']?.toString(),
      status: SlotStatus.tryParse(json['status']?.toString()),
    );
  }
}
