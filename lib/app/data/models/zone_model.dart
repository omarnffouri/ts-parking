import '../../domain/entities/zone_entity.dart';

class ZoneModel extends ZoneEntity {
  const ZoneModel({
    required super.id,
    super.yardId,
    required super.name,
    super.description,
    super.capacity,
    super.status,
    super.slotsCount,
  });

  factory ZoneModel.fromJson(Map<String, dynamic> json) {
    return ZoneModel(
      id: json['id'].toString(),
      yardId: (json['yard_id'] ?? '').toString(),
      name: (json['name'] as String?)?.trim() ?? '',
      description: json['description'] as String?,
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      status: (json['status'] as String?)?.trim().toLowerCase() ?? '',
      slotsCount: (json['slots_count'] as num?)?.toInt() ?? 0,
    );
  }
}
