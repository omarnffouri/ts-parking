import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/errors/exceptions.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/datasources/vehicle_remote_datasource.dart';
import 'package:ts_parking/app/data/models/vehicle_model.dart';
import 'package:ts_parking/app/data/models/vehicle_type_model.dart';
import 'package:ts_parking/app/data/repositories/vehicle_repository_impl.dart';
import 'package:ts_parking/app/core/enums/parking_vehicle_type.dart';
import 'package:ts_parking/app/domain/params/add_vehicle_params.dart';
import 'package:ts_parking/app/domain/params/update_vehicle_params.dart';

class FakeVehicleDataSource implements IVehicleDataSource {
  List<VehicleTypeModel>? getVehicleTypesResult;
  Exception? getVehicleTypesError;
  List<VehicleModel>? getVehiclesResult;
  Exception? getVehiclesError;
  VehicleModel? addVehicleResult;
  Exception? addVehicleError;
  VehicleModel? updateVehicleResult;
  Exception? updateVehicleError;
  Exception? deleteVehicleError;
  String? deletedVehicleId;

  @override
  Future<List<VehicleTypeModel>> getVehicleTypes() async {
    if (getVehicleTypesError != null) throw getVehicleTypesError!;
    return getVehicleTypesResult!;
  }

  @override
  Future<List<VehicleModel>> getVehicles() async {
    if (getVehiclesError != null) throw getVehiclesError!;
    return getVehiclesResult!;
  }

  @override
  Future<VehicleModel> addVehicle(AddVehicleParams params) async {
    if (addVehicleError != null) throw addVehicleError!;
    return addVehicleResult!;
  }

  @override
  Future<VehicleModel> updateVehicle(UpdateVehicleParams params) async {
    if (updateVehicleError != null) throw updateVehicleError!;
    return updateVehicleResult!;
  }

  @override
  Future<void> deleteVehicle(String vehicleId) async {
    deletedVehicleId = vehicleId;
    if (deleteVehicleError != null) throw deleteVehicleError!;
  }
}

const _vehicleType = VehicleTypeModel(id: 1, name: 'Truck', price: 25.0);
final _vehicle = VehicleModel(
  id: '10',
  userId: '1',
  vehicleTypeId: 1,
  vehicleType: ParkingVehicleType.truck,
  vehicleTypeName: 'Truck',
  licensePlate: 'ABC-1234',
  createdAt: DateTime(2025, 1, 1),
);
const _addParams = AddVehicleParams(
  vehicleTypeId: 1,
  licensePlate: 'ABC-1234',
  nickname: 'Big Red',
);
const _updateParams = UpdateVehicleParams(id: '10', licensePlate: 'XYZ-9999');

