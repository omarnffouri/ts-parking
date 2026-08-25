import 'package:dartz/dartz.dart';

import '../../core/errors/failures.dart';
import '../entities/vehicle_entity.dart';
import '../params/add_vehicle_params.dart';
import '../repositories/vehicle_repository.dart';

class AddVehicleUsecase {
  final IVehicleRepository repository;

  AddVehicleUsecase(this.repository);

  Future<Either<Failure, VehicleEntity>> execute(
    AddVehicleParams params,
  ) async {
    return await repository.addVehicle(params);
  }
}
