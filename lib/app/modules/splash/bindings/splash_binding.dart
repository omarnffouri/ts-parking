import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(
      () => SplashController(authService: sl(), storage: sl()),
    );
  }
}
