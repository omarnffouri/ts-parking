import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/on_boarding_controller.dart';

class OnBoardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnBoardingController>(
      () => OnBoardingController(storage: sl()),
    );
  }
}
