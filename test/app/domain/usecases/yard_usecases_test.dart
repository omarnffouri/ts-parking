import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';
import 'package:ts_parking/app/domain/entities/pricing_plan_entity.dart';
import 'package:ts_parking/app/domain/entities/yard_entity.dart';
import 'package:ts_parking/app/domain/entities/slot_entity.dart';
import 'package:ts_parking/app/core/enums/slot_status_enum.dart';
import 'package:ts_parking/app/domain/entities/zone_entity.dart';
import 'package:ts_parking/app/domain/usecases/get_pricing_plans_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_yard_slots_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_yard_zones_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_yards_usecase.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  // ---------------------------------------------------------------------------
  // GetYardsUsecase
  // ---------------------------------------------------------------------------
  group('GetYardsUsecase', () {
    late MockIYardRepository mockRepo;
    late GetYardsUsecase usecase;

    setUp(() {
      mockRepo = MockIYardRepository();
      usecase = GetYardsUsecase(mockRepo);
    });

    test('delegates to repository.getYards and returns result', () async {
      final expected = PaginatedResponse<YardEntity>(
        data: const [
          YardEntity(
            id: 'y1',
            name: 'Main Yard',
            address: '123 Main St',
            latitude: 24.7136,
            longitude: 46.6753,
            capacityTotal: 20,
            availableSlots: 15,
            status: 'approved',
          ),
        ],
        meta: const PaginationMeta(
          total: 1,
          page: 1,
          limit: 20,
          totalPages: 1,
          hasMore: false,
        ),
      );
      when(
        mockRepo.getYards(page: 1, limit: 20),
      ).thenAnswer((_) async => Right(expected));

      final result = await usecase.execute(page: 1, limit: 20);

      expect(result, Right(expected));
      verify(mockRepo.getYards(page: 1, limit: 20)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('yards fetch failed');
      when(
        mockRepo.getYards(page: anyNamed('page'), limit: anyNamed('limit')),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute();

      expect(result, const Left(failure));
      verify(
        mockRepo.getYards(page: anyNamed('page'), limit: anyNamed('limit')),
      ).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // GetYardDetailUsecase
  // ---------------------------------------------------------------------------
  // GetYardSlotsUsecase
  // ---------------------------------------------------------------------------
  group('GetYardSlotsUsecase', () {
    late MockIYardRepository mockRepo;
    late GetYardSlotsUsecase usecase;

    setUp(() {
      mockRepo = MockIYardRepository();
      usecase = GetYardSlotsUsecase(mockRepo);
    });

    test('delegates to repository.getYardSlots and returns result', () async {
      final expected = PaginatedResponse<SlotEntity>(
        data: [
          SlotEntity(
            id: 1,
            zoneId: 10,
            slotCode: 'A-01',
            status: SlotStatus.available,
            vehicleTypeId: 1,
            vehicleTypeName: 'Truck',
            zoneName: 'Zone A',
            planId: 1,
            planName: 'Basic',
            planPrice: 10.0,
            price: 10.0,
            priceBeforeDiscount: 10.0,
            discount: 0.0,
          ),
        ],
        meta: const PaginationMeta(
          total: 1,
          page: 1,
          limit: 300,
          totalPages: 1,
          hasMore: false,
        ),
      );
      when(
        mockRepo.getYardSlots(
          yardId: 'y1',
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => Right(expected));

      final result = await usecase.execute(yardId: 'y1');

      expect(result, Right(expected));
      verify(
        mockRepo.getYardSlots(
          yardId: 'y1',
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        ),
      ).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('slots fetch failed');
      when(
        mockRepo.getYardSlots(
          yardId: 'y1',
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute(yardId: 'y1');

      expect(result, const Left(failure));
      verify(
        mockRepo.getYardSlots(
          yardId: 'y1',
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        ),
      ).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // GetPricingPlansUsecase
  // ---------------------------------------------------------------------------
  group('GetPricingPlansUsecase', () {
    late MockIYardRepository mockRepo;
    late GetPricingPlansUsecase usecase;

    setUp(() {
      mockRepo = MockIYardRepository();
      usecase = GetPricingPlansUsecase(mockRepo);
    });

    test(
      'delegates to repository.getPricingPlans and returns result',
      () async {
        const expected = [
          PricingPlanEntity(id: 'plan-1', name: 'Monthly Basic', price: 500.0),
          PricingPlanEntity(
            id: 'plan-2',
            name: 'Monthly Premium',
            description: 'Includes covered parking',
            price: 800.0,
          ),
        ];
        when(
          mockRepo.getPricingPlans(),
        ).thenAnswer((_) async => const Right(expected));

        final result = await usecase.execute();

        expect(result, const Right(expected));
        verify(mockRepo.getPricingPlans()).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test('returns failure from repository', () async {
      const failure = ServerFailure('pricing plans fetch failed');
      when(
        mockRepo.getPricingPlans(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute();

      expect(result, const Left(failure));
      verify(mockRepo.getPricingPlans()).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // GetYardZonesUsecase
  // ---------------------------------------------------------------------------
  group('GetYardZonesUsecase', () {
    late MockIYardRepository mockRepo;
    late GetYardZonesUsecase usecase;

    setUp(() {
      mockRepo = MockIYardRepository();
      usecase = GetYardZonesUsecase(mockRepo);
    });

    test('delegates to repository and returns zones', () async {
      const zones = [
        ZoneEntity(id: '1', name: 'Zone A'),
        ZoneEntity(id: '2', name: 'Zone B'),
      ];
      when(
        mockRepo.getYardZones('yard-1'),
      ).thenAnswer((_) async => const Right(zones));

      final result = await usecase.execute('yard-1');
      result.fold(
        (_) => fail('expected Right'),
        (data) => expect(data, hasLength(2)),
      );
      verify(mockRepo.getYardZones('yard-1')).called(1);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('not found');
      when(
        mockRepo.getYardZones('yard-1'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute('yard-1');
      expect(result, const Left(failure));
    });
  });
}
