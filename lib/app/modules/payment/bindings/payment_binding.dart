import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/payment_controller.dart';

class PaymentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PaymentController>(
      () => PaymentController(
        payInvoiceUsecase: sl(),
        getUserCardsUsecase: sl(),
        addCardUsecase: sl(),
        stripeCardTokenService: sl(),
      ),
    );
  }
}
