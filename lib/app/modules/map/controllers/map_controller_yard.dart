part of 'map_controller.dart';

extension MapControllerYardX on MapController {
  Future<void> openSlotSheet(BuildContext context, SlotEntity slot) async {
    _selectedSlot.value = slot;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SlotDetailsSheet(slot: slot),
    );
    _selectedSlot.value = null;
  }

  void bookSelectedSlot([SlotEntity? slot]) {
    final selected = slot ?? _selectedSlot.value;
    if (selected == null) return;

    Get.toNamed(
      Routes.BOOKING_CONFIRMATION,
      arguments: BookingConfirmationArgs(
        yardId: _resolvedYardId,
        yardName: yardName,
        yardAddress: _resolvedYardAddress,
        zone: ZoneEntity(
          id: selected.zoneId.toString(),
          name: selected.zoneName,
          yardId: _resolvedYardId,
        ),
        vehicleType: selected.vehicleType,
        selectedSlots: [selected],
      ),
    );
  }

  void _initializeYardContext() {
    final argument = initialArguments ?? Get.arguments;
    if (argument is YardEntity) {
      _setYardContext(
        id: argument.id,
        name: argument.name,
        address: argument.address,
      );
      _loadSlotsForYard(argument.id);
      return;
    }

    if (argument is String && argument.trim().isNotEmpty) {
      _setYardContext(id: argument.trim());
      _loadSlotsForYard(argument.trim());
      return;
    }

    _syncYardFromDiscovery();
    final discovery = yardDiscoveryController;
    if (discovery == null) return;

    _yardSyncWorker = ever<List<YardEntity>>(
      discovery.allYardsRx,
      (_) => _syncYardFromDiscovery(),
    );
  }

  void _syncYardFromDiscovery() {
    final discovery = yardDiscoveryController;
    final yard = discovery?.allYardsRx.firstOrNull;
    if (yard == null) return;

    _setYardContext(id: yard.id, name: yard.name, address: yard.address);
    _loadSlotsForYard(yard.id);
  }

  void _setYardContext({required String id, String? name, String? address}) {
    _yardId = id.trim();
    if (name != null && name.trim().isNotEmpty) {
      _yardName = name.trim();
    }
    if (address != null && address.trim().isNotEmpty) {
      _yardAddress = address.trim();
    }
  }

  Future<void> _loadSlotsForYard(String yardId, {bool force = false}) async {
    final normalizedYardId = yardId.trim();
    if (normalizedYardId.isEmpty || getYardSlotsUsecase == null) return;
    if (!force && (_isLoading.value || _loadedYardId == normalizedYardId)) {
      return;
    }

    final isSwitchingYards = _loadedYardId != normalizedYardId;
    final fallbackConfig = isSwitchingYards
        ? _emptyMapConfig
        : _activeMapConfig.value;

    if (isSwitchingYards) {
      _activeMapConfig.value = _emptyMapConfig;
      _focusedZoneId.value = null;
      _selectedSlot.value = null;
      _resetTruckState();
    }

    _isLoading.value = true;

    final result = await getYardSlotsUsecase!.execute(
      yardId: normalizedYardId,
      page: 1,
      limit: 500,
    );

    result.fold(
      (failure) {
        _loadedYardId = null;
        _activeMapConfig.value = fallbackConfig;
      },
      (response) {
        _loadedYardId = normalizedYardId;
        _activeMapConfig.value = mapConfig.withApiSlots(response.data);
        if (focusedZoneId != null && focusedZone == null) {
          _focusedZoneId.value = null;
        }
        _selectedSlot.value = null;
      },
    );

    _isLoading.value = false;
  }
}
