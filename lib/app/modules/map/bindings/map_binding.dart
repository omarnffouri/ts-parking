import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../../home/controllers/yard_discovery_controller.dart';
import '../controllers/map_controller.dart';

class MapBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<YardDiscoveryController>()) {
      Get.lazyPut<YardDiscoveryController>(
        () => YardDiscoveryController(getYardsUsecase: sl()),
      );
    }

    Get.lazyPut<MapController>(
      () => MapController(
        getYardSlotsUsecase: sl(),
        yardDiscoveryController: Get.find<YardDiscoveryController>(),
      ),
    );
  }
}
