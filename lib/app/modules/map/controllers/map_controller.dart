import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../domain/entities/slot_entity.dart';
import '../../../domain/entities/yard_entity.dart';
import '../../../domain/entities/zone_entity.dart';
import '../../../domain/params/booking_confirmation_args.dart';
import '../../../domain/usecases/get_yard_slots_usecase.dart';
import '../../../routes/app_pages.dart';
import '../../home/controllers/yard_discovery_controller.dart';
import '../models/floorplan_config.dart';
import '../views/widgets/slot_details_sheet.dart';
import '../views/widgets/zone_slots_sheet.dart';

part 'map_controller_camera.dart';
part 'map_controller_truck.dart';
part 'map_controller_yard.dart';
part 'map_controller_zone.dart';

enum TruckArrivalVisual { side, topDown }

class MapController extends GetxController
    with GetSingleTickerProviderStateMixin {
  static const truckTravelDuration = Duration(milliseconds: 520);
  static const truckFadeDuration = Duration(milliseconds: 140);
  static const denseZoneSlotThreshold = 150;
  static const southDenseZoneSlotThreshold = 200;

  static const _defaultEmptySlotColor = Color(0xFFD0D0D0);
  static const _userTypePalette = [
    Color(0xFF74D99F),
    Color(0xFF6BCBFF),
    Color(0xFFFFB86C),
    Color(0xFFFF8E8E),
    Color(0xFFB39DDB),
  ];

  final GetYardSlotsUsecase? getYardSlotsUsecase;
  final YardDiscoveryController? yardDiscoveryController;
  final Object? initialArguments;
  final ParkingMapConfig mapConfig;
  final TransformationController transformationController =
      TransformationController();

  final _focusedZoneId = RxnString();
  final _selectedSlot = Rxn<SlotEntity>();
  String _yardId = '';
  String _yardName = '';
  String _yardAddress = '';
  final _isLoading = false.obs;
  final _activeMapConfig = Rx<ParkingMapConfig>(ParkingMapConfig.primary);
  final _truckRect = Rxn<Rect>();
  final _truckVisible = false.obs;
  final _truckArrivalVisual = TruckArrivalVisual.side.obs;
  final _truckRotation = 0.0.obs;

  late final ParkingMapConfig _emptyMapConfig;
  late final AnimationController _zoomAnimationController;
  Animation<Matrix4>? _zoomAnimation;
  Worker? _yardSyncWorker;

  Size? _viewportSize;
  Rect? _viewportOverviewBounds;
  Matrix4 _overviewTransform = Matrix4.identity();
  double _overviewScale = 1.0;
  String? _loadedYardId;
  int _truckAnimationRun = 0;

  MapController({
    this.getYardSlotsUsecase,
    this.initialArguments,
    YardDiscoveryController? yardDiscoveryController,
    ParkingMapConfig? mapConfig,
  }) : yardDiscoveryController =
           yardDiscoveryController ??
           (Get.isRegistered<YardDiscoveryController>()
               ? Get.find<YardDiscoveryController>()
               : null),
       mapConfig = mapConfig ?? ParkingMapConfig.primary {
    _emptyMapConfig = this.mapConfig.withoutSlots();
    _activeMapConfig.value = _emptyMapConfig;
  }

  String? get focusedZoneId => _focusedZoneId.value;
  bool get isLoading => _isLoading.value;
  ParkingMapConfig get activeMapConfig => _activeMapConfig.value;
  String get _resolvedYardId =>
      _yardId.trim().isNotEmpty ? _yardId : mapConfig.yardId;
  String get yardName =>
      _yardName.trim().isNotEmpty ? _yardName : mapConfig.yardName;
  String get _resolvedYardAddress =>
      _yardAddress.trim().isNotEmpty ? _yardAddress : mapConfig.yardAddress;
  double get minInteractiveScale => _overviewScale;
  double get maxInteractiveScale {
    final designHeight = activeMapConfig.designSize.height;
    final textureSafeScale = (7600 / designHeight).clamp(3.8, 4.75);
    return math.max(minInteractiveScale, textureSafeScale);
  }

  Rect? get truckRect => _truckRect.value;
  bool get truckVisible => _truckVisible.value;
  TruckArrivalVisual get truckArrivalVisual => _truckArrivalVisual.value;
  double get truckRotation => _truckRotation.value;

  ParkingZoneConfig? get focusedZone => activeMapConfig.zones.firstWhereOrNull(
    (zone) => zone.id == _focusedZoneId.value,
  );

  @override
  void onInit() {
    super.onInit();
    _zoomAnimationController =
        AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 320),
        )..addListener(() {
          final value = _zoomAnimation?.value;
          if (value != null) {
            transformationController.value = value;
          }
        });
    _initializeYardContext();
  }

  @override
  void onClose() {
    _yardSyncWorker?.dispose();
    _zoomAnimationController.dispose();
    transformationController.dispose();
    super.onClose();
  }
}
