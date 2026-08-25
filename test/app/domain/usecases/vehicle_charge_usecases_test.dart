import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';
import 'package:ts_parking/app/domain/params/pay_overstay_charge_params.dart';
import 'package:ts_parking/app/domain/usecases/get_vehicle_charges_usecase.dart';
import 'package:ts_parking/app/domain/usecases/pay_overstay_charge_usecase.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  group('GetVehicleChargesUsecase', () {
    late MockIVehicleChargeRepository mockRepo;
    late GetVehicleChargesUsecase usecase;

    setUp(() {
      mockRepo = MockIVehicleChargeRepository();
      usecase = GetVehicleChargesUsecase(mockRepo);
    });

    test('delegates to repository and returns result', () async {
      when(mockRepo.getVehicleCharges(page: 1, limit: 20)).thenAnswer(
        (_) async => const Right(
          PaginatedResponse(data: [], meta: PaginationMeta.empty),
        ),
      );

      final result = await usecase.execute();
      expect(result.isRight(), isTrue);
      verify(mockRepo.getVehicleCharges(page: 1, limit: 20)).called(1);
    });

    test('returns failure from repository', () async {
      when(
        mockRepo.getVehicleCharges(page: 1, limit: 20),
      ).thenAnswer((_) async => const Left(ServerFailure('fail')));

      final result = await usecase.execute();
      expect(result, const Left(ServerFailure('fail')));
    });
  });

  group('PayOverstayChargeUsecase', () {
    late MockIVehicleChargeRepository mockRepo;
    late PayOverstayChargeUsecase usecase;

    setUp(() {
      mockRepo = MockIVehicleChargeRepository();
      usecase = PayOverstayChargeUsecase(mockRepo);
    });

    test('delegates to repository', () async {
      const params = PayOverstayChargeParams(
        chargeId: 1,
        paymentMethod: 'card',
        paymentToken: 'tok_test',
      );
      when(
        mockRepo.payOverstayCharge(params),
      ).thenAnswer((_) async => const Right(null));

      final result = await usecase.execute(params);
      expect(result.isRight(), isTrue);
      verify(mockRepo.payOverstayCharge(params)).called(1);
    });

    test('returns failure from repository', () async {
      const params = PayOverstayChargeParams(
        chargeId: 1,
        paymentMethod: 'cash',
      );
      when(
        mockRepo.payOverstayCharge(params),
      ).thenAnswer((_) async => const Left(AuthFailure('unauthorized')));

      final result = await usecase.execute(params);
      expect(result, const Left(AuthFailure('unauthorized')));
    });
  });
}
