import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../params/pay_overstay_charge_params.dart';
import '../repositories/vehicle_charge_repository.dart';

class PayOverstayChargeUsecase {
  final IVehicleChargeRepository repository;

  PayOverstayChargeUsecase(this.repository);

  Future<Either<Failure, void>> execute(PayOverstayChargeParams params) {
    return repository.payOverstayCharge(params);
  }
}
