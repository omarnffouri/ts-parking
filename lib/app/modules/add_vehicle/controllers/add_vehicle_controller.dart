import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/injection_container.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../domain/entities/vehicle_entity.dart';
import '../../../domain/entities/vehicle_type_entity.dart';
import '../../../core/enums/parking_vehicle_type.dart';
import '../../../domain/params/add_vehicle_params.dart';
import '../../../domain/params/update_vehicle_params.dart';
import '../../../domain/usecases/add_vehicle_usecase.dart';
import '../../../domain/usecases/get_vehicle_types_usecase.dart';
import '../../../domain/usecases/update_vehicle_usecase.dart';
import '../../../routes/app_pages.dart';

class AddVehicleController extends GetxController {
  final AddVehicleUsecase addVehicleUsecase;
  final UpdateVehicleUsecase updateVehicleUsecase;
  final GetVehicleTypesUsecase getVehicleTypesUsecase;

  AddVehicleController({
    required this.addVehicleUsecase,
    required this.updateVehicleUsecase,
    required this.getVehicleTypesUsecase,
  });

  final formKey = GlobalKey<FormState>();
  final plateController = TextEditingController();
  final nicknameController = TextEditingController();
  final modelController = TextEditingController();
  final colorController = TextEditingController();
  final yearController = TextEditingController();

  final _vehicleTypes = <VehicleTypeEntity>[].obs;
  final _selectedTypeId = Rxn<int>();
  final _isLoading = false.obs;
  final _isLoadingTypes = false.obs;

  VehicleEntity? _editingVehicle;

  List<VehicleTypeEntity> get vehicleTypes => _vehicleTypes;
  int? get selectedTypeId => _selectedTypeId.value;
  bool get isLoading => _isLoading.value;
  bool get isLoadingTypes => _isLoadingTypes.value;
  bool get isEditMode => _editingVehicle != null;

  bool get isGateMode {
    final args = Get.arguments;
    if (args is VehicleEntity) return false;
    if (args is String && args == 'from_my_vehicles') return false;
    if (args is Map && args['source'] == 'from_booking') return false;
    return !isEditMode;
  }

  @override
  void onInit() {
    super.onInit();
    _loadVehicleTypes();

    final args = Get.arguments;
    if (args is VehicleEntity) {
      _editingVehicle = args;
      plateController.text = args.licensePlate;
      _selectedTypeId.value = args.vehicleTypeId;
    } else if (args is Map && args['vehicleTypeId'] is int) {
      _selectedTypeId.value = args['vehicleTypeId'] as int;
    }
  }

  Future<void> _loadVehicleTypes() async {
    _isLoadingTypes.value = true;
    final result = await getVehicleTypesUsecase.execute();
    result.fold((failure) => ErrorHandler.showError('Error', failure.message), (
      types,
    ) {
      types.sort((a, b) {
        final typeA = ParkingVehicleTypeX.fromApiName(a.name);
        final typeB = ParkingVehicleTypeX.fromApiName(b.name);
        return typeA.index.compareTo(typeB.index);
      });
      _vehicleTypes.assignAll(types);
    });
    _isLoadingTypes.value = false;
  }

  void selectType(int typeId) {
    _selectedTypeId.value = typeId;
  }

  Future<void> submit() async {
    if (_selectedTypeId.value == null) {
      ErrorHandler.showError(
        'Validation Error',
        'Please select a vehicle type',
      );
      return;
    }

    if (formKey.currentState?.validate() != true) return;

    _isLoading.value = true;

    try {
      final nickname = nicknameController.text.trim().isEmpty
          ? null
          : nicknameController.text.trim();
      final model = modelController.text.trim().isEmpty
          ? null
          : modelController.text.trim();
      final color = colorController.text.trim().isEmpty
          ? null
          : colorController.text.trim();
      final year = int.tryParse(yearController.text.trim());

      if (isEditMode) {
        final result = await updateVehicleUsecase.execute(
          UpdateVehicleParams(
            id: _editingVehicle!.id,
            vehicleTypeId: _selectedTypeId.value,
            licensePlate: plateController.text.trim(),
            nickname: nickname,
            model: model,
            color: color,
            year: year,
          ),
        );

        result.fold(
          (failure) => ErrorHandler.showError('Error', failure.message),
          (_) {
            Get.back(result: true);
            ErrorHandler.showSuccess('Vehicle updated successfully');
          },
        );
      } else {
        final result = await addVehicleUsecase.execute(
          AddVehicleParams(
            vehicleTypeId: _selectedTypeId.value!,
            licensePlate: plateController.text.trim(),
            nickname: nickname,
            model: model,
            color: color,
            year: year,
          ),
        );

        result.fold(
          (failure) => ErrorHandler.showError('Error', failure.message),
          (_) {
            if (isGateMode) {
              Get.offAllNamed(Routes.MAIN_SCREEN);
              ErrorHandler.showSuccess('Vehicle added successfully');
            } else {
              Get.back(result: true);
              ErrorHandler.showSuccess('Vehicle added successfully');
            }
          },
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> switchAccount() async {
    await sl<AuthService>().logout();
    Get.offAllNamed(Routes.LOGIN);
  }

  String? validatePlate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'License plate is required';
    }
    if (value.trim().length < 2) {
      return 'License plate must be at least 2 characters';
    }
    return null;
  }

  @override
  void onClose() {
    plateController.dispose();
    nicknameController.dispose();
    modelController.dispose();
    colorController.dispose();
    yearController.dispose();
    super.onClose();
  }
}
