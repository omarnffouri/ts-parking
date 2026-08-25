import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/invoice_model.dart';

void main() {
  test('fromJson parses subscription invoice with all fields', () {
    final invoice = InvoiceModel.fromJson({
      'id': 57,
      'invoice_number': 'INV-20260403-009',
      'invoice_type': 'subscription',
      'subtotal': '300.00',
      'discount_amount': '50.00',
      'tax': '0.00',
      'total': '250.00',
      'status': 'paid',
      'issued_at': '2026-04-03T18:36:35.000000Z',
      'due_at': null,
      'paid_at': '2026-04-03T18:52:29.000000Z',
      'pdf_url': 'https://example.com/invoices/57/pdf',
      'subscriptions': [
        {
          'id': 89,
          'subscription_ref': 'SUB-001',
          'slot_id': 1,
          'plan_id': 5,
          'vehicle_id': 7,
          'billing_cycle': 'monthly',
          'total_amount': '300.00',
          'status': 'active',
          'auto_renew': true,
        },
      ],
      'overstays': null,
    });

    expect(invoice.id, 57);
    expect(invoice.invoiceNumber, 'INV-20260403-009');
    expect(invoice.invoiceType, 'subscription');
    expect(invoice.subtotal, 300.0);
    expect(invoice.discountAmount, 50.0);
    expect(invoice.tax, 0.0);
    expect(invoice.total, 250.0);
    expect(invoice.status, 'paid');
    expect(invoice.paidAt, isNotNull);
    expect(invoice.pdfUrl, 'https://example.com/invoices/57/pdf');
    expect(invoice.subscriptions, hasLength(1));
    expect(invoice.overstays, isEmpty);
    expect(invoice.isSubscription, isTrue);
    expect(invoice.isOverstay, isFalse);
  });

  test('fromJson parses overstay invoice with overstays array', () {
    final invoice = InvoiceModel.fromJson({
      'id': 60,
      'invoice_number': 'INV-20260406-001',
      'invoice_type': 'overstay',
      'subtotal': '50.00',
      'discount': '0.00',
      'tax': '0.00',
      'total': '50.00',
      'status': 'paid',
      'issued_at': '2026-04-06T12:13:23.000000Z',
      'overstays': [
        {
          'id': 3,
          'subscription_id': 85,
          'vehicle_id': 7,
          'slot_id': 243,
          'period_from': '2026-05-03T00:00:00.000000Z',
          'period_to': '2026-05-03T00:00:00.000000Z',
          'rate': 50,
          'amount': 50,
          'status': 'paid',
          'note': 'des',
          'created_at': '2026-04-03T18:08:17.000000Z',
        },
      ],
    });

    expect(invoice.isOverstay, isTrue);
    expect(invoice.overstays, hasLength(1));
    expect(invoice.overstays.first.amount, 50.0);
    expect(invoice.subscriptions, isEmpty);
  });

  test('fromJson handles null/missing fields gracefully', () {
    final invoice = InvoiceModel.fromJson({'id': null, 'status': 'pending'});

    expect(invoice.id, 0);
    expect(invoice.invoiceNumber, '');
    expect(invoice.subtotal, 0.0);
    expect(invoice.total, 0.0);
    expect(invoice.subscriptions, isEmpty);
    expect(invoice.overstays, isEmpty);
  });
}
