import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(registerUsecase: sl()),
    );
  }
}
