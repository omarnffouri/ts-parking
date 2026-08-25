import '../../core/enums/parking_vehicle_type.dart';
import '../../domain/entities/vehicle_entity.dart';

class VehicleModel extends VehicleEntity {
  const VehicleModel({
    required super.id,
    required super.userId,
    required super.vehicleTypeId,
    required super.vehicleType,
    required super.vehicleTypeName,
    required super.licensePlate,
    super.identifier,
    super.status,
    required super.createdAt,
    super.updatedAt,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    final vehicleTypeId = json['vehicle_type_id'] as int? ?? 1;
    final vehicleTypeJson = json['vehicle_type'] is Map<String, dynamic>
        ? json['vehicle_type'] as Map<String, dynamic>
        : null;
    final vehicleTypeName = vehicleTypeJson?['name']?.toString().trim() ?? '';

    return VehicleModel(
      id: json['id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      vehicleTypeId: vehicleTypeId,
      vehicleType: vehicleTypeName.isNotEmpty
          ? ParkingVehicleTypeX.fromApiName(vehicleTypeName)
          : ParkingVehicleType.unknown,
      vehicleTypeName: vehicleTypeName.isNotEmpty ? vehicleTypeName : 'Unknown',
      licensePlate: json['license_plate']?.toString() ?? '',
      identifier: json['identifier']?.toString(),
      status: json['status']?.toString() ?? 'active',
      createdAt:
          DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'vehicle_type_id': vehicleTypeId,
    'license_plate': licensePlate,
  };
}
