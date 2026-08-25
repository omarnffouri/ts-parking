class PayOverstayChargeParams {
  static const String methodCard = 'card';
  static const String methodCash = 'cash';

  final int chargeId;
  final String paymentMethod;
  final String? paymentToken;

  const PayOverstayChargeParams({
    required this.chargeId,
    required this.paymentMethod,
    this.paymentToken,
  });

  bool get isCash => paymentMethod == methodCash;

  Map<String, dynamic> toJson() => {
    'payment_method': paymentMethod,
    if (paymentToken != null) 'payment_token': paymentToken,
  };
}
