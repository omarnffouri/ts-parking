import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/domain/entities/invoice_entity.dart';

void main() {
  test('isOverstay and isSubscription return correct values', () {
    final overstay = InvoiceEntity(
      id: 1,
      invoiceNumber: 'INV-001',
      invoiceType: 'overstay',
      status: 'paid',
      subtotal: 50,
      discountAmount: 0,
      tax: 0,
      total: 50,
      issuedAt: DateTime(2026, 4, 1),
    );

    final subscription = InvoiceEntity(
      id: 2,
      invoiceNumber: 'INV-002',
      invoiceType: 'subscription',
      status: 'pending',
      subtotal: 300,
      discountAmount: 50,
      tax: 0,
      total: 250,
      issuedAt: DateTime(2026, 4, 1),
    );

    expect(overstay.isOverstay, isTrue);
    expect(overstay.isSubscription, isFalse);
    expect(subscription.isSubscription, isTrue);
    expect(subscription.isOverstay, isFalse);
  });

  test('equatable compares by value', () {
    final a = InvoiceEntity(
      id: 1,
      invoiceNumber: 'INV-001',
      invoiceType: 'subscription',
      status: 'paid',
      subtotal: 100,
      discountAmount: 0,
      tax: 0,
      total: 100,
      issuedAt: DateTime(2026, 4, 1),
    );
    final b = InvoiceEntity(
      id: 1,
      invoiceNumber: 'INV-001',
      invoiceType: 'subscription',
      status: 'paid',
      subtotal: 100,
      discountAmount: 0,
      tax: 0,
      total: 100,
      issuedAt: DateTime(2026, 4, 1),
    );

    expect(a, equals(b));
  });
}
