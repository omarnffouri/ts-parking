import '../../domain/entities/vehicle_charge_entity.dart';

class VehicleChargeModel extends VehicleChargeEntity {
  const VehicleChargeModel({
    required super.id,
    required super.vehicleId,
    required super.periodFrom,
    required super.periodTo,
    required super.amount,
    required super.status,
    super.note,
    required super.createdAt,
    required super.subscriptionId,
    super.licensePlate,
    super.subscriptionRef,
    super.billingCycle,
    super.subscriptionAmount,
  });

  factory VehicleChargeModel.fromJson(Map<String, dynamic> json) {
    final vehicle = json['vehicle'] as Map<String, dynamic>?;
    final subscription = json['subscription'] as Map<String, dynamic>?;

    return VehicleChargeModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      vehicleId: (json['vehicle_id'] as num?)?.toInt() ?? 0,
      periodFrom:
          DateTime.tryParse(json['period_from']?.toString() ?? '') ??
          DateTime.now(),
      periodTo:
          DateTime.tryParse(json['period_to']?.toString() ?? '') ??
          DateTime.now(),
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'unknown',
      note: json['note'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      subscriptionId: (json['subscription_id'] as num?)?.toInt() ?? 0,
      licensePlate: vehicle?['license_plate'] as String?,
      subscriptionRef: subscription?['subscription_ref'] as String?,
      billingCycle: subscription?['billing_cycle'] as String?,
      subscriptionAmount: subscription?['total_amount'] != null
          ? double.tryParse(subscription!['total_amount'].toString())
          : null,
    );
  }
}
