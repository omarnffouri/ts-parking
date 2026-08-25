import 'package:get/get.dart';

import '../../../domain/usecases/get_vehicles_usecase.dart';
import '../../../routes/app_pages.dart';
import 'yard_discovery_controller.dart';

class HomeController extends GetxController {
  final GetVehiclesUsecase getVehiclesUsecase;
  late final YardDiscoveryController _yardDiscoveryController;

  HomeController({required this.getVehiclesUsecase});

  final userName = 'Echo'.obs;
  final _isGateChecking = true.obs;

  bool get isGateChecking => _isGateChecking.value;

  @override
  void onReady() {
    super.onReady();
    _checkVehicleGate();
  }

  @override
  void onInit() {
    super.onInit();
    _yardDiscoveryController = Get.find<YardDiscoveryController>();
  }

  Future<void> _checkVehicleGate() async {
    final result = await getVehiclesUsecase.execute();
    result.fold(
      // Fail open — don't block user if backend error
      (failure) => _isGateChecking.value = false,
      (vehicles) {
        if (vehicles.isEmpty) {
          Get.offAllNamed(Routes.ADD_VEHICLE);
        } else {
          _isGateChecking.value = false;
        }
      },
    );
  }

  Future<void> refreshHome() async {
    await _yardDiscoveryController.refreshYards();
  }
}
