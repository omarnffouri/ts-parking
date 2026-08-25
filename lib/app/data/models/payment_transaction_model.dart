import 'package:intl/intl.dart';

import '../../domain/entities/payment_transaction_entity.dart';

class PaymentTransactionModel extends PaymentTransactionEntity {
  const PaymentTransactionModel({
    required super.title,
    required super.subtitle,
    required super.timeLabel,
    required super.amount,
    required super.isCredit,
    required super.status,
  });

  factory PaymentTransactionModel.fromJson(Map<String, dynamic> json) {
    final transactionType = json['transaction_type']?.toString() ?? 'payment';
    final method = json['method']?.toString() ?? 'online';
    final status = json['status']?.toString() ?? 'paid';
    final amountValue = double.tryParse(json['amount_paid'].toString()) ?? 0.0;
    final paidAtRaw = json['paid_at']?.toString();
    final paidAt = paidAtRaw != null
        ? DateTime.tryParse(paidAtRaw)?.toLocal()
        : null;
    final isCredit = _isCreditType(transactionType);

    return PaymentTransactionModel(
      title: _toTitleCase(transactionType),
      subtitle: '${_toTitleCase(method)} • ${_toTitleCase(status)}',
      timeLabel: paidAt != null
          ? DateFormat('MMM dd, hh:mm a').format(paidAt)
          : 'Unknown time',
      amount: '${isCredit ? '+' : '-'}\$${amountValue.toStringAsFixed(2)}',
      isCredit: isCredit,
      status: status,
    );
  }

  static bool _isCreditType(String transactionType) {
    switch (transactionType.toLowerCase()) {
      case 'refund':
      case 'credit':
      case 'top_up':
      case 'topup':
        return true;
      default:
        return false;
    }
  }

  static String _toTitleCase(String value) {
    final normalized = value.replaceAll('_', ' ').trim();
    if (normalized.isEmpty) {
      return '';
    }

    return normalized
        .split(RegExp(r'\s+'))
        .map((word) {
          final lower = word.toLowerCase();
          return '${lower[0].toUpperCase()}${lower.substring(1)}';
        })
        .join(' ');
  }
}
