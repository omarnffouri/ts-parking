import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/utils/error_handler.dart';
import '../../../core/enums/parking_vehicle_type.dart';
import '../../../domain/params/create_subscription_params.dart';
import '../../../domain/params/payment_args.dart';
import '../../../domain/params/payment_success_args.dart';
import '../../../routes/app_pages.dart';
import '../../payment/views/widgets/payment_success_view.dart';
import '../../../domain/entities/slot_entity.dart';
import '../../../domain/entities/vehicle_entity.dart';
import '../../../domain/entities/zone_entity.dart';
import '../../../domain/params/booking_confirmation_args.dart';
import '../../../domain/entities/pricing_plan_entity.dart';
import '../../../domain/usecases/create_subscriptions_usecase.dart';
import '../views/booking_summary_view.dart';
import '../../../domain/usecases/get_pricing_plans_usecase.dart';
import '../../../domain/usecases/get_vehicles_usecase.dart';

// ---------------------------------------------------------------------------
// Per-slot reactive selection state
// ---------------------------------------------------------------------------

class SlotSelection {
  final SlotEntity slot;
  final startDate = Rxn<DateTime>();
  final durationMonths = 1.obs;
  final vehicleId = Rxn<String>();
  final autoRenew = true.obs;

  SlotSelection({required this.slot});

  bool get isConfigured => startDate.value != null && vehicleId.value != null;
}

// ---------------------------------------------------------------------------
// Controller
// ---------------------------------------------------------------------------

class BookingConfirmationController extends GetxController {
  final GetVehiclesUsecase getVehiclesUsecase;
  final CreateSubscriptionsUsecase createSubscriptionsUsecase;
  final GetPricingPlansUsecase getPricingPlansUsecase;
  final AuthService authService;

  BookingConfirmationController({
    required this.getVehiclesUsecase,
    required this.createSubscriptionsUsecase,
    required this.getPricingPlansUsecase,
    required this.authService,
  });

  static final _displayDateFormat = DateFormat('dd MMM yyyy');
  static final _apiDateFormat = DateFormat('yyyy-MM-dd');

  // ---------------------------------------------------------------------------
  // State from args
  // ---------------------------------------------------------------------------

  late final String yardId;
  late final String yardName;
  late final String yardAddress;
  late final ZoneEntity zone;
  late final ParkingVehicleType vehicleType;
  late final List<SlotEntity> selectedSlots;

  // ---------------------------------------------------------------------------
  // Vehicles
  // ---------------------------------------------------------------------------

  final vehicles = <VehicleEntity>[].obs;
  final _vehiclesLoading = true.obs;

  bool get vehiclesLoading => _vehiclesLoading.value;

  /// Vehicles filtered by the selected vehicle type
  List<VehicleEntity> get filteredVehicles =>
      vehicles.where((v) => v.vehicleType == vehicleType).toList();

  // ---------------------------------------------------------------------------
  // Pricing plans
  // ---------------------------------------------------------------------------

  final plans = <PricingPlanEntity>[].obs;

  PricingPlanEntity? planForSlot(int slotId) {
    final slot = slotFor(slotId);
    return plans.firstWhereOrNull((p) => p.id == slot.planId.toString());
  }

  // ---------------------------------------------------------------------------
  // Per-slot selections
  // ---------------------------------------------------------------------------

  final slotSelections = <int, SlotSelection>{}.obs;

  // Track which slot card is expanded (-1 = none)
  final expandedSlotIndex = 0.obs;
  final _isSubmitting = false.obs;

  bool get isSubmitting => _isSubmitting.value;

  // ---------------------------------------------------------------------------
  // Getters
  // ---------------------------------------------------------------------------

  int get slotCount => selectedSlots.length;

  int get configuredCount =>
      slotSelections.values.where((s) => s.isConfigured).length;

  bool get canConfirm => slotSelections.values.every((s) => s.isConfigured);

  // ---------------------------------------------------------------------------
  // Per-slot getters
  // ---------------------------------------------------------------------------

  SlotSelection selectionFor(int slotId) => slotSelections[slotId]!;

  int monthsForSlot(int slotId) =>
      slotSelections[slotId]?.durationMonths.value ?? 1;

  static String monthLabel(int months) =>
      months == 1 ? '1 Month' : '$months Months';

  String durationLabelForSlot(int slotId) => monthLabel(monthsForSlot(slotId));

  SlotEntity slotFor(int slotId) =>
      selectedSlots.firstWhere((s) => s.id == slotId);

  double basePriceForSlot(int slotId) => slotFor(slotId).price;

  double totalPriceForSlot(int slotId) =>
      basePriceForSlot(slotId) * monthsForSlot(slotId);

  DateTime? endDateForSlot(int slotId) {
    final start = slotSelections[slotId]?.startDate.value;
    if (start == null) return null;
    final months = monthsForSlot(slotId);
    return DateTime(start.year, start.month + months, start.day);
  }

  String formattedStartDateForSlot(int slotId) {
    final date = slotSelections[slotId]?.startDate.value;
    if (date == null) return '';
    return _displayDateFormat.format(date);
  }

  String formattedEndDateForSlot(int slotId) {
    final date = endDateForSlot(slotId);
    if (date == null) return '';
    return _displayDateFormat.format(date);
  }

  // ---------------------------------------------------------------------------
  // Grand total
  // ---------------------------------------------------------------------------

  double get grandTotal =>
      slotSelections.keys.fold(0.0, (sum, id) => sum + totalPriceForSlot(id));

