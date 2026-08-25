import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../../data/models/paginated_response.dart';
import '../entities/vehicle_charge_entity.dart';
import '../repositories/vehicle_charge_repository.dart';

class GetVehicleChargesUsecase {
  final IVehicleChargeRepository repository;

  GetVehicleChargesUsecase(this.repository);

  Future<Either<Failure, PaginatedResponse<VehicleChargeEntity>>> execute({
    int page = 1,
    int limit = 20,
  }) {
    return repository.getVehicleCharges(page: page, limit: limit);
  }
}
