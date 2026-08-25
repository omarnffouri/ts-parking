import '../entities/invoice_entity.dart';
import '../entities/subscription_entity.dart';

class PaymentSuccessArgs {
  final List<SubscriptionEntity> subscriptions;
  final InvoiceEntity? invoice;

  const PaymentSuccessArgs({required this.subscriptions, this.invoice});
}
