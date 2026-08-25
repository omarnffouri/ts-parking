import '../../domain/entities/vehicle_type_entity.dart';

class VehicleTypeModel extends VehicleTypeEntity {
  const VehicleTypeModel({
    required super.id,
    required super.name,
    required super.price,
  });

  factory VehicleTypeModel.fromJson(Map<String, dynamic> json) {
    return VehicleTypeModel(
      id: json['id'] as int? ?? 0,
      name: json['name']?.toString() ?? '',
      price: double.tryParse(json['price']?.toString() ?? '0') ?? 0.0,
    );
  }
}
