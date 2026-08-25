import '../../domain/entities/pricing_plan_entity.dart';
import 'plan_service_model.dart';

class PricingPlanModel extends PricingPlanEntity {
  const PricingPlanModel({
    required super.id,
    required super.name,
    super.description,
    required super.price,
    super.attributes,
  });

  factory PricingPlanModel.fromJson(Map<String, dynamic> json) {
    final rawAttributes = json['attributes'];
    final attributesList = rawAttributes is List ? rawAttributes : <dynamic>[];

    return PricingPlanModel(
      id: json['id'].toString(),
      name: (json['subscription_type'] ?? json['name'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      attributes: attributesList
          .whereType<Map>()
          .map((a) => PlanServiceModel.fromJson(Map<String, dynamic>.from(a)))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subscription_type': name,
    'description': description,
    'price': price.toString(),
    'attributes': attributes
        .map(
          (a) => PlanServiceModel(
            id: a.id,
            name: a.name,
            description: a.description,
            price: a.price,
          ).toJson(),
        )
        .toList(),
  };
}
