import 'package:get/get.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';

import '../../../core/utils/error_handler.dart';
import '../../../data/models/paginated_response.dart';
import '../../../core/enums/parking_vehicle_type.dart';
import '../../../domain/entities/slot_entity.dart';
import '../../../domain/entities/vehicle_type_entity.dart';
import '../../../domain/entities/yard_entity.dart';
import '../../../domain/entities/zone_entity.dart';
import '../../../domain/params/booking_confirmation_args.dart';
import '../../../domain/entities/pricing_plan_entity.dart';
import '../../../domain/usecases/get_pricing_plans_usecase.dart';
import '../../../domain/usecases/get_vehicle_types_usecase.dart';
import '../../../domain/usecases/get_yard_slots_usecase.dart';
import '../../../routes/app_pages.dart';

class SlotSelectionController extends GetxController {
  static const int _slotPageLimit = 300;

  final GetYardSlotsUsecase getYardSlotsUsecase;
  final GetVehicleTypesUsecase getVehicleTypesUsecase;
  final GetPricingPlansUsecase getPricingPlansUsecase;
  final Object? initialArguments;

  SlotSelectionController({
    required this.getYardSlotsUsecase,
    required this.getVehicleTypesUsecase,
    required this.getPricingPlansUsecase,
    this.initialArguments,
  });

  late final String yardId;
  late final String yardName;
  late final String yardAddress;

  final _allSlots = <SlotEntity>[];
  final slots = <SlotEntity>[].obs;
  final selectedSlotIds = <int>{}.obs;
  final selectedVehicleTypeId = Rxn<int>();
  final availableVehicleTypes = <VehicleTypeEntity>[].obs;
  final availableZones = <String>[].obs;
  final selectedZoneName = ''.obs;
  final showAvailableOnly = false.obs;
  final selectedStatusFilter = Rxn<SlotStatus>();
  final _slotCurrentPage = 1.obs;
  final _slotTotalItems = 0.obs;
  final _slotHasMorePages = false.obs;
  final _isLoadingMoreSlots = false.obs;
  final _isLoading = true.obs;
  final _error = ''.obs;
  final pricingPlans = <PricingPlanEntity>[].obs;
  final _isLoadingPlans = false.obs;

  bool get isLoadingPlans => _isLoadingPlans.value;

  bool get isLoading => _isLoading.value;
  bool get isLoadingMoreSlots => _isLoadingMoreSlots.value;
  bool get hasMoreSlotPages => _slotHasMorePages.value;
  int get slotCurrentPage => _slotCurrentPage.value;
  int get slotTotalItems => _slotTotalItems.value;
  String get error => _error.value;
  VehicleTypeEntity? get selectedVehicleTypeOption => availableVehicleTypes
      .firstWhereOrNull((type) => type.id == selectedVehicleTypeId.value);
  String get selectedVehicleTypeLabel {
    final name = selectedVehicleTypeOption?.name.trim() ?? '';
    return name.isEmpty ? 'Truck' : name;
  }

  @override
  void onInit() {
    super.onInit();
    final arg = initialArguments ?? Get.arguments;
    if (arg is YardEntity) {
      yardId = arg.id;
      yardName = arg.name;
      yardAddress = arg.address;
    } else {
      yardId = arg?.toString() ?? '';
      yardName = 'Yard $yardId';
      yardAddress = '';
    }
    _loadSlots();
  }

  Future<void> _loadSlots() async {
    _isLoading.value = true;
    _error.value = '';
    _slotCurrentPage.value = 1;
    _slotTotalItems.value = 0;
    _slotHasMorePages.value = false;
    _isLoadingMoreSlots.value = false;

    final slotsResult = await getYardSlotsUsecase.execute(
      yardId: yardId,
      page: 1,
      limit: _slotPageLimit,
    );
    final vehicleTypesResult = await getVehicleTypesUsecase.execute();

    slotsResult.fold(
      (failure) {
        _allSlots.clear();
        availableVehicleTypes.clear();
        selectedVehicleTypeId.value = null;
        availableZones.clear();
        slots.clear();
        selectedSlotIds.clear();
        selectedZoneName.value = '';
        _error.value = ErrorHandler.getErrorMessage(failure);
      },
      (response) {
        _allSlots
          ..clear()
          ..addAll(response.data);
        _applySlotPaginationMeta(response.meta);
        vehicleTypesResult.fold(
          (_) => _syncAvailableVehicleTypes(),
          (types) => _syncAvailableVehicleTypes(types),
        );
        _applySlotFilters();
      },
    );

    _isLoading.value = false;
  }