void main() {
  late FakeVehicleDataSource fakeDataSource;
  late VehicleRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeVehicleDataSource();
    repository = VehicleRepositoryImpl(dataSource: fakeDataSource);
  });

  group('getVehicleTypes', () {
    test('returns Right(list) on success', () async {
      fakeDataSource.getVehicleTypesResult = [_vehicleType];
      final result = await repository.getVehicleTypes();
      expect(result, isA<Right>());
      result.fold((_) => fail('Expected Right'), (t) {
        expect(t.length, 1);
        expect(t.first.name, 'Truck');
      });
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.getVehicleTypesError = const ServerException(
        'types failed',
      );
      expect(
        await repository.getVehicleTypes(),
        const Left(ServerFailure('types failed')),
      );
    });
    test('returns Left(AuthFailure) on AuthException', () async {
      fakeDataSource.getVehicleTypesError = const AuthException('no auth');
      expect(
        await repository.getVehicleTypes(),
        const Left(AuthFailure('no auth')),
      );
    });
    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeDataSource.getVehicleTypesError = const NetworkException('offline');
      expect(
        await repository.getVehicleTypes(),
        const Left(NetworkFailure('offline')),
      );
    });
    test('returns Left(UnexpectedFailure) on unknown exception', () async {
      fakeDataSource.getVehicleTypesError = Exception('unexpected');
      expect(
        await repository.getVehicleTypes(),
        const Left(UnexpectedFailure('An unexpected error occurred')),
      );
    });
  });

  group('getVehicles', () {
    test('returns Right(list) on success', () async {
      fakeDataSource.getVehiclesResult = [_vehicle];
      final result = await repository.getVehicles();
      expect(result, isA<Right>());
      result.fold((_) => fail('Expected Right'), (v) {
        expect(v.length, 1);
        expect(v.first.licensePlate, 'ABC-1234');
      });
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.getVehiclesError = const ServerException(
        'vehicles failed',
      );
      expect(
        await repository.getVehicles(),
        const Left(ServerFailure('vehicles failed')),
      );
    });
    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeDataSource.getVehiclesError = const NetworkException('timeout');
      expect(
        await repository.getVehicles(),
        const Left(NetworkFailure('timeout')),
      );
    });
  });

  group('addVehicle', () {
    test('returns Right(vehicle) on success', () async {
      fakeDataSource.addVehicleResult = _vehicle;
      final result = await repository.addVehicle(_addParams);
      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Expected Right'),
        (v) => expect(v.licensePlate, 'ABC-1234'),
      );
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.addVehicleError = const ServerException('add failed');
      expect(
        await repository.addVehicle(_addParams),
        const Left(ServerFailure('add failed')),
      );
    });
    test('returns Left(AuthFailure) on AuthException', () async {
      fakeDataSource.addVehicleError = const AuthException('unauth');
      expect(
        await repository.addVehicle(_addParams),
        const Left(AuthFailure('unauth')),
      );
    });
    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeDataSource.addVehicleError = const NetworkException('net err');
      expect(
        await repository.addVehicle(_addParams),
        const Left(NetworkFailure('net err')),
      );
    });
  });

  group('updateVehicle', () {
    test('returns Right(vehicle) on success', () async {
      final updated = VehicleModel(
        id: '10',
        userId: '1',
        vehicleTypeId: 1,
        vehicleType: ParkingVehicleType.truck,
        vehicleTypeName: 'Truck',
        licensePlate: 'XYZ-9999',
        createdAt: DateTime(2025, 1, 1),
      );
      fakeDataSource.updateVehicleResult = updated;
      final result = await repository.updateVehicle(_updateParams);
      expect(result, isA<Right>());
      result.fold(
        (_) => fail('Expected Right'),
        (v) => expect(v.licensePlate, 'XYZ-9999'),
      );
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.updateVehicleError = const ServerException(
        'update failed',
      );
      expect(
        await repository.updateVehicle(_updateParams),
        const Left(ServerFailure('update failed')),
      );
    });
  });

  group('deleteVehicle', () {
    test('returns Right(void) on success', () async {
      final result = await repository.deleteVehicle('10');
      expect(result, isA<Right>());
      expect(fakeDataSource.deletedVehicleId, '10');
    });
    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.deleteVehicleError = const ServerException(
        'delete failed',
      );
      expect(
        await repository.deleteVehicle('10'),
        const Left(ServerFailure('delete failed')),
      );
    });
    test('returns Left(AuthFailure) on AuthException', () async {
      fakeDataSource.deleteVehicleError = const AuthException('no auth');
      expect(
        await repository.deleteVehicle('10'),
        const Left(AuthFailure('no auth')),
      );
    });
    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeDataSource.deleteVehicleError = const NetworkException('offline');
      expect(
        await repository.deleteVehicle('10'),
        const Left(NetworkFailure('offline')),
      );
    });
    test('returns Left(UnexpectedFailure) on unknown exception', () async {
      fakeDataSource.deleteVehicleError = FormatException('bad');
      expect(
        await repository.deleteVehicle('10'),
        const Left(UnexpectedFailure('An unexpected error occurred')),
      );
    });
  });
}
