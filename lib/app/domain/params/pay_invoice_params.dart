class PayInvoiceParams {
  static const String methodCard = 'card';
  static const String methodCash = 'cash';

  final int invoiceId;
  final String paymentMethod;
  final String? paymentToken;

  const PayInvoiceParams({
    required this.invoiceId,
    required this.paymentMethod,
    this.paymentToken,
  });

  bool get isCash => paymentMethod == 'cash';

  Map<String, dynamic> toJson() => {
    'invoice_id': invoiceId,
    'payment_method': paymentMethod,
    if (paymentToken != null) 'payment_token': paymentToken,
  };
}