  Future<void> ensureSlotsForZonePage(
    String zoneName,
    int pageIndex, {
    required int slotsPerPage,
  }) async {
    if (_isLoading.value ||
        _isLoadingMoreSlots.value ||
        !_slotHasMorePages.value) {
      return;
    }

    final visibleGroup = visibleGroupedSlots.firstWhereOrNull(
      (group) => group.zoneName == zoneName,
    );
    final loadedPageCount =
        (((visibleGroup?.slots.length ?? 0) / slotsPerPage).ceil()).clamp(
          1,
          9999,
        );

    if (pageIndex < loadedPageCount - 1) return;
    await _loadMoreSlots();
  }

  Future<void> _loadMoreSlots() async {
    if (_isLoadingMoreSlots.value || !_slotHasMorePages.value) return;

    _isLoadingMoreSlots.value = true;

    final result = await getYardSlotsUsecase.execute(
      yardId: yardId,
      page: _slotCurrentPage.value + 1,
      limit: _slotPageLimit,
    );

    result.fold(
      (failure) => ErrorHandler.showError(
        'Error',
        ErrorHandler.getErrorMessage(failure),
      ),
      (response) {
        final existingIds = _allSlots.map((slot) => slot.id).toSet();
        for (final slot in response.data) {
          if (existingIds.add(slot.id)) {
            _allSlots.add(slot);
          }
        }
        _applySlotPaginationMeta(response.meta);
        _applySlotFilters();
      },
    );

    _isLoadingMoreSlots.value = false;
  }

  void _applySlotPaginationMeta(PaginationMeta meta) {
    _slotCurrentPage.value = meta.page;
    _slotTotalItems.value = meta.total;
    _slotHasMorePages.value = meta.hasMore;
  }

  void _applySlotFilters() {
    final selectedTypeName = selectedVehicleTypeOption?.name;
    final typeMatched = _allSlots
        .where(
          (slot) => _matchesVehicleType(slot.vehicleTypeName, selectedTypeName),
        )
        .toList(growable: false);
    _syncAvailableZones(typeMatched);
    slots.assignAll(typeMatched);
    final filteredIds = typeMatched.map((s) => s.id).toSet();
    selectedSlotIds.removeWhere((id) => !filteredIds.contains(id));
    _syncSelectionWithVisibleSlots();
  }

  void _syncAvailableVehicleTypes([List<VehicleTypeEntity>? apiVehicleTypes]) {
    final mapped = <VehicleTypeEntity>[];

    if (apiVehicleTypes != null && apiVehicleTypes.isNotEmpty) {
      mapped.addAll(apiVehicleTypes);
    }

    if (mapped.isEmpty) {
      final seenNames = <String>{};
      for (final slot in _allSlots) {
        final normalized = _normalizeVehicleTypeName(slot.vehicleTypeName);
        if (normalized.isEmpty || seenNames.contains(normalized)) continue;
        seenNames.add(normalized);
        mapped.add(
          VehicleTypeEntity(
            id: mapped.length + 1,
            name: slot.vehicleTypeName,
            price: 0,
          ),
        );
      }
    }

    mapped.sort((a, b) {
      final typeA = ParkingVehicleTypeX.fromApiName(a.name);
      final typeB = ParkingVehicleTypeX.fromApiName(b.name);
      return typeA.index.compareTo(typeB.index);
    });
    availableVehicleTypes.assignAll(mapped);
    final hasSelected = mapped.any(
      (type) => type.id == selectedVehicleTypeId.value,
    );
    if (mapped.isNotEmpty && !hasSelected) {
      selectedVehicleTypeId.value = mapped.first.id;
    }
  }

