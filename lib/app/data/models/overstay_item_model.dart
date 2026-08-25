import '../../domain/entities/overstay_item_entity.dart';

class OverstayItemModel extends OverstayItemEntity {
  const OverstayItemModel({
    required super.id,
    required super.subscriptionId,
    required super.vehicleId,
    required super.slotId,
    required super.periodFrom,
    required super.periodTo,
    required super.rate,
    required super.amount,
    required super.status,
    super.note,
    required super.createdAt,
  });

  factory OverstayItemModel.fromJson(Map<String, dynamic> json) {
    return OverstayItemModel(
      id: (json['id'] as num?)?.toInt() ?? 0,
      subscriptionId: (json['subscription_id'] as num?)?.toInt() ?? 0,
      vehicleId: (json['vehicle_id'] as num?)?.toInt() ?? 0,
      slotId: (json['slot_id'] as num?)?.toInt() ?? 0,
      periodFrom:
          DateTime.tryParse(json['period_from']?.toString() ?? '') ??
          DateTime.now(),
      periodTo:
          DateTime.tryParse(json['period_to']?.toString() ?? '') ??
          DateTime.now(),
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? 'unknown',
      note: json['note'] as String?,
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }
}
