import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../../home/controllers/home_controller.dart';
import '../../home/controllers/yard_discovery_controller.dart';
import '../../map/controllers/map_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../controllers/main_screen_controller.dart';

class MainScreenBinding extends Bindings {
  @override
  void dependencies() {
    // YardDiscoveryController registered first as permanent singleton so both
    // Home and Map tabs can access it via Get.find().
    Get.put<YardDiscoveryController>(
      YardDiscoveryController(getYardsUsecase: sl()),
      permanent: true,
    );

    Get.lazyPut<MainScreenController>(() => MainScreenController());
    Get.lazyPut<HomeController>(() => HomeController(getVehiclesUsecase: sl()));
    Get.lazyPut<MapController>(
      () => MapController(
        getYardSlotsUsecase: sl(),
        yardDiscoveryController: Get.find<YardDiscoveryController>(),
      ),
    );
    Get.lazyPut<ProfileController>(
      () => ProfileController(
        authService: sl(),
        storage: sl(),
        uploadProfileImageUsecase: sl(),
        deleteAccountUsecase: sl(),
      ),
    );
  }
}
