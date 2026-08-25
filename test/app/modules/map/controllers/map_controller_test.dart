import 'dart:ui';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';
import 'package:ts_parking/app/domain/entities/pricing_plan_entity.dart';
import 'package:ts_parking/app/domain/entities/slot_entity.dart';
import 'package:ts_parking/app/domain/entities/yard_entity.dart';
import 'package:ts_parking/app/domain/entities/zone_entity.dart';
import 'package:ts_parking/app/domain/repositories/yard_repository.dart';
import 'package:ts_parking/app/domain/usecases/get_yard_slots_usecase.dart';
import 'package:ts_parking/app/modules/map/controllers/map_controller.dart';
import 'package:ts_parking/app/modules/map/models/floorplan_config.dart';

void main() {
  testWidgets('focusZone zooms tighter around zone slot content', (
    tester,
  ) async {
    final slots = [
      ..._slotsForZone(zoneId: 5, direction: 'north', prefix: 'N-', count: 10),
      ..._slotsForZone(zoneId: 3, direction: 'west', prefix: 'W-', count: 40),
      ..._slotsForZone(zoneId: 6, direction: 'middle', prefix: 'B', count: 80),
      ..._slotsForZone(zoneId: 4, direction: 'south', prefix: 'S-', count: 60),
    ];
    final controller = MapController(
      getYardSlotsUsecase: GetYardSlotsUsecase(_FakeYardRepository(slots)),
      initialArguments: 'yard-1',
      mapConfig: ParkingMapConfig.primary,
    );

    addTearDown(controller.onClose);
    controller.onInit();

    await tester.pump();
    await tester.pump();

    controller.ensureViewport(const Size(430, 932));
    await tester.pump();

    final overviewScale = controller.transformationController.value
        .getMaxScaleOnAxis();
    final zone = controller.activeMapConfig.zones.singleWhere(
      (zone) => zone.id == '6',
    );

    controller.focusZone(zone);
    await tester.pumpAndSettle();

    expect(controller.focusedZoneId, '6');
    expect(
      controller.transformationController.value.getMaxScaleOnAxis(),
      greaterThan(overviewScale * 1.2),
    );
  });
}

class _FakeYardRepository implements IYardRepository {
  _FakeYardRepository(this.slots);

  final List<SlotEntity> slots;

  @override
  Future<Either<Failure, PaginatedResponse<SlotEntity>>> getYardSlots({
    required String yardId,
    int page = 1,
    int limit = 500,
  }) async {
    return Right(
      PaginatedResponse<SlotEntity>(
        data: slots,
        meta: const PaginationMeta(
          total: 190,
          page: 1,
          limit: 500,
          totalPages: 1,
          hasMore: false,
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, PaginatedResponse<YardEntity>>> getYards({
    int page = 1,
    int limit = 20,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<PricingPlanEntity>>> getPricingPlans() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<ZoneEntity>>> getYardZones(String yardId) {
    throw UnimplementedError();
  }
}

List<SlotEntity> _slotsForZone({
  required int zoneId,
  required String direction,
  required String prefix,
  required int count,
}) {
  return List<SlotEntity>.generate(
    count,
    (index) => _slot(
      id: index + 1,
      zoneId: zoneId,
      direction: direction,
      code: '$prefix${index + 1}',
    ),
    growable: false,
  );
}

SlotEntity _slot({
  required int id,
  required int zoneId,
  required String direction,
  required String code,
}) {
  return SlotEntity(
    id: id,
    zoneId: zoneId,
    slotCode: code,
    status: SlotStatus.available,
    backendStatus: 'available',
    vehicleTypeId: 1,
    vehicleTypeName: 'Truck',
    vehicleTypePrice: 150,
    zoneName: direction,
    zoneDirection: direction,
    zoneHorizontalCapacity: 0,
    zoneVerticalCapacity: 0,
    planId: 1,
    planName: 'standard',
    planPrice: 25,
    price: 25,
    priceBeforeDiscount: 25,
    discount: 0,
  );
}
