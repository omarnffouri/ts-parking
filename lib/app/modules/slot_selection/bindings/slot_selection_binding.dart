import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../controllers/slot_selection_controller.dart';

class SlotSelectionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SlotSelectionController>(
      () => SlotSelectionController(
        getYardSlotsUsecase: sl(),
        getVehicleTypesUsecase: sl(),
        getPricingPlansUsecase: sl(),
      ),
    );
  }
}
