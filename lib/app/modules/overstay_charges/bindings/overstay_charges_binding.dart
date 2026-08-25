import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/overstay_charges_controller.dart';

class OverstayChargesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OverstayChargesController>(
      () => OverstayChargesController(
        getVehicleChargesUsecase: sl(),
        payOverstayChargeUsecase: sl(),
        getUserCardsUsecase: sl(),
        addCardUsecase: sl(),
        stripeCardTokenService: sl(),
      ),
    );
  }
}
