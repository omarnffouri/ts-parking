import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/vehicle_entity.dart';
import '../params/update_vehicle_params.dart';
import '../repositories/vehicle_repository.dart';

class UpdateVehicleUsecase {
  final IVehicleRepository repository;

  UpdateVehicleUsecase(this.repository);

  Future<Either<Failure, VehicleEntity>> execute(
    UpdateVehicleParams params,
  ) async {
    return await repository.updateVehicle(params);
  }
}
