import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/booking_confirmation_controller.dart';

class BookingConfirmationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BookingConfirmationController>(
      () => BookingConfirmationController(
        getVehiclesUsecase: sl(),
        createSubscriptionsUsecase: sl(),
        getPricingPlansUsecase: sl(),
        authService: sl(),
      ),
    );
  }
}
