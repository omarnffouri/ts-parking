import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';
import 'package:ts_parking/app/domain/entities/slot_entity.dart';
import 'package:ts_parking/app/domain/entities/yard_entity.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';
import 'package:ts_parking/app/domain/usecases/get_pricing_plans_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_vehicle_types_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_yard_slots_usecase.dart';
import 'package:ts_parking/app/modules/slot_selection/controllers/slot_selection_controller.dart';
import 'package:ts_parking/app/modules/slot_selection/views/slot_selection_view.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  late MockIYardRepository mockRepo;
  late MockIVehicleRepository mockVehicleRepo;

  const yard = YardEntity(
    id: 'yard-1',
    name: 'Main Yard',
    address: '123 Yard St',
    latitude: 0,
    longitude: 0,
    capacityTotal: 20,
    availableSlots: 15,
    status: 'approved',
  );

  const truckSlots = [
    SlotEntity(
      id: 1,
      zoneId: 10,
      slotCode: 'A1',
      status: SlotStatus.available,
      vehicleTypeId: 1,
      vehicleTypeName: 'Truck',
      zoneName: 'Zone A',
      planId: 1,
      planName: 'vip',
      planPrice: 45,
      price: 45,
      priceBeforeDiscount: 45,
      discount: 0,
    ),
    SlotEntity(
      id: 2,
      zoneId: 10,
      slotCode: 'A2',
      status: SlotStatus.booked,
      vehicleTypeId: 1,
      vehicleTypeName: 'Truck',
      zoneName: 'Zone A',
      planId: 1,
      planName: 'Basic',
      planPrice: 45,
      price: 45,
      priceBeforeDiscount: 45,
      discount: 0,
    ),
    SlotEntity(
      id: 3,
      zoneId: 11,
      slotCode: 'B1',
      status: SlotStatus.available,
      vehicleTypeId: 1,
      vehicleTypeName: 'Truck',
      zoneName: 'Zone B',
      planId: 2,
      planName: 'Premium',
      planPrice: 55,
      price: 55,
      priceBeforeDiscount: 55,
      discount: 0,
    ),
    SlotEntity(
      id: 4,
      zoneId: 11,
      slotCode: 'B2',
      status: SlotStatus.booked,
      vehicleTypeId: 1,
      vehicleTypeName: 'Truck',
      zoneName: 'Zone B',
      planId: 2,
      planName: 'Premium',
      planPrice: 55,
      price: 55,
      priceBeforeDiscount: 55,
      discount: 0,
    ),
    SlotEntity(
      id: 5,
      zoneId: 12,
      slotCode: 'C1',
      status: SlotStatus.available,
      vehicleTypeId: 2,
      vehicleTypeName: 'Trailer',
      zoneName: 'Zone C',
      planId: 3,
      planName: 'Monthly',
      planPrice: 75,
      price: 75,
      priceBeforeDiscount: 75,
      discount: 0,
    ),
  ];

  PaginatedResponse<SlotEntity> paginatedSlots(List<SlotEntity> slots) {
    return PaginatedResponse<SlotEntity>(
      data: slots,
      meta: PaginationMeta(
        total: slots.length,
        page: 1,
        limit: 300,
        totalPages: 1,
        hasMore: false,
      ),
    );
  }

  void stubGetYardSlots(
    MockIYardRepository repo, {
    required Either<Failure, PaginatedResponse<SlotEntity>> result,
  }) {
    when(
      repo.getYardSlots(
        yardId: anyNamed('yardId'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer((_) async => result);
  }

  setUp(() {
    mockRepo = MockIYardRepository();
    mockVehicleRepo = MockIVehicleRepository();
    when(
      mockVehicleRepo.getVehicleTypes(),
    ).thenAnswer((_) async => const Right([]));
    Get.testMode = true;
  });

  tearDown(() async {
    Get.reset();
  });

  testWidgets('switching vehicle type updates title, count, and zones', (
    tester,
  ) async {
    stubGetYardSlots(mockRepo, result: Right(paginatedSlots(truckSlots)));

    final controller = await _pumpSlotSelection(
      tester,
      mockRepo: mockRepo,
      mockVehicleRepo: mockVehicleRepo,
      yard: yard,
    );

    expect(find.text('Book Truck Parking'), findsOneWidget);
    expect(find.text('2 slots available'), findsOneWidget);
    // First zone (Zone A) has no header key — isFirst skips it
    expect(find.byKey(const ValueKey('zone_section_Zone A')), findsNothing);
    expect(find.byKey(const ValueKey('zone_section_Zone B')), findsOneWidget);
    expect(controller.groupedSlots.map((group) => group.zoneName), [
      'Zone A',
      'Zone B',
    ]);

    await tester.tap(find.text('Trailer'));
    await tester.pumpAndSettle();

    expect(find.text('Book Trailer Parking'), findsOneWidget);
    expect(find.text('1 slot available'), findsOneWidget);
    // Zone C is the only zone so it's index 0 — no header key
    expect(find.byKey(const ValueKey('zone_section_Zone C')), findsNothing);
    expect(controller.groupedSlots.map((group) => group.zoneName), ['Zone C']);
  });

  testWidgets('controller helpers expose primary selection and total price', (
    tester,
  ) async {
    stubGetYardSlots(mockRepo, result: Right(paginatedSlots(truckSlots)));

    final controller = await _pumpSlotSelection(
      tester,
      mockRepo: mockRepo,
      mockVehicleRepo: mockVehicleRepo,
      yard: yard,
    );

    await tester.tap(find.byKey(const ValueKey('slot_tile_1')));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('slot_tile_3')));
    await tester.tap(find.byKey(const ValueKey('slot_tile_3')));
    await tester.pumpAndSettle();

    expect(controller.primarySelectedSlot?.slotCode, 'A1');
    expect(controller.selectedTotalPrice, 100);
    expect(find.text('2 Slots Selected'), findsOneWidget);
    expect(find.text('Book 2 Slots - \$100'), findsOneWidget);
  });

  testWidgets('available only toggle hides occupied and reserved slots', (
    tester,
  ) async {
    stubGetYardSlots(mockRepo, result: Right(paginatedSlots(truckSlots)));

    final controller = await _pumpSlotSelection(
      tester,
      mockRepo: mockRepo,
      mockVehicleRepo: mockVehicleRepo,
      yard: yard,
    );

    expect(find.byKey(const ValueKey('slot_tile_1')), findsOneWidget);
    expect(find.byKey(const ValueKey('slot_tile_2')), findsOneWidget);
    expect(find.byKey(const ValueKey('slot_tile_3')), findsOneWidget);
    expect(find.byKey(const ValueKey('slot_tile_4')), findsOneWidget);

    controller.setAvailableOnly(true);
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('slot_tile_1')), findsOneWidget);
    expect(find.byKey(const ValueKey('slot_tile_3')), findsOneWidget);
    expect(find.byKey(const ValueKey('slot_tile_2')), findsNothing);
    expect(find.byKey(const ValueKey('slot_tile_4')), findsNothing);
  });

  testWidgets('vip slots show a small star badge', (tester) async {
    stubGetYardSlots(mockRepo, result: Right(paginatedSlots(truckSlots)));

    await _pumpSlotSelection(
      tester,
      mockRepo: mockRepo,
      mockVehicleRepo: mockVehicleRepo,
      yard: yard,
    );

    expect(find.byKey(const ValueKey('slot_vip_1')), findsOneWidget);
    expect(find.byKey(const ValueKey('slot_vip_2')), findsNothing);
    expect(find.byKey(const ValueKey('slot_vip_3')), findsNothing);
  });

  testWidgets('summary card and CTA update for single and multi select', (
    tester,
  ) async {
    stubGetYardSlots(mockRepo, result: Right(paginatedSlots(truckSlots)));

    final controller = await _pumpSlotSelection(
      tester,
      mockRepo: mockRepo,
      mockVehicleRepo: mockVehicleRepo,
      yard: yard,
    );

    expect(find.byKey(const ValueKey('selection_summary_card')), findsNothing);

    await tester.tap(find.byKey(const ValueKey('slot_tile_1')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('selection_summary_card')),
      findsOneWidget,
    );
    expect(find.text('Slot A1'), findsOneWidget);
    expect(find.text('Book A1 - \$45'), findsOneWidget);

    await tester.ensureVisible(find.byKey(const ValueKey('slot_tile_3')));
    await tester.tap(find.byKey(const ValueKey('slot_tile_3')));
    await tester.pumpAndSettle();

    expect(find.text('2 Slots Selected'), findsOneWidget);
    expect(find.text('Book 2 Slots - \$100'), findsOneWidget);

    controller.toggleSlot(truckSlots[0]);
    await tester.pumpAndSettle();

    expect(find.text('Slot B1'), findsOneWidget);
    expect(find.text('Book B1 - \$55'), findsOneWidget);
  });

  testWidgets('renders loading, error, and empty states', (tester) async {
    final completer =
        Completer<Either<Failure, PaginatedResponse<SlotEntity>>>();
    when(
      mockRepo.getYardSlots(
        yardId: anyNamed('yardId'),
        page: anyNamed('page'),
        limit: anyNamed('limit'),
      ),
    ).thenAnswer((_) => completer.future);

    await _pumpSlotSelection(
      tester,
      mockRepo: mockRepo,
      mockVehicleRepo: mockVehicleRepo,
      yard: yard,
      settle: false,
    );

    expect(
      find.byKey(const ValueKey('slot_selection_loading')),
      findsOneWidget,
    );

    completer.complete(Right(paginatedSlots(const [])));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('slot_selection_empty')), findsOneWidget);

    Get.reset();
    mockRepo = MockIYardRepository();
    mockVehicleRepo = MockIVehicleRepository();
    when(
      mockVehicleRepo.getVehicleTypes(),
    ).thenAnswer((_) async => const Right([]));
    stubGetYardSlots(
      mockRepo,
      result: const Left(ServerFailure('slots failed')),
    );

    await _pumpSlotSelection(
      tester,
      mockRepo: mockRepo,
      mockVehicleRepo: mockVehicleRepo,
      yard: yard,
    );

    expect(find.byKey(const ValueKey('slot_selection_error')), findsOneWidget);
    expect(find.text('Try again'), findsOneWidget);
  });
}

Future<SlotSelectionController> _pumpSlotSelection(
  WidgetTester tester, {
  required MockIYardRepository mockRepo,
  required MockIVehicleRepository mockVehicleRepo,
  required YardEntity yard,
  bool settle = true,
}) async {
  final usecase = GetYardSlotsUsecase(mockRepo);
  final vehicleTypesUsecase = GetVehicleTypesUsecase(mockVehicleRepo);
  final pricingPlansUsecase = GetPricingPlansUsecase(mockRepo);
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(430, 932);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  final controller = Get.put(
    SlotSelectionController(
      getYardSlotsUsecase: usecase,
      getVehicleTypesUsecase: vehicleTypesUsecase,
      getPricingPlansUsecase: pricingPlansUsecase,
      initialArguments: yard,
    ),
  );

  await tester.pumpWidget(
    GetMaterialApp(
      theme: ThemeData.dark(),
      defaultTransition: Transition.noTransition,
      home: const SlotSelectionView(),
    ),
  );

  await tester.pump();

  if (settle) {
    await tester.pumpAndSettle();
  }

  return controller;
}