  void _syncAvailableZones(List<SlotEntity> slotsForType) {
    final mapped = <String>[];
    final seen = <String>{};

    for (final slot in slotsForType) {
      final zoneName = slot.zoneName.trim();
      if (zoneName.isEmpty || seen.contains(zoneName)) continue;
      seen.add(zoneName);
      mapped.add(zoneName);
    }

    availableZones.assignAll(mapped);
    if (mapped.isEmpty) {
      selectedZoneName.value = '';
      return;
    }
    if (!mapped.contains(selectedZoneName.value)) {
      selectedZoneName.value = mapped.first;
    }
  }

  // ---------------------------------------------------------------------------
  // Selection
  // ---------------------------------------------------------------------------

  bool isSelected(int slotId) => selectedSlotIds.contains(slotId);

  void selectVehicleType(VehicleTypeEntity vehicleType) {
    if (selectedVehicleTypeId.value == vehicleType.id) return;
    selectedVehicleTypeId.value = vehicleType.id;
    selectedSlotIds.clear();
    showAvailableOnly.value = false;
    selectedStatusFilter.value = null;
    _applySlotFilters();
  }

  void selectZone(String zoneName) {
    if (selectedZoneName.value == zoneName) return;
    selectedZoneName.value = zoneName;
    selectedSlotIds.clear();
    _applySlotFilters();
  }

  void toggleSlot(SlotEntity slot) {
    if (!slot.isBookable) return;
    if (selectedSlotIds.contains(slot.id)) {
      selectedSlotIds.remove(slot.id);
    } else {
      selectedSlotIds.add(slot.id);
    }
  }

  void handleSlotTap(SlotEntity slot) {
    if (!slot.isBookable) {
      _showSlotUnavailableFeedback(slot);
      return;
    }
    toggleSlot(slot);
  }

  void setAvailableOnly(bool value) {
    showAvailableOnly.value = value;
    _syncSelectionWithVisibleSlots();
  }

  bool isStatusFilterSelected(SlotStatus status) =>
      selectedStatusFilter.value == status;

  void toggleStatusFilter(SlotStatus status) {
    selectedStatusFilter.value = selectedStatusFilter.value == status
        ? null
        : status;
    _syncSelectionWithVisibleSlots();
  }

  bool get hasSelection => selectedSlotIds.isNotEmpty;

  int get selectedCount => selectedSlotIds.length;

  List<SlotEntity> get selectedSlots {
    final ids = selectedSlotIds;
    return slots.where((slot) => ids.contains(slot.id)).toList(growable: false);
  }

  SlotEntity? get primarySelectedSlot {
    final selected = selectedSlots;
    return selected.isEmpty ? null : selected.first;
  }

  double get selectedTotalPrice =>
      selectedSlots.fold(0.0, (total, slot) => total + slot.price);

  List<ZoneSlotGroup> get groupedSlots {
    final grouped = <ZoneSlotGroup>[];
    final seenZones = <String>{};

    for (final zoneName in availableZones) {
      final zoneSlots =
          slots
              .where((slot) => slot.zoneName == zoneName)
              .toList(growable: false)
            ..sort(_compareSlotsByCode);
      if (zoneSlots.isEmpty) continue;
      grouped.add(ZoneSlotGroup(zoneName: zoneName, slots: zoneSlots));
      seenZones.add(zoneName);
    }

    final remaining = <String, List<SlotEntity>>{};
    for (final slot in slots) {
      if (seenZones.contains(slot.zoneName)) continue;
      remaining.putIfAbsent(slot.zoneName, () => <SlotEntity>[]).add(slot);
    }

    remaining.forEach((zoneName, zoneSlots) {
      zoneSlots.sort(_compareSlotsByCode);
      grouped.add(ZoneSlotGroup(zoneName: zoneName, slots: zoneSlots));
    });

    return grouped;
  }

  List<ZoneSlotGroup> get visibleGroupedSlots {
    var visible = groupedSlots;

    final statusFilter = selectedStatusFilter.value;
    if (statusFilter != null) {
      return visible
          .map(
            (group) => ZoneSlotGroup(
              zoneName: group.zoneName,
              slots: group.slots
                  .where(
                    (slot) => statusFilter == SlotStatus.available
                        ? slot.isBookable
                        : !slot.isBookable,
                  )
                  .toList(growable: false),
            ),
          )
          .where((group) => group.slots.isNotEmpty)
          .toList(growable: false);
    }

    if (showAvailableOnly.value) {
      visible = visible
          .map(
            (group) => ZoneSlotGroup(
              zoneName: group.zoneName,
              slots: group.slots
                  .where((slot) => slot.isBookable)
                  .toList(growable: false),
            ),
          )
          .where((group) => group.slots.isNotEmpty)
          .toList(growable: false);
    }

    return visible;
  }

