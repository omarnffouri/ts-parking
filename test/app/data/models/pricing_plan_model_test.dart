import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/pricing_plan_model.dart';

void main() {
  test('fromJson parses plan with attributes', () {
    final plan = PricingPlanModel.fromJson({
      'id': 5,
      'subscription_type': 'standard',
      'description': 'Basic parking plan',
      'price': '200.00',
      'attributes': [
        {
          'id': 1,
          'name': 'Parking',
          'description': 'Slot access',
          'price': 200,
        },
      ],
    });

    expect(plan.id, '5');
    expect(plan.name, 'standard');
    expect(plan.description, 'Basic parking plan');
    expect(plan.price, 200.0);
    expect(plan.attributes, hasLength(1));
    expect(plan.attributes.first.name, 'Parking');
  });

  test('fromJson handles null attributes', () {
    final plan = PricingPlanModel.fromJson({
      'id': 1,
      'price': '100',
      'attributes': null,
    });

    expect(plan.attributes, isEmpty);
  });
}
