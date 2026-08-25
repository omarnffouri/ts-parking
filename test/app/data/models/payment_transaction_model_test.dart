import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/data/models/payment_transaction_model.dart';

void main() {
  test('fromJson parses payment transaction', () {
    final tx = PaymentTransactionModel.fromJson({
      'transaction_type': 'payment',
      'method': 'card',
      'status': 'paid',
      'amount_paid': '300.00',
      'paid_at': '2026-04-03T18:52:29.000000Z',
    });

    expect(tx.title, 'Payment');
    expect(tx.subtitle, contains('Card'));
    expect(tx.amount, contains('300.00'));
    expect(tx.isCredit, isFalse);
    expect(tx.status, 'paid');
  });

  test('fromJson identifies credit types', () {
    final tx = PaymentTransactionModel.fromJson({
      'transaction_type': 'refund',
      'method': 'online',
      'status': 'completed',
      'amount_paid': '50.00',
      'paid_at': '2026-04-01T00:00:00.000000Z',
    });

    expect(tx.isCredit, isTrue);
    expect(tx.amount, startsWith('+'));
  });

  test('fromJson handles missing fields', () {
    final tx = PaymentTransactionModel.fromJson({});

    expect(tx.title, 'Payment');
    expect(tx.amount, contains('0.00'));
    expect(tx.timeLabel, 'Unknown time');
  });
}
