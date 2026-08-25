import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/plan_service_model.dart';

void main() {
  test('fromJson parses all fields', () {
    final plan = PlanServiceModel.fromJson({
      'id': 5,
      'name': 'Standard',
      'description': 'Basic parking plan',
      'price': 200,
    });

    expect(plan.id, '5');
    expect(plan.name, 'Standard');
    expect(plan.description, 'Basic parking plan');
    expect(plan.price, 200.0);
  });

  test('fromJson handles null fields', () {
    final plan = PlanServiceModel.fromJson({
      'id': null,
      'name': null,
      'description': null,
      'price': null,
    });

    expect(plan.id, '');
    expect(plan.name, '');
    expect(plan.description, '');
    expect(plan.price, 0.0);
  });
}
