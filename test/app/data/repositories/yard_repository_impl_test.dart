import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/errors/exceptions.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/datasources/yard_datasource.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';
import 'package:ts_parking/app/data/models/pricing_plan_model.dart';
import 'package:ts_parking/app/data/models/yard_model.dart';
import 'package:ts_parking/app/data/models/slot_model.dart';
import 'package:ts_parking/app/data/models/zone_model.dart';
import 'package:ts_parking/app/data/repositories/yard_repository_impl.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';

class FakeYardDataSource implements IYardDataSource {
  PaginatedResponse<YardModel>? getYardsResult;
  Exception? getYardsException;
  List<PricingPlanModel>? getPricingPlansResult;
  Exception? getPricingPlansException;
  PaginatedResponse<SlotModel>? getYardSlotsResult;
  Exception? getYardSlotsException;
  List<ZoneModel>? getYardZonesResult;
  Exception? getYardZonesException;

  @override
  Future<PaginatedResponse<YardModel>> getYards({
    int page = 1,
    int limit = 20,
  }) async {
    if (getYardsException != null) throw getYardsException!;
    return getYardsResult!;
  }

  @override
  Future<List<PricingPlanModel>> getPricingPlans() async {
    if (getPricingPlansException != null) throw getPricingPlansException!;
    return getPricingPlansResult!;
  }

  @override
  Future<PaginatedResponse<SlotModel>> getYardSlots({
    required String yardId,
    int page = 1,
    int limit = 300,
  }) async {
    if (getYardSlotsException != null) throw getYardSlotsException!;
    return getYardSlotsResult!;
  }

  @override
  Future<List<ZoneModel>> getYardZones(String yardId) async {
    if (getYardZonesException != null) throw getYardZonesException!;
    return getYardZonesResult!;
  }
}

YardModel _makeYard({String id = '1'}) {
  return YardModel(
    id: id,
    name: 'Test Yard',
    address: '123 Main St',
    latitude: 30.0,
    longitude: -90.0,
    capacityTotal: 10,
    availableSlots: 10,
    status: 'approved',
  );
}

SlotModel _makeSlot({int id = 1}) {
  return SlotModel(
    id: id,
    zoneId: 1,
    slotCode: 'A-$id',
    status: SlotStatus.available,
    vehicleTypeId: 1,
    vehicleTypeName: 'Truck',
    vehicleTypePrice: 0.0,
    zoneName: 'Zone A',
    zoneHorizontalCapacity: 0,
    zoneVerticalCapacity: 0,
    planId: 1,
    planName: 'Basic',
    planPrice: 10.0,
    price: 10.0,
    priceBeforeDiscount: 10.0,
    discount: 0.0,
  );
}

PricingPlanModel _makePlan({String id = '1'}) {
  return PricingPlanModel(id: id, name: 'Monthly', price: 100.0);
}

PaginatedResponse<YardModel> _makePaginatedYards() {
  return PaginatedResponse<YardModel>(
    data: [_makeYard()],
    meta: const PaginationMeta(
      total: 1,
      page: 1,
      limit: 20,
      totalPages: 1,
      hasMore: false,
    ),
  );
}

void main() {
  late FakeYardDataSource fakeDataSource;
  late YardRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeYardDataSource();
    repository = YardRepositoryImpl(dataSource: fakeDataSource);
  });

  group('getYards', () {
    test('returns paginated yards on success', () async {
      final expected = _makePaginatedYards();
      fakeDataSource.getYardsResult = expected;
      final result = await repository.getYards();
      expect(result, equals(Right(expected)));
    });

    test('returns ServerFailure on ServerException', () async {
      fakeDataSource.getYardsException = const ServerException('test error');

      final result = await repository.getYards();

      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns NetworkFailure on NetworkException', () async {
      fakeDataSource.getYardsException = const NetworkException('test error');

      final result = await repository.getYards();

      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns UnexpectedFailure on unknown exception', () async {
      fakeDataSource.getYardsException = Exception('oops');

      final result = await repository.getYards();

      result.fold(
        (failure) => expect(failure, isA<UnexpectedFailure>()),
        (_) => fail('expected Left'),
      );
    });
  });

  group('getPricingPlans', () {
    test('returns plans on success', () async {
      final plans = [_makePlan(), _makePlan(id: '2')];
      fakeDataSource.getPricingPlansResult = plans;
      final result = await repository.getPricingPlans();
      expect(result, equals(Right(plans)));
    });

    test('returns ServerFailure on ServerException', () async {
      fakeDataSource.getPricingPlansException = const ServerException(
        'test error',
      );

      final result = await repository.getPricingPlans();

      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns NetworkFailure on NetworkException', () async {
      fakeDataSource.getPricingPlansException = const NetworkException(
        'test error',
      );

      final result = await repository.getPricingPlans();

      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns UnexpectedFailure on unknown exception', () async {
      fakeDataSource.getPricingPlansException = Exception('oops');

      final result = await repository.getPricingPlans();

      result.fold(
        (failure) => expect(failure, isA<UnexpectedFailure>()),
        (_) => fail('expected Left'),
      );
    });
  });

  group('getYardSlots', () {
    PaginatedResponse<SlotModel> makePaginatedSlots() {
      return PaginatedResponse<SlotModel>(
        data: [_makeSlot(), _makeSlot(id: 2)],
        meta: const PaginationMeta(
          total: 2,
          page: 1,
          limit: 300,
          totalPages: 1,
          hasMore: false,
        ),
      );
    }

    test('returns slots on success', () async {
      final expected = makePaginatedSlots();
      fakeDataSource.getYardSlotsResult = expected;
      final result = await repository.getYardSlots(yardId: 'yard-1');
      expect(result, equals(Right(expected)));
    });

    test('returns ServerFailure on ServerException', () async {
      fakeDataSource.getYardSlotsException = const ServerException(
        'test error',
      );

      final result = await repository.getYardSlots(yardId: 'yard-1');

      result.fold(
        (failure) => expect(failure, isA<ServerFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns NetworkFailure on NetworkException', () async {
      fakeDataSource.getYardSlotsException = const NetworkException(
        'test error',
      );

      final result = await repository.getYardSlots(yardId: 'yard-1');

      result.fold(
        (failure) => expect(failure, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns UnexpectedFailure on unknown exception', () async {
      fakeDataSource.getYardSlotsException = Exception('oops');

      final result = await repository.getYardSlots(yardId: 'yard-1');

      result.fold(
        (failure) => expect(failure, isA<UnexpectedFailure>()),
        (_) => fail('expected Left'),
      );
    });
  });
}
