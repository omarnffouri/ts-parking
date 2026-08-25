import '../entities/create_subscription_response_entity.dart';

class PaymentArgs {
  final CreateSubscriptionResponseEntity response;
  final String yardName;

  const PaymentArgs({required this.response, required this.yardName});
}
