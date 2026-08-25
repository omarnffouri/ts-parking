import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/payment_method_controller.dart';

class PaymentMethodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentMethodController>(
      () => PaymentMethodController(
        addCardUsecase: sl(),
        deleteCardUsecase: sl(),
        getTransactionsUsecase: sl(),
        getUserCardsUsecase: sl(),
        setDefaultCardUsecase: sl(),
        stripeCardTokenService: sl(),
      ),
    );
  }
}
