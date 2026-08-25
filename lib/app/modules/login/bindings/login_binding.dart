import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        loginUsecase: sl(),
        sendOtpUsecase: sl(),
        authService: sl(),
      ),
    );
  }
}
