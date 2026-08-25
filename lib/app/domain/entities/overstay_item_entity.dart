import 'package:equatable/equatable.dart';

class OverstayItemEntity extends Equatable {
  final int id;
  final int subscriptionId;
  final int vehicleId;
  final int slotId;
  final DateTime periodFrom;
  final DateTime periodTo;
  final double rate;
  final double amount;
  final String status;
  final String? note;
  final DateTime createdAt;

  const OverstayItemEntity({
    required this.id,
    required this.subscriptionId,
    required this.vehicleId,
    required this.slotId,
    required this.periodFrom,
    required this.periodTo,
    required this.rate,
    required this.amount,
    required this.status,
    this.note,
    required this.createdAt,
  });

  bool get isUnpaid => status.toLowerCase() == 'unpaid';
  bool get isPaid => status.toLowerCase() == 'paid';

  @override
  List<Object?> get props => [
    id,
    subscriptionId,
    vehicleId,
    slotId,
    periodFrom,
    periodTo,
    rate,
    amount,
    status,
    note,
    createdAt,
  ];
}
