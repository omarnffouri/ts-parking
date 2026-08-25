import 'package:get/get.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../domain/entities/vehicle_entity.dart';
import '../../../core/enums/user_type.dart';
import '../../../domain/usecases/delete_vehicle_usecase.dart';
import '../../../domain/usecases/get_vehicles_usecase.dart';
import '../../../routes/app_pages.dart';

class MyVehiclesController extends GetxController {
  final GetVehiclesUsecase getVehiclesUsecase;
  final DeleteVehicleUsecase deleteVehicleUsecase;
  final AuthService authService;

  MyVehiclesController({
    required this.getVehiclesUsecase,
    required this.deleteVehicleUsecase,
    required this.authService,
  });

  final _vehicles = <VehicleEntity>[].obs;
  final _orderedVehicles = <VehicleEntity>[].obs;
  final _isLoading = false.obs;
  final _isListView = false.obs;

  List<VehicleEntity> get vehicles => _vehicles;
  List<VehicleEntity> get orderedVehicles => _orderedVehicles;
  bool get isLoading => _isLoading.value;
  bool get isListView => _isListView.value;
  bool get isClient => authService.currentUser?.userType == UserType.client;

  @override
  void onReady() {
    super.onReady();
    loadVehicles();
  }

  Future<void> loadVehicles() async {
    _isLoading.value = true;
    final result = await getVehiclesUsecase.execute();
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      list,
    ) {
      _vehicles.assignAll(list);
      _syncOrderedVehicles(list);
    });
    _isLoading.value = false;
  }

  Future<void> deleteVehicle(String vehicleId) async {
    final result = await deleteVehicleUsecase.execute(vehicleId);
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      _,
    ) async {
      await loadVehicles();
      ErrorHandler.showSuccess('Vehicle deleted');
      if (_vehicles.isEmpty) {
        Get.offAllNamed(Routes.ADD_VEHICLE);
      }
    });
  }

  Future<void> navigateToAddVehicle() async {
    await Get.toNamed(Routes.ADD_VEHICLE, arguments: 'from_my_vehicles');
    await loadVehicles();
  }

  Future<void> navigateToEditVehicle(VehicleEntity vehicle) async {
    await Get.toNamed(Routes.ADD_VEHICLE, arguments: vehicle);
    await loadVehicles();
  }

  Future<void> confirmDelete(VehicleEntity vehicle) async {
    final confirmed = await ConfirmDialog.show(
      title: 'Delete Vehicle',
      message: 'Delete ${vehicle.licensePlate}? This cannot be undone.',
      confirmLabel: 'Delete',
      destructive: true,
    );
    if (confirmed) {
      await deleteVehicle(vehicle.id);
    }
  }

  void swapVehicles(String draggedVehicleId, int targetIndex) {
    final sourceIndex = _orderedVehicles.indexWhere(
      (vehicle) => vehicle.id == draggedVehicleId,
    );

    if (sourceIndex == -1 ||
        targetIndex < 0 ||
        targetIndex >= _orderedVehicles.length ||
        sourceIndex == targetIndex) {
      return;
    }

    final updated = List<VehicleEntity>.from(_orderedVehicles);
    final draggedVehicle = updated[sourceIndex];
    updated[sourceIndex] = updated[targetIndex];
    updated[targetIndex] = draggedVehicle;
    _orderedVehicles.assignAll(updated);
  }

  void toggleViewMode() {
    _isListView.toggle();
  }

  void _syncOrderedVehicles(List<VehicleEntity> vehicles) {
    final currentIds = _orderedVehicles.map((vehicle) => vehicle.id).toList();
    final nextIds = vehicles.map((vehicle) => vehicle.id).toList();

    if (!_sameIds(currentIds, nextIds)) {
      _orderedVehicles.assignAll(vehicles);
      return;
    }

    final vehiclesById = {for (final vehicle in vehicles) vehicle.id: vehicle};
    _orderedVehicles.assignAll(
      _orderedVehicles
          .map((vehicle) => vehiclesById[vehicle.id] ?? vehicle)
          .toList(),
    );
  }

  bool _sameIds(List<String> a, List<String> b) {
    if (a.length != b.length) return false;

    for (var i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }

    return true;
  }
}
