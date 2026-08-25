import 'package:equatable/equatable.dart';

import 'overstay_item_entity.dart';
import 'subscription_entity.dart';

class InvoiceEntity extends Equatable {
  final int id;
  final String invoiceNumber;
  final String invoiceType;
  final String status;
  final double subtotal;
  final double discountAmount;
  final double tax;
  final double total;
  final DateTime issuedAt;
  final DateTime? dueAt;
  final DateTime? paidAt;
  final String? pdfUrl;
  final List<SubscriptionEntity> subscriptions;
  final List<OverstayItemEntity> overstays;

  const InvoiceEntity({
    required this.id,
    required this.invoiceNumber,
    required this.invoiceType,
    required this.status,
    required this.subtotal,
    required this.discountAmount,
    required this.tax,
    required this.total,
    required this.issuedAt,
    this.dueAt,
    this.paidAt,
    this.pdfUrl,
    this.subscriptions = const [],
    this.overstays = const [],
  });

  bool get isOverstay => invoiceType.toLowerCase() == 'overstay';
  bool get isSubscription => invoiceType.toLowerCase() == 'subscription';

  @override
  List<Object?> get props => [
    id,
    invoiceNumber,
    invoiceType,
    status,
    subtotal,
    discountAmount,
    tax,
    total,
    issuedAt,
    dueAt,
    paidAt,
    pdfUrl,
    subscriptions,
    overstays,
  ];
}
