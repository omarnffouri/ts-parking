import '../../domain/entities/plan_service_entity.dart';

class PlanServiceModel extends PlanServiceEntity {
  const PlanServiceModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
  });

  factory PlanServiceModel.fromJson(Map<String, dynamic> json) {
    return PlanServiceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
  };
}
