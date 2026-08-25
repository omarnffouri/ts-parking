import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../entities/vehicle_charge_entity.dart';
import '../params/pay_overstay_charge_params.dart';

abstract class IVehicleChargeRepository {
  Future<Either<Failure, PaginatedResponse<VehicleChargeEntity>>>
  getVehicleCharges({int page = 1, int limit = 20});

  Future<Either<Failure, void>> payOverstayCharge(
    PayOverstayChargeParams params,
  );
}
