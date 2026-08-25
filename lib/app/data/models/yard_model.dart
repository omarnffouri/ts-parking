import '../../domain/entities/yard_entity.dart';

class YardModel extends YardEntity {
  const YardModel({
    required super.id,
    required super.name,
    required super.address,
    required super.latitude,
    required super.longitude,
    required super.capacityTotal,
    required super.availableSlots,
    required super.status,
    super.imageUrl,
  });

  factory YardModel.fromJson(Map<String, dynamic> json) {
    return YardModel(
      id: json['id'].toString(),
      name: (json['name'] as String?)?.trim() ?? '',
      address: (json['address'] as String?)?.trim() ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      capacityTotal: (json['capacity_total'] as num?)?.toInt() ?? 0,
      availableSlots: (json['available_slots'] as num?)?.toInt() ?? 0,
      status: (json['status'] as String?)?.trim().toLowerCase() ?? '',
      imageUrl: (json['image'] as String?)?.trim().isNotEmpty == true
          ? (json['image'] as String).trim()
          : null,
    );
  }
}
