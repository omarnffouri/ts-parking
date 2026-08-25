import 'package:flutter_stripe/flutter_stripe.dart';

import '../errors/exceptions.dart';

abstract class StripeCardTokenService {
  Future<String> createCardPaymentMethodId({String? cardholderName});
}

class StripeCardTokenServiceImpl implements StripeCardTokenService {
  @override
  Future<String> createCardPaymentMethodId({String? cardholderName}) async {
    if (Stripe.publishableKey.isEmpty) {
      throw const ValidationException(
        'Stripe is not configured. Set STRIPE_PUBLISHABLE_KEY first.',
      );
    }

    try {
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(
            billingDetails: BillingDetails(
              name: cardholderName?.isEmpty ?? true ? null : cardholderName,
            ),
          ),
        ),
      );
      return paymentMethod.id;
    } on StripeException catch (error) {
      throw ValidationException(
        error.error.localizedMessage ??
            error.error.message ??
            'Unable to create payment method.',
      );
    } catch (_) {
      throw const ServerException('Unable to create payment method.');
    }
  }
}
