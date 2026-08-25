import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/errors/exceptions.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/datasources/vehicle_charge_remote_datasource.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';
import 'package:ts_parking/app/data/models/vehicle_charge_model.dart';
import 'package:ts_parking/app/data/repositories/vehicle_charge_repository_impl.dart';
import 'package:ts_parking/app/domain/params/pay_overstay_charge_params.dart';

class FakeVehicleChargeDataSource implements IVehicleChargeDataSource {
  PaginatedResponse<VehicleChargeModel>? getChargesResult;
  Exception? getChargesError;
  bool payChargeCalled = false;
  Exception? payChargeError;

  @override
  Future<PaginatedResponse<VehicleChargeModel>> getVehicleCharges({
    int page = 1,
    int limit = 20,
  }) async {
    if (getChargesError != null) throw getChargesError!;
    return getChargesResult!;
  }

  @override
  Future<void> payOverstayCharge(PayOverstayChargeParams params) async {
    payChargeCalled = true;
    if (payChargeError != null) throw payChargeError!;
  }
}

void main() {
  late FakeVehicleChargeDataSource fakeDataSource;
  late VehicleChargeRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeVehicleChargeDataSource();
    repository = VehicleChargeRepositoryImpl(dataSource: fakeDataSource);
  });

  group('getVehicleCharges', () {
    test('returns Right on success', () async {
      fakeDataSource.getChargesResult = const PaginatedResponse(
        data: [],
        meta: PaginationMeta.empty,
      );

      final result = await repository.getVehicleCharges();
      expect(result.isRight(), isTrue);
    });

    test('returns Left(ServerFailure) on ServerException', () async {
      fakeDataSource.getChargesError = ServerException('fail');

      final result = await repository.getVehicleCharges();
      expect(result, const Left(ServerFailure('fail')));
    });

    test('returns Left(NetworkFailure) on NetworkException', () async {
      fakeDataSource.getChargesError = NetworkException('offline');

      final result = await repository.getVehicleCharges();
      expect(result, const Left(NetworkFailure('offline')));
    });
  });

  group('payOverstayCharge', () {
    const params = PayOverstayChargeParams(
      chargeId: 1,
      paymentMethod: 'card',
      paymentToken: 'tok_test',
    );

    test('returns Right on success', () async {
      final result = await repository.payOverstayCharge(params);
      expect(result.isRight(), isTrue);
      expect(fakeDataSource.payChargeCalled, isTrue);
    });

    test('returns Left(AuthFailure) on AuthException', () async {
      fakeDataSource.payChargeError = AuthException('unauthorized');

      final result = await repository.payOverstayCharge(params);
      expect(result, const Left(AuthFailure('unauthorized')));
    });
  });
}
