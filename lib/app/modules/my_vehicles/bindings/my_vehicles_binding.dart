import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/my_vehicles_controller.dart';

class MyVehiclesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MyVehiclesController>(
      () => MyVehiclesController(
        getVehiclesUsecase: sl(),
        deleteVehicleUsecase: sl(),
        authService: sl(),
      ),
    );
  }
}
