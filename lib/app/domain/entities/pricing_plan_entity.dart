import 'package:equatable/equatable.dart';

import 'plan_service_entity.dart';

class PricingPlanEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double price;
  final List<PlanServiceEntity> attributes;

  const PricingPlanEntity({
    required this.id,
    required this.name,
    this.description = '',
    required this.price,
    this.attributes = const [],
  });

  @override
  List<Object?> get props => [id, name, description, price, attributes];
}