  // ---------------------------------------------------------------------------
  // Lifecycle
  // ---------------------------------------------------------------------------

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as BookingConfirmationArgs;
    yardId = args.yardId;
    yardName = args.yardName;
    yardAddress = args.yardAddress;
    zone = args.zone;
    vehicleType = args.vehicleType;
    selectedSlots = args.selectedSlots;

    for (final slot in selectedSlots) {
      slotSelections[slot.id] = SlotSelection(slot: slot);
    }

    _loadVehicles();
    _loadPlans();
  }

  Future<void> _loadPlans() async {
    final result = await getPricingPlansUsecase.execute();
    result.fold((_) {}, (data) => plans.assignAll(data));
  }

  Future<void> _loadVehicles() async {
    _vehiclesLoading.value = true;
    final result = await getVehiclesUsecase.execute();
    result.fold(
      (failure) => ErrorHandler.showError('Error', failure.message),
      (list) => vehicles.assignAll(list),
    );
    _vehiclesLoading.value = false;
  }

  // ---------------------------------------------------------------------------
  // Per-slot actions
  // ---------------------------------------------------------------------------

  /// Vehicles available for a given slot: excludes vehicles already assigned
  /// to other slots, but keeps the currently selected vehicle for this slot.
  List<VehicleEntity> availableVehiclesForSlot(int slotId) {
    final assignedToOthers = <String>{};
    for (final entry in slotSelections.entries) {
      if (entry.key == slotId) continue;
      final vid = entry.value.vehicleId.value;
      if (vid != null) assignedToOthers.add(vid);
    }
    return filteredVehicles
        .where((v) => !assignedToOthers.contains(v.id))
        .toList();
  }

  void selectVehicleForSlot(int slotId, String? vehicleId) {
    slotSelections[slotId]?.vehicleId.value = vehicleId;
    slotSelections.refresh();
  }

  VehicleEntity? vehicleForSlot(int slotId) {
    final id = slotSelections[slotId]?.vehicleId.value;
    if (id == null) return null;
    return vehicles.firstWhereOrNull((v) => v.id == id);
  }

  void selectDurationForSlot(int slotId, int months) {
    slotSelections[slotId]?.durationMonths.value = months;
    slotSelections.refresh();
  }

  Future<void> pickDateForSlot(BuildContext context, int slotId) async {
    final now = DateTime.now();
    final current = slotSelections[slotId]?.startDate.value;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 2),
    );
    if (picked != null) {
      slotSelections[slotId]?.startDate.value = picked;
      slotSelections.refresh();
    }
  }

  void toggleExpanded(int index) {
    expandedSlotIndex.value = expandedSlotIndex.value == index ? -1 : index;
  }

  // ---------------------------------------------------------------------------
  // Apply config from one slot to all others
  // ---------------------------------------------------------------------------

  void applyToAll(int sourceSlotId) {
    final source = slotSelections[sourceSlotId];
    if (source == null) return;

    for (final entry in slotSelections.entries) {
      if (entry.key == sourceSlotId) continue;
      entry.value.startDate.value = source.startDate.value;
      entry.value.durationMonths.value = source.durationMonths.value;
      // Skip vehicle — each slot must have a unique vehicle
      entry.value.autoRenew.value = source.autoRenew.value;
    }
    slotSelections.refresh();
  }

  // ---------------------------------------------------------------------------
  // Add vehicle
  // ---------------------------------------------------------------------------

  Future<void> navigateToAddVehicle() async {
    final result = await Get.toNamed(
      Routes.ADD_VEHICLE,
      arguments: {'source': 'from_booking', 'vehicleTypeId': vehicleType.apiId},
    );
    if (result == true) {
      await _loadVehicles();
    }
  }

  // ---------------------------------------------------------------------------
  // Summary
  // ---------------------------------------------------------------------------

  void navigateToSummary() {
    if (!canConfirm) return;
    Get.to(() => const BookingSummaryView());
  }

  // ---------------------------------------------------------------------------
  // Confirm
  // ---------------------------------------------------------------------------

  Future<void> onConfirm() async {
    if (!canConfirm || isSubmitting) return;
    _isSubmitting.value = true;

    try {
      final slotParams = slotSelections.entries.map((entry) {
        final selection = entry.value;
        final startDate = selection.startDate.value!;

        return SlotSubscriptionParam(
          slotId: selection.slot.id,
          autoRenew: selection.autoRenew.value,
          startDate: _apiDateFormat.format(startDate),
          duration: selection.durationMonths.value,
          vehicleId: int.parse(selection.vehicleId.value!),
          planId: selection.slot.planId,
        );
      }).toList();

      final params = CreateSubscriptionParams(slots: slotParams);
      final result = await createSubscriptionsUsecase.execute(params);

      result.fold(
        (failure) => ErrorHandler.showError('Error', failure.message),
        (response) {
          if (response.invoice == null) {
            Get.off(
              () => const PaymentSuccessView(),
              arguments: PaymentSuccessArgs(
                subscriptions: response.subscriptions,
                invoice: response.invoice,
              ),
            );
          } else {
            Get.toNamed(
              Routes.PAYMENT,
              arguments: PaymentArgs(response: response, yardName: yardName),
            );
          }
        },
      );
    } catch (_) {
      ErrorHandler.showError(
        'Error',
        'Something went wrong. Please try again.',
      );
    } finally {
      _isSubmitting.value = false;
    }
  }
}