  int get availableCount => slots.where((slot) => slot.isBookable).length;

  Future<void> loadPricingPlans() async {
    if (pricingPlans.isNotEmpty) return;
    _isLoadingPlans.value = true;
    final result = await getPricingPlansUsecase.execute();
    result.fold(
      (failure) => ErrorHandler.showError('Error', failure.message),
      (plans) => pricingPlans.assignAll(plans),
    );
    _isLoadingPlans.value = false;
  }

  Future<void> retry() async {
    await _loadSlots();
  }

  void onContinue() {
    final selected = slots
        .where((s) => selectedSlotIds.contains(s.id))
        .toList(growable: false);
    final first = selected.isNotEmpty ? selected.first : slots.firstOrNull;

    final zone = ZoneEntity(
      id: (first?.zoneId ?? 0).toString(),
      name: first?.zoneName ?? 'Zone',
    );
    final vehicleType = _resolveVehicleType(
      first?.vehicleTypeName ?? selectedVehicleTypeOption?.name,
      ParkingVehicleType.truck,
    );

    Get.toNamed(
      Routes.BOOKING_CONFIRMATION,
      arguments: BookingConfirmationArgs(
        yardId: yardId,
        yardName: yardName,
        yardAddress: yardAddress,
        zone: zone,
        vehicleType: vehicleType,
        selectedSlots: selected,
      ),
    );
  }

  void _showSlotUnavailableFeedback(SlotEntity slot) {
    final code = slot.slotCode.trim().isEmpty
        ? 'This slot'
        : 'Slot ${slot.slotCode}';

    if (slot.activeSubscriptionUser != null) {
      ErrorHandler.showInfo(
        'Slot Unavailable',
        '$code is reserved under an active subscription and can\'t be booked.',
      );
      return;
    }

    ErrorHandler.showWarning('Slot Occupied', '$code is currently occupied.');
  }
}

bool _matchesVehicleType(String apiVehicleTypeName, String? selectedTypeName) {
  if ((selectedTypeName ?? '').trim().isEmpty) return true;
  return _normalizeVehicleTypeName(apiVehicleTypeName) ==
      _normalizeVehicleTypeName(selectedTypeName!);
}

ParkingVehicleType _resolveVehicleType(
  String? apiVehicleTypeName,
  ParkingVehicleType selectedType,
) {
  if (apiVehicleTypeName == null) return selectedType;
  return ParkingVehicleTypeX.fromApiName(apiVehicleTypeName);
}

String _normalizeVehicleTypeName(String value) =>
    value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');

int _compareSlotsByCode(SlotEntity a, SlotEntity b) {
  final prefixCompare = _slotCodePrefix(
    a.slotCode,
  ).compareTo(_slotCodePrefix(b.slotCode));
  if (prefixCompare != 0) return prefixCompare;

  final numberCompare = _slotCodeNumber(
    a.slotCode,
  ).compareTo(_slotCodeNumber(b.slotCode));
  if (numberCompare != 0) return numberCompare;

  return a.slotCode.compareTo(b.slotCode);
}

String _slotCodePrefix(String value) {
  final match = RegExp(r'^[^\d]+').firstMatch(value.trim());
  return (match?.group(0) ?? value).toLowerCase();
}

int _slotCodeNumber(String value) {
  final match = RegExp(r'(\d+)').firstMatch(value);
  return int.tryParse(match?.group(1) ?? '') ?? 0;
}

extension on SlotSelectionController {
  void _syncSelectionWithVisibleSlots() {
    final visibleIds = visibleGroupedSlots
        .expand((group) => group.slots)
        .map((slot) => slot.id)
        .toSet();
    selectedSlotIds.removeWhere((id) => !visibleIds.contains(id));
  }
}

class ZoneSlotGroup {
  final String zoneName;
  final List<SlotEntity> slots;

  const ZoneSlotGroup({required this.zoneName, required this.slots});
}
