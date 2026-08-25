import 'package:equatable/equatable.dart';

class VehicleChargeEntity extends Equatable {
  final int id;
  final int vehicleId;
  final DateTime periodFrom;
  final DateTime periodTo;
  final double amount;
  final String status;
  final String? note;
  final DateTime createdAt;
  final int subscriptionId;
  final String? licensePlate;
  final String? subscriptionRef;
  final String? billingCycle;
  final double? subscriptionAmount;

  const VehicleChargeEntity({
    required this.id,
    required this.vehicleId,
    required this.periodFrom,
    required this.periodTo,
    required this.amount,
    required this.status,
    this.note,
    required this.createdAt,
    required this.subscriptionId,
    this.licensePlate,
    this.subscriptionRef,
    this.billingCycle,
    this.subscriptionAmount,
  });

  bool get isUnpaid => status.toLowerCase() == 'unpaid';
  bool get isPaid => status.toLowerCase() == 'paid';

  @override
  List<Object?> get props => [
    id,
    vehicleId,
    periodFrom,
    periodTo,
    amount,
    status,
    note,
    createdAt,
    subscriptionId,
    licensePlate,
    subscriptionRef,
    billingCycle,
    subscriptionAmount,
  ];
}
