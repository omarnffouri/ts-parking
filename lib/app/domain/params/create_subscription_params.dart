class SlotSubscriptionParam {
  final int slotId;
  final String billingCycle;
  final bool autoRenew;
  final String startDate;
  final int duration;
  final int vehicleId;
  final int planId;

  const SlotSubscriptionParam({
    required this.slotId,
    this.billingCycle = 'monthly',
    required this.autoRenew,
    required this.startDate,
    required this.duration,
    required this.vehicleId,
    required this.planId,
  });

  Map<String, dynamic> toJson() => {
    'slot_id': slotId,
    'billing_cycle': billingCycle,
    'auto_renew': autoRenew,
    'start_date': startDate,
    'duration': duration,
    'vehicle_id': vehicleId,
    'plan_id': planId,
  };
}

class CreateSubscriptionParams {
  final List<SlotSubscriptionParam> slots;

  const CreateSubscriptionParams({required this.slots});

  Map<String, dynamic> toJson() => {
    'slots': slots.map((s) => s.toJson()).toList(),
  };
}
