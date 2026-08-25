class PaymentTransactionEntity {
  const PaymentTransactionEntity({
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.amount,
    required this.isCredit,
    required this.status,
  });

  final String title;
  final String subtitle;
  final String timeLabel;
  final String amount;
  final bool isCredit;
  final String status;
}
