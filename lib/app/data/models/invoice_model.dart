import '../../domain/entities/invoice_entity.dart';
import 'overstay_item_model.dart';
import 'subscription_model.dart';

class InvoiceModel extends InvoiceEntity {
  const InvoiceModel({
    required super.id,
    required super.invoiceNumber,
    required super.invoiceType,
    required super.status,
    required super.subtotal,
    required super.discountAmount,
    required super.tax,
    required super.total,
    required super.issuedAt,
    super.dueAt,
    super.paidAt,
    super.pdfUrl,
    super.subscriptions,
    super.overstays,
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final discount = json['discount_amount'] ?? json['discount'];
    final subsJson = json['subscriptions'] as List<dynamic>?;
    final overstaysJson = json['overstays'] as List<dynamic>?;
    return InvoiceModel(
      id: json['id'] as int? ?? 0,
      invoiceNumber: json['invoice_number']?.toString() ?? '',
      invoiceType: json['invoice_type']?.toString() ?? 'subscription',
      status: json['status']?.toString() ?? 'pending',
      subtotal: double.tryParse(json['subtotal']?.toString() ?? '') ?? 0.0,
      discountAmount: double.tryParse(discount?.toString() ?? '') ?? 0.0,
      tax: double.tryParse(json['tax']?.toString() ?? '') ?? 0.0,
      total: double.tryParse(json['total']?.toString() ?? '') ?? 0.0,
      issuedAt: json['issued_at'] != null
          ? DateTime.parse(json['issued_at'].toString())
          : DateTime.now(),
      dueAt: json['due_at'] != null
          ? DateTime.parse(json['due_at'].toString())
          : null,
      paidAt: json['paid_at'] != null
          ? DateTime.parse(json['paid_at'].toString())
          : null,
      pdfUrl: json['pdf_url'] as String?,
      subscriptions:
          subsJson
              ?.map(
                (e) => SubscriptionModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
      overstays:
          overstaysJson
              ?.map(
                (e) => OverstayItemModel.fromJson(e as Map<String, dynamic>),
              )
              .toList() ??
          const [],
    );
  }
}
