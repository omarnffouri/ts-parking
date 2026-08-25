import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/domain/entities/vehicle_entity.dart';
import 'package:ts_parking/app/domain/entities/vehicle_type_entity.dart';
import 'package:ts_parking/app/core/enums/parking_vehicle_type.dart';
import 'package:ts_parking/app/domain/params/add_vehicle_params.dart';
import 'package:ts_parking/app/domain/params/update_vehicle_params.dart';
import 'package:ts_parking/app/domain/usecases/add_vehicle_usecase.dart';
import 'package:ts_parking/app/domain/usecases/delete_vehicle_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_vehicle_types_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_vehicles_usecase.dart';
import 'package:ts_parking/app/domain/usecases/update_vehicle_usecase.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  // ---------------------------------------------------------------------------
  // GetVehiclesUsecase
  // ---------------------------------------------------------------------------
  group('GetVehiclesUsecase', () {
    late MockIVehicleRepository mockRepo;
    late GetVehiclesUsecase usecase;

    setUp(() {
      mockRepo = MockIVehicleRepository();
      usecase = GetVehiclesUsecase(mockRepo);
    });

    test('delegates to repository.getVehicles and returns result', () async {
      final expected = [
        VehicleEntity(
          id: 'v1',
          userId: 'u1',
          vehicleTypeId: 1,
          vehicleType: ParkingVehicleType.truck,
          vehicleTypeName: 'Truck',
          licensePlate: 'ABC-123',
          createdAt: DateTime(2024, 1, 15),
        ),
      ];
      when(mockRepo.getVehicles()).thenAnswer((_) async => Right(expected));

      final result = await usecase.execute();

      expect(result, Right(expected));
      verify(mockRepo.getVehicles()).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('vehicles fetch failed');
      when(mockRepo.getVehicles()).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute();

      expect(result, const Left(failure));
      verify(mockRepo.getVehicles()).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // AddVehicleUsecase
  // ---------------------------------------------------------------------------
  group('AddVehicleUsecase', () {
    late MockIVehicleRepository mockRepo;
    late AddVehicleUsecase usecase;

    setUp(() {
      mockRepo = MockIVehicleRepository();
      usecase = AddVehicleUsecase(mockRepo);
    });

    test('delegates to repository.addVehicle and returns result', () async {
      final expected = VehicleEntity(
        id: 'v-new',
        userId: 'u1',
        vehicleTypeId: 2,
        vehicleType: ParkingVehicleType.trailer,
        vehicleTypeName: 'Trailer',
        licensePlate: 'XYZ-789',
        createdAt: DateTime(2024, 6, 1),
      );
      const params = AddVehicleParams(
        vehicleTypeId: 2,
        licensePlate: 'XYZ-789',
      );
      when(
        mockRepo.addVehicle(params),
      ).thenAnswer((_) async => Right(expected));

      final result = await usecase.execute(params);

      expect(result, Right(expected));
      verify(mockRepo.addVehicle(params)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('add vehicle failed');
      const params = AddVehicleParams(
        vehicleTypeId: 1,
        licensePlate: 'BAD-000',
      );
      when(
        mockRepo.addVehicle(params),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute(params);

      expect(result, const Left(failure));
      verify(mockRepo.addVehicle(params)).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // UpdateVehicleUsecase
  // ---------------------------------------------------------------------------
  group('UpdateVehicleUsecase', () {
    late MockIVehicleRepository mockRepo;
    late UpdateVehicleUsecase usecase;

    setUp(() {
      mockRepo = MockIVehicleRepository();
      usecase = UpdateVehicleUsecase(mockRepo);
    });

    test('delegates to repository.updateVehicle and returns result', () async {
      final expected = VehicleEntity(
        id: 'v1',
        userId: 'u1',
        vehicleTypeId: 1,
        vehicleType: ParkingVehicleType.truck,
        vehicleTypeName: 'Truck',
        licensePlate: 'UPD-111',
        createdAt: DateTime(2024, 1, 15),
      );
      const params = UpdateVehicleParams(
        id: 'v1',
        licensePlate: 'UPD-111',
        nickname: 'My Truck',
      );
      when(
        mockRepo.updateVehicle(params),
      ).thenAnswer((_) async => Right(expected));

      final result = await usecase.execute(params);

      expect(result, Right(expected));
      verify(mockRepo.updateVehicle(params)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('update vehicle failed');
      const params = UpdateVehicleParams(id: 'v1');
      when(
        mockRepo.updateVehicle(params),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute(params);

      expect(result, const Left(failure));
      verify(mockRepo.updateVehicle(params)).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // DeleteVehicleUsecase
  // ---------------------------------------------------------------------------
  group('DeleteVehicleUsecase', () {
    late MockIVehicleRepository mockRepo;
    late DeleteVehicleUsecase usecase;

    setUp(() {
      mockRepo = MockIVehicleRepository();
      usecase = DeleteVehicleUsecase(mockRepo);
    });

    test('delegates to repository.deleteVehicle and returns result', () async {
      when(
        mockRepo.deleteVehicle('v-del'),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute('v-del');

      result.fold(
        (failure) => fail('expected Right but got Left($failure)'),
        (_) => expect(true, isTrue),
      );
      verify(mockRepo.deleteVehicle('v-del')).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('delete vehicle failed');
      when(
        mockRepo.deleteVehicle('v-del'),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute('v-del');

      expect(result, const Left(failure));
      verify(mockRepo.deleteVehicle('v-del')).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // GetVehicleTypesUsecase
  // ---------------------------------------------------------------------------
  group('GetVehicleTypesUsecase', () {
    late MockIVehicleRepository mockRepo;
    late GetVehicleTypesUsecase usecase;

    setUp(() {
      mockRepo = MockIVehicleRepository();
      usecase = GetVehicleTypesUsecase(mockRepo);
    });

    test(
      'delegates to repository.getVehicleTypes and returns result',
      () async {
        const expected = [
          VehicleTypeEntity(id: 1, name: 'Truck', price: 50.0),
          VehicleTypeEntity(id: 2, name: 'Trailer', price: 40.0),
          VehicleTypeEntity(id: 3, name: 'Bobtail', price: 35.0),
        ];
        when(
          mockRepo.getVehicleTypes(),
        ).thenAnswer((_) async => const Right(expected));

        final result = await usecase.execute();

        expect(result, const Right(expected));
        verify(mockRepo.getVehicleTypes()).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test('returns failure from repository', () async {
      const failure = ServerFailure('vehicle types fetch failed');
      when(
        mockRepo.getVehicleTypes(),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute();

      expect(result, const Left(failure));
      verify(mockRepo.getVehicleTypes()).called(1);
    });
  });
}
