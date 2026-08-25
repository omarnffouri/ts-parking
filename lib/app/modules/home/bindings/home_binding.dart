import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController(getVehiclesUsecase: sl()));
  }
}
