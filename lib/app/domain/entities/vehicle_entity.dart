import 'package:equatable/equatable.dart';

import '../../core/enums/parking_vehicle_type.dart';

class VehicleEntity extends Equatable {
  final String id;
  final String userId;
  final int vehicleTypeId;
  final ParkingVehicleType vehicleType;
  final String vehicleTypeName;
  final String licensePlate;
  final String? identifier;
  final String status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const VehicleEntity({
    required this.id,
    required this.userId,
    required this.vehicleTypeId,
    required this.vehicleType,
    required this.vehicleTypeName,
    required this.licensePlate,
    this.identifier,
    this.status = 'active',
    required this.createdAt,
    this.updatedAt,
  });

  bool get isActive => status.toLowerCase() == 'active';

  @override
  List<Object?> get props => [
    id,
    userId,
    vehicleTypeId,
    vehicleType,
    vehicleTypeName,
    licensePlate,
    identifier,
    status,
    createdAt,
    updatedAt,
  ];
}
