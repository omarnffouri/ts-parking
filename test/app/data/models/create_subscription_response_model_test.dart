import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/create_subscription_response_model.dart';

void main() {
  test('fromJson parses flat list format (driver)', () {
    final response = CreateSubscriptionResponseModel.fromJson({
      'data': [
        {
          'id': 1,
          'subscription_ref': 'SUB-001',
          'total_amount': '300.00',
          'status': 'pending',
        },
      ],
    });

    expect(response.subscriptions, hasLength(1));
    expect(response.subscriptions.first.subscriptionRef, 'SUB-001');
    expect(response.invoice, isNull);
  });

  test('fromJson parses map format with invoice', () {
    final response = CreateSubscriptionResponseModel.fromJson({
      'data': {
        'subscriptions': [
          {
            'id': 1,
            'subscription_ref': 'SUB-001',
            'total_amount': '300.00',
            'status': 'pending',
          },
        ],
        'invoice': {
          'id': 71,
          'subtotal': '300.00',
          'discount_amount': '50.00',
          'tax': '0.00',
          'total': '300.00',
          'status': 'pending',
          'invoice_type': 'subscription',
          'issued_at': '2026-04-08T00:00:00.000000Z',
        },
      },
    });

    expect(response.subscriptions, hasLength(1));
    expect(response.invoice, isNotNull);
    expect(response.invoice!.id, 71);
  });
}
